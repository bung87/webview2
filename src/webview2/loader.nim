import winim
import com
import std/[os,strscans]
from winlean import useWinUnicode

type PACKAGE_VERSION {.pure.} = object 
  # Version:UINT64
  Revision: USHORT
  Build: USHORT
  Minor: USHORT
  Major: USHORT

# https://docs.microsoft.com/en-us/windows/win32/api/appmodel/ns-appmodel-package_id
type  PACKAGE_ID  {.pure.} = object 
  reserved: UINT32
  processorArchitecture:UINT32
  version:PACKAGE_VERSION 
  name:LPWSTR
  publisher:LPWSTR
  resourceId:LPWSTR
  publisherId:LPWSTR

# https://docs.microsoft.com/en-us/windows/win32/api/appmodel/ns-appmodel-package_info
type PACKAGE_INFO {.pure.} = object 
  reserved: UINT32
  flags:UINT32
  path:LPWSTR
  packageFullName:LPWSTR
  packageFamilyName:LPWSTR
  packageId:PACKAGE_ID

type GetCurrentPackageInfoProc = proc(flags: UINT32, bufferLength: ptr UINT32, buffer: ptr BYTE, count:ptr UINT32):ULONG {.gcsafe, stdcall.}

type WebView2ReleaseChannelPreference  = enum 
  kStable,
  kCanary

type WebView2RunTimeType = enum
  kInstalled = 0x0,
  kRedistributable 

const  kNumChannels = 5
const kChannelName = [
  "",
  "beta",
  "dev",
  "canary",
  "internal"
]
const kChannelUuid = [
    "{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}",
    "{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}",
    "{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}",
    "{65C35B14-6C1D-4122-AC46-7148CC9D6497}",
    "{BE59E8FD-089A-411B-A3B0-051D9E417818}"
]

const kChannelPackageFamilyName = [
  "Microsoft.WebView2Runtime.Stable_8wekyb3d8bbwe",
    "Microsoft.WebView2Runtime.Beta_8wekyb3d8bbwe",
    "Microsoft.WebView2Runtime.Dev_8wekyb3d8bbwe",
    "Microsoft.WebView2Runtime.Canary_8wekyb3d8bbwe",
    "Microsoft.WebView2Runtime.Internal_8wekyb3d8bbwe"
]
const kInstallKeyPath=
    "Software\\Microsoft\\EdgeUpdate\\ClientState\\"

const kRedistOverrideKey =
    "Software\\Policies\\Microsoft\\Edge\\WebView2\\"

const kEmbeddedOverrideKey =
    "Software\\Policies\\Microsoft\\EmbeddedBrowserWebView\\LoaderOverride\\"

const kMinimumCompatibleVersion = [86'i32, 0, 616, 0]

when defined(amd64):
  const kEmbeddedWebViewPath = "EBWebView\\x64\\EmbeddedBrowserWebView.dll"
elif defined(i386):
  const kEmbeddedWebViewPath = "EBWebView\\x86\\EmbeddedBrowserWebView.dll"
elif defined(arm64):
  const kEmbeddedWebViewPath = "EBWebView\\arm64\\EmbeddedBrowserWebView.dll"

proc FindClientDllInFolder(folder: var string): bool =
  folder.add  "\\" 
  folder.add kEmbeddedWebViewPath
  return GetFileAttributes(folder) != INVALID_FILE_ATTRIBUTES

proc GetInstallKeyPathForChannel(channel:DWORD): string =
  let guid = kChannelUuid[channel]
  result = kInstallKeyPath & guid

proc CheckVersionAndFindClientDllInFolder(version: array[4,int]; path: var string): bool =
  for component in 0..<4:
    if version[component] < kMinimumCompatibleVersion[component]:
      return false
    if version[component] > kMinimumCompatibleVersion[component]:
      break
  return FindClientDllInFolder(path)

proc FindInstalledClientDllForChannel(lpSubKey:string; system:bool;  clientPath: var string; version:var array[4,int] ):bool =
  var phkResult: HKEY 
  var cbPath:int32 = MAX_PATH
  
  let size = 256
  when useWinUnicode:
    var buffer: WideCString
    unsafeNew(buffer, size + sizeof(Utf16Char))
    buffer[size div sizeof(Utf16Char) - 1] = Utf16Char(0)
  else:
    var buffer: CString
    unsafeNew(buffer, size + 1)
    buffer[size - 1] = 0

  if RegOpenKeyExW(if system:  HKEY_LOCAL_MACHINE else: HKEY_CURRENT_USER, lpSubKey,
                    0, KEY_READ or KEY_WOW64_32KEY, &phkResult) != ERROR_SUCCESS:
    return false

  let r = RegQueryValueEx(phkResult, L"EBWebView", nil, nil,  cast[LPBYTE](buffer[0].addr), &cbPath)

  RegCloseKey(phkResult)
  if r != ERROR_SUCCESS:
    return false
  clientPath = $buffer
  let versionPart = lastPathPart clientPath
 
  if not scanf(versionPart, "$i.$i.$i.$i", version[0], version[1], version[2],version[3]):
    return false
  return CheckVersionAndFindClientDllInFolder(version, clientPath)

type CreateWebViewEnvironmentWithOptionsInternal = proc (unknown: bool; runtimeType: WebView2RunTimeType; userDataDir:PCWSTR; environmentOptions: ptr IUnknown; envCompletedHandler: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): HRESULT{.stdcall.}
type DllCanUnloadNow = proc ():HRESULT {.stdcall.}

proc CreateWebViewEnvironmentWithClientDll( lpLibFileName:PCWSTR;unknown: bool; runtimeType: WebView2RunTimeType; userDataDir:PCWSTR; environmentOptions: ptr IUnknown; envCompletedHandler: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ):HRESULT =
  let clientDll = LoadLibraryW(lpLibFileName)
  if clientDll == 0:
     return HRESULT_FROM_WIN32(GetLastError())
  let createProc = GetProcAddress(clientDll, "CreateWebViewEnvironmentWithOptionsInternal")
  let canUnloadProc = GetProcAddress(clientDll, "DllCanUnloadNow")
  if createProc == nil:
    return HRESULT_FROM_WIN32(GetLastError());
  
  let hr = cast[CreateWebViewEnvironmentWithOptionsInternal](createProc)(unknown, runtimeType, userDataDir, environmentOptions, envCompletedHandler)
  if canUnloadProc != nil and SUCCEEDED(cast[DllCanUnloadNow](canUnloadProc)()):
    FreeLibrary(clientDll)
  return hr

proc FindInstalledClientDll(clientPath: var string; preference: WebView2ReleaseChannelPreference;  channelStr: var string ):int =
  # let getCurrentPackageInfoProc = cast[GetCurrentPackageInfoProc](GetProcAddress(
  #         GetModuleHandleW(L"kernelbase.dll"), "GetCurrentPackageInfo"))
  var channel:int  = 0
  var lpSubKey: string
  var version: array[4, int]
  for i in 0 ..< kNumChannels:
    channel = if preference == WebView2ReleaseChannelPreference.kCanary: 4 - i else: i
    lpSubKey = GetInstallKeyPathForChannel(channel.DWORD) 
    if FindInstalledClientDllForChannel(lpSubKey, false , clientPath, version):
      break
    if FindInstalledClientDllForChannel(lpSubKey, true , clientPath, version):
      break
    # if getCurrentPackageInfoProc == nil:
    #   continue
    # var cPackages:UINT32
    # var len:UINT32
    # # APPMODEL_ERROR_NO_PACKAGE
    # let r = getCurrentPackageInfoProc(1, len.addr, nil, &cPackages)
    # echo "len",len
    # echo "cPackages",repr cPackages
    # echo "r",r
    # if r != ERROR_INSUFFICIENT_BUFFER:
    #   continue
    
    # if cPackages == 0:
    #   continue
    # var packages = cast[ptr UncheckedArray[PACKAGE_INFO]](pkgBuf.addr)
    # echo "packages", repr packages
    # var package: PACKAGE_INFO
    # for j in 0 ..< cPackages:
    #   if packages[j].packageFamilyName == kchannelPackageFamilyName[channel] == 0:
    #     package = packages[j]
    #     break
    # if package == nil:
    #   continue
    # version[0] = 104#package.packageId.version.Major.int
    # version[1] = 0#package.packageId.version.Minor.int
    # version[2] = 1293#package.packageId.version.Build.int
    # version[3] = 63#package.packageId.version.Revision.int
    # clientPath = $package.path
    
    discard CheckVersionAndFindClientDllInFolder(version, clientPath)
  channelStr = kChannelName[channel]
  return 0

when isMainModule:
  var clientPath: string
  var channelStr: string 
  echo FindInstalledClientDll(clientPath, WebView2ReleaseChannelPreference.kStable, channelStr)
  echo "clientPath:", repr clientPath
  echo "channelStr:", repr channelStr