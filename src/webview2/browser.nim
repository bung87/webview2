
import winim
import com
import types
from environment_completed_handler import nil
from controller_completed_handler import nil
from environment_options import nil
import std/[os, atomics,pathnorm]
import loader
from globals import nil

using
  self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler

proc newControllerCompletedHandler(): ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler =
  result = create(type result[])
  var vtbl = create(ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL)
  vtbl.QueryInterface = controller_completed_handler.QueryInterface
  vtbl.AddRef = controller_completed_handler.AddRef
  vtbl.Release = controller_completed_handler.Release
  vtbl.Invoke = controller_completed_handler.Invoke
  result.lpVtbl = vtbl


proc newEnvironmentCompletedHandler*(): ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler =
  result = create(type result[])
  result.lpVtbl = create(ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL)
  result.lpVtbl.QueryInterface = environment_completed_handler.QueryInterface
  result.lpVtbl.AddRef = environment_completed_handler.AddRef
  result.lpVtbl.Release = environment_completed_handler.Release
  result.lpVtbl.Invoke = environment_completed_handler.Invoke


proc resize*(b: Browser, hwnd: HWND) =
  var bounds: RECT
  let g = GetClientRect(hwnd, bounds)
  doAssert g == TRUE, $GetLastError()
  doAssert b.controller != nil
  discard b.controller.lpVtbl.PutBounds(b.controller, bounds)

proc embed*(b: Browser; wv: WebView) =
  b.hwnd = wv.window[].handle
  let exePath = getAppFilename()
  var (dir, name, ext) = splitFile(exePath)
  var dataPath = normalizePath(getEnv("AppData") / name)
  # var dataPath = getTempDir()  / name
  echo dataPath
  createDir(dataPath)
  # var versionInfo: LPWSTR
  # GetAvailableCoreWebView2BrowserVersionString(NULL, versionInfo.addr)
  # echo versionInfo
  # CoTaskMemFree(versionInfo)
  globals.winHandle = wv.window[].handle
  var environmentCompletedHandler {.global.} = newEnvironmentCompletedHandler()
  globals.controllerCompletedHandler[] = newControllerCompletedHandler()[]

  var options = create(ICoreWebView2EnvironmentOptions)
  var vtbl = create(ICoreWebView2EnvironmentOptionsVTBL)
  vtbl.QueryInterface = environment_options.QueryInterface
  vtbl.AddRef = environment_options.AddRef
  vtbl.Release = environment_options.Release
  vtbl.get_AdditionalBrowserArguments = environment_options.get_AdditionalBrowserArguments
  vtbl.put_AdditionalBrowserArguments = environment_options.put_AdditionalBrowserArguments
  vtbl.get_Language = environment_options.get_Language
  vtbl.put_Language = environment_options.put_Language
  vtbl.get_TargetCompatibleBrowserVersion = environment_options.get_TargetCompatibleBrowserVersion
  vtbl.put_TargetCompatibleBrowserVersion = environment_options.put_TargetCompatibleBrowserVersion
  vtbl.get_AllowSingleSignOnUsingOSPrimaryAccount = environment_options.get_AllowSingleSignOnUsingOSPrimaryAccount
  vtbl.put_AllowSingleSignOnUsingOSPrimaryAccount = environment_options.put_AllowSingleSignOnUsingOSPrimaryAccount
  vtbl.get_ExclusiveUserDataFolderAccess = environment_options.get_ExclusiveUserDataFolderAccess
  vtbl.put_ExclusiveUserDataFolderAccess = environment_options.put_ExclusiveUserDataFolderAccess
  
  options.lpVtbl = vtbl
  let r1 = CreateCoreWebView2EnvironmentWithOptions("", dataPath, options, environmentCompletedHandler)
  # let folder = "C:\\Program Files (x86)\\Microsoft\\EdgeWebView\\Application\\104.0.1293.70"

  doAssert r1 == S_OK, "failed to call CreateCoreWebView2EnvironmentWithOptions"
  var msg: MSG
  while GetMessage(msg.addr, 0, 0, 0) < 0:
    break
  TranslateMessage(msg.addr)
  DispatchMessage(msg.addr)

proc navigate*(b: Browser; url: string) =
  discard globals.view.lpVtbl.Navigate(globals.view[], L(url))


proc AddScriptToExecuteOnDocumentCreated*(b: Browser; script: string) =
  discard globals.view.lpVtbl.AddScriptToExecuteOnDocumentCreated(globals.view[],
      newWideCString(script), NUll)

proc ExecuteScript*(b: Browser; script: string) =
  discard globals.view.lpVtbl.ExecuteScript(globals.view[], newWideCString(script), NUll)

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

