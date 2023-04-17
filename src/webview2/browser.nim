
import winim
import com
import types
from environment_completed_handler import nil
from controller_completed_handler import nil
from environment_options import nil
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



proc controllerCompletedHandler(wv: WebView): ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler =
  result = cast[ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler](
      alloc0(sizeof(ICoreWebView2CreateCoreWebView2ControllerCompletedHandler)))
  var vtbl = ControllerCompletedHandlerVTBL()
  vtbl.Invoke = controller_completed_handler.Invoke
  vtbl.AddRef = controller_completed_handler.AddRef
  vtbl.Release = controller_completed_handler.Release
  vtbl.QueryInterface = controller_completed_handler.QueryInterface

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
    )
  vtbl.Invoke = environment_completed_handler.Invoke
  vtbl.AddRef = environment_completed_handler.AddRef
  vtbl.Release = environment_completed_handler.Release
  vtbl.QueryInterface = environment_completed_handler.QueryInterface

  result.lpVtbl = vtbl.addr

proc resize*(b: Browser) =
  var bounds: RECT
  GetClientRect(b.hwnd, bounds)
  # discard b.controller.lpVtbl.PutBounds(b.controller, bounds)

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

  let environmentCompletedHandler = wv.environmentCompletedHandler()

  # let lib = loadLib loaderPath
  # let createCoreWebView2EnvironmentWithOptions = cast[
  #     CreateCoreWebView2EnvironmentWithOptions](lib.symAddr("CreateCoreWebView2EnvironmentWithOptions"))
  # var options = ICoreWebView2EnvironmentOptions()

  var options = cast[ptr ICoreWebView2EnvironmentOptions](
      alloc0(sizeof(
      ICoreWebView2EnvironmentOptions)))
  var vtbl = ICoreWebView2EnvironmentOptionsVTBL(
    TargetCompatibleBrowserVersion: "104.0.1293.70",
    AdditionalBrowserArguments: "",
    Language: "",
    AllowSingleSignOnUsingOSPrimaryAccount: false
    )
  vtbl.get_AdditionalBrowserArguments = environment_options.get_AdditionalBrowserArguments
  vtbl.get_AllowSingleSignOnUsingOSPrimaryAccount = environment_options.get_AllowSingleSignOnUsingOSPrimaryAccount
  vtbl.get_Language = environment_options.get_Language
  vtbl.get_TargetCompatibleBrowserVersion = environment_options.get_TargetCompatibleBrowserVersion
  vtbl.put_AdditionalBrowserArguments = environment_options.put_AdditionalBrowserArguments
  vtbl.put_AllowSingleSignOnUsingOSPrimaryAccount = environment_options.put_AllowSingleSignOnUsingOSPrimaryAccount
  vtbl.put_Language = environment_options.put_Language
  vtbl.put_TargetCompatibleBrowserVersion = environment_options.put_TargetCompatibleBrowserVersion
  vtbl.get_ExclusiveUserDataFolderAccess = environment_options.get_ExclusiveUserDataFolderAccess
  vtbl.put_ExclusiveUserDataFolderAccess = environment_options.put_ExclusiveUserDataFolderAccess
  options.lpVtbl = vtbl.addr

  let r1 = CreateCoreWebView2EnvironmentWithOptions("", dataPath, options, environmentCompletedHandler)
  # let folder = "C:\\Program Files (x86)\\Microsoft\\EdgeWebView\\Application\\104.0.1293.70"
  # let r1 = CreateCoreWebView2EnvironmentWithOptions(folder, dataPath, options, h)
  # let r1 = CreateCoreWebView2Environment(h)
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

