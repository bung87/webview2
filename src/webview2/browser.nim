
import winim
import com
import types
import std/[os, atomics]
import loader
# import memlib

# const loaderPath = currentSourcePath().parentDir() / "webviewloader" / "x64" /
#     "WebView2Loader.dll"
# const dll = staticReadDll(loaderPath)
# withPragma {cdecl, memlib: dll, importc: "CreateCoreWebView2Environment"}:
#   proc CreateCoreWebView2Environment(environmentCreatedHandler:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT
# withPragma {cdecl, memlib: dll, importc: "CreateCoreWebView2EnvironmentWithOptions"}:
#   proc CreateCoreWebView2EnvironmentWithOptions(browserExecutableFolder: PCWSTR; userDataFolder: PCWSTR; environmentOptions: ptr ICoreWebView2EnvironmentOptions; environmentCreatedHandler:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT
# withPragma {cdecl, memlib: dll, importc: "GetAvailableCoreWebView2BrowserVersionString"}:
#   proc GetAvailableCoreWebView2BrowserVersionString(
#     browserExecutableFolder: PCWSTR; versionInfo: ptr LPWSTR; )

# type CreateCoreWebView2EnvironmentWithOptions = proc(
#     browserExecutableFolder: PCWSTR; userDataFolder: PCWSTR;
#     environmentOptions: ptr ICoreWebView2EnvironmentOptions;
#     environmentCreatedHandler: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): HRESULT {.stdcall.}

type ControllerCompletedHandlerVTBL {.pure, inheritable.} = object of ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL
  controller: ptr ICoreWebView2Controller
  view: ptr ICoreWebView2

type EnvironmentCompletedHandlerVTBL {.pure, inheritable.} = object of ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
  controllerCompletedHandler: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler
  handle: HWND

proc controllerCompletedHandler(wv: WebView): ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler =
  result = cast[ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler](
      alloc0(sizeof(ICoreWebView2CreateCoreWebView2ControllerCompletedHandler)))
  var vtbl = ControllerCompletedHandlerVTBL(
    Invoke: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
        errorCode: HRESULT;
        createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.} =
    echo "controllerCompletedHandler invoke"
    discard createdController.lpVtbl.AddRef(cast[ptr IUnknown](createdController))
    discard createdController.lpVtbl.GetCoreWebView2(createdController, cast[
        ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view.addr)
    
    cast[ptr ControllerCompletedHandlerVTBL](
        self.lpVtbl).controller = createdController

    discard cast[ptr ControllerCompletedHandlerVTBL](
        self.lpVtbl).view.lpVtbl.AddRef(cast[ptr IUnknown](cast[
        ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view))
    # wv.browser.controllerCompleted.store(1)
    return 0
  )
  
  vtbl.AddRef = proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): ULONG {.stdcall.} = 1
  vtbl.Release = proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): ULONG {.stdcall.} = 1
  vtbl.QueryInterface = proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
      riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
    echo "controllerCompletedHandler QueryInterface"
    ppvObject[] = self
    discard self.lpVtbl.AddRef(self)
    return S_OK
  result.lpVtbl = cast[ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL](vtbl.addr)
  # wv.browser.controller = cast[ptr ControllerCompletedHandlerVTBL](
  #     result.lpVtbl).controller
  # wv.browser.view = cast[ptr ControllerCompletedHandlerVTBL](result.lpVtbl).view

proc environmentCompletedHandler*(wv: Webview): ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler =
  result = cast[ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler](
      alloc0(sizeof(
      ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler)))

  var vtbl = EnvironmentCompletedHandlerVTBL(
      handle: wv.window[].handle,
      controllerCompletedHandler: wv.controllerCompletedHandler(),
      # Invoke: 
    )
  
  vtbl.Invoke = proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
          errorCode: HRESULT;
          createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.} =
    echo "EnvironmentCompletedHandlerVTBL Invoke"
    discard createdEnvironment.lpVtbl.CreateCoreWebView2Controller(
        createdEnvironment, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).handle, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).controllerCompletedHandler)
    return 0
  vtbl.AddRef = proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): ULONG {.stdcall.} = 1
  vtbl.Release = proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): ULONG {.stdcall.} = 1
  vtbl.QueryInterface = proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
      riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
    var guid = DEFINE_GUID"4E8A3389-C9D8-4BD2-B6B5-124FEE6CC14D"
    echo "EnvironmentCompletedHandlerVTBL QueryInterface"
    if IsEqualIID(riid, guid.addr):
      ppvObject[] = self
      discard self.lpVtbl.AddRef(self)
      return S_OK
    else:
      ppvObject[] = nil
      return E_NOINTERFACE

  result.lpVtbl = vtbl.addr

proc resize*(b: Browser) =
  var bounds: RECT
  GetClientRect(b.hwnd, bounds)
  discard b.controller.lpVtbl.PutBounds(b.controller, bounds)

proc embed*(b: Browser; wv: WebView) =
  b.hwnd = wv.window[].handle
  let exePath = getAppFilename()
  var (dir, name, ext) = splitFile(exePath)
  var dataPath = getEnv("AppData") / name
  # createDir(dataPath)
  # var versionInfo: LPWSTR
  # GetAvailableCoreWebView2BrowserVersionString(NULL, versionInfo.addr)
  # echo versionInfo
  # CoTaskMemFree(versionInfo)

  let h = wv.environmentCompletedHandler()

  # let lib = loadLib loaderPath
  # let createCoreWebView2EnvironmentWithOptions = cast[
  #     CreateCoreWebView2EnvironmentWithOptions](lib.symAddr("CreateCoreWebView2EnvironmentWithOptions"))
  # var options = ICoreWebView2EnvironmentOptions()

  var options = cast[ptr ICoreWebView2EnvironmentOptions](
      alloc0(sizeof(
      ICoreWebView2EnvironmentOptions)))
  var vtbl = ICoreWebView2EnvironmentOptionsVTBL(
    TargetCompatibleBrowserVersion:"104.0.1293.70",
    AdditionalBrowserArguments:"",
    Language:"",
    AllowSingleSignOnUsingOSPrimaryAccount:false
    )
  vtbl.get_AdditionalBrowserArguments = proc (self: ptr ICoreWebView2EnvironmentOptions;value: ptr LPWSTR): HRESULT {.stdcall.} =
    value[] = self.lpVtbl.AdditionalBrowserArguments
    return S_OK
  vtbl.get_AllowSingleSignOnUsingOSPrimaryAccount = proc(self: ptr ICoreWebView2EnvironmentOptions;allow: ptr BOOL): HRESULT {.stdcall.} =
    allow[] = self.lpVtbl.AllowSingleSignOnUsingOSPrimaryAccount
    return S_OK
  vtbl.get_Language= proc(self: ptr ICoreWebView2EnvironmentOptions;value: ptr LPWSTR): HRESULT {.stdcall.} =
    value[] = self.lpVtbl.Language
    return S_OK
  vtbl.get_TargetCompatibleBrowserVersion = proc (self: ptr ICoreWebView2EnvironmentOptions; value: ptr LPWSTR ): HRESULT {.stdcall.} =
    value[] = self.lpVtbl.TargetCompatibleBrowserVersion
    return S_OK
  vtbl.put_AdditionalBrowserArguments = proc (self: ptr ICoreWebView2EnvironmentOptions;value:LPCWSTR ): HRESULT {.stdcall.} =
    self.lpVtbl.AdditionalBrowserArguments = value
    return S_OK
  vtbl.put_AllowSingleSignOnUsingOSPrimaryAccount = proc (self: ptr ICoreWebView2EnvironmentOptions;allow: BOOL ): HRESULT {.stdcall.} =
    self.lpVtbl.AllowSingleSignOnUsingOSPrimaryAccount = allow
    return S_OK
  vtbl.put_Language = proc (self: ptr ICoreWebView2EnvironmentOptions;value:LPCWSTR ): HRESULT {.stdcall.} =
    self.lpVtbl.Language = value
  vtbl.put_TargetCompatibleBrowserVersion = proc (self: ptr ICoreWebView2EnvironmentOptions; value:LPCWSTR ): HRESULT {.stdcall.} =
    self.lpVtbl.TargetCompatibleBrowserVersion = value
    return S_OK
  vtbl.get_ExclusiveUserDataFolderAccess = proc (self: ptr ICoreWebView2EnvironmentOptions;value:ptr BOOL):HRESULT {.stdcall.} =
    value[] = self.lpVtbl.ExclusiveUserDataFolderAccess
    return S_OK
  vtbl.put_ExclusiveUserDataFolderAccess = proc (self: ptr ICoreWebView2EnvironmentOptions;value: BOOL):HRESULT {.stdcall.} =
    self.lpVtbl.ExclusiveUserDataFolderAccess = value
    return S_OK
  options.lpVtbl = vtbl.addr

  let r1 = CreateCoreWebView2EnvironmentWithOptions("", dataPath, options, h)
  let folder = "C:\\Program Files (x86)\\Microsoft\\EdgeWebView\\Application\\104.0.1293.70"
  # let r1 = CreateCoreWebView2EnvironmentWithOptions(folder, dataPath, options, h)
  # let r1 = CreateCoreWebView2Environment(h)
  echo r1
  doAssert r1 == S_OK, "failed to call CreateCoreWebView2EnvironmentWithOptions"
  var msg: MSG
  while GetMessage(msg.addr, 0, 0, 0) < 0:
    break
  TranslateMessage(msg.addr)
  DispatchMessage(msg.addr)
  var settings: ICoreWebView2Settings
  let r = b.view.lpVtbl.GetSettings(b.view[], settings.addr)
  doAssert r == S_OK, "failed to get webview settings"

  b.settings = settings

proc navigate*(b: Browser; url: string) =
  discard b.view.lpVtbl.Navigate(b.view[], newWideCString(url))


proc AddScriptToExecuteOnDocumentCreated*(b: Browser; script: string) =
  discard b.view.lpVtbl.AddScriptToExecuteOnDocumentCreated(b.view[],
      newWideCString(script), NUll)

proc ExecuteScript*(b: Browser; script: string) =
  discard b.view.lpVtbl.ExecuteScript(b.view[], newWideCString(script), NUll)

# proc saveSetting*(b: Browser;setter:pointer; enabled: bool) =
#   var flag:clong = 0

#   if enabled:
#     flag = 1
#   syscall(cast[clong](setter), 3, cast[clong](b.settings.addr), flag, 0)

# proc saveSettings*(b: Browser;) =
#   b.saveSetting(b.settings.lpVtbl.PutIsBuiltInErrorPageEnabled, b.config.builtInErrorPage)
#   b.saveSetting(b.settings.lpVtbl.PutAreDefaultContextMenusEnabled, b.config.defaultContextMenus)
#   b.saveSetting(b.settings.lpVtbl.PutAreDefaultScriptDialogsEnabled, b.config.defaultScriptDialogs)
#   b.saveSetting(b.settings.lpVtbl.PutAreDevToolsEnabled, b.config.devtools)
#   b.saveSetting(b.settings.lpVtbl.PutAreHostObjectsAllowed, b.config.hostObjects)
#   b.saveSetting(b.settings.lpVtbl.PutIsScriptEnabled, b.config.script)
#   b.saveSetting(b.settings.lpVtbl.PutIsStatusBarEnabled, b.config.statusBar)
#   b.saveSetting(b.settings.lpVtbl.PutIsWebMessageEnabled, b.config.webMessage)
#   b.saveSetting(b.settings.lpVtbl.PutIsZoomControlEnabled, b.config.zoomControl)

