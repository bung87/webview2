
import winim
import com
import types
import std/[os,atomics]
import memlib

const loaderPath = currentSourcePath().parentDir() / "webviewloader" / "x64" / "WebView2Loader.dll"
const dll = staticReadDll(loaderPath)
proc CreateCoreWebView2Environment(environmentCreatedHandler:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT {.cdecl, memlib: dll, importc: "CreateCoreWebView2Environment".}
proc CreateCoreWebView2EnvironmentWithOptions(browserExecutableFolder: PCWSTR; userDataFolder: PCWSTR; environmentOptions: ptr ICoreWebView2EnvironmentOptions; environmentCreatedHandler:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT {.cdecl, memlib: dll, importc: "CreateCoreWebView2EnvironmentWithOptions".}
proc GetAvailableCoreWebView2BrowserVersionString(browserExecutableFolder:PCWSTR ; versionInfo:ptr LPWSTR;)  {.cdecl, memlib: dll, importc: "GetAvailableCoreWebView2BrowserVersionString".}

proc controllerCompletedHandler(wv: WebView): ICoreWebView2CreateCoreWebView2ControllerCompletedHandler =
  var vtbl = ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL(
    Invoke: proc(i: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler; errorCode:HRESULT; createdController:ICoreWebView2Controller): HRESULT =
      discard createdController.lpVtbl.AddRef(cast[ptr IUnknown](createdController.unsafeAddr))
      wv.browser.controller = createdController
      var createdWebView2 = new ICoreWebView2
      discard createdController.lpVtbl.GetCoreWebView2(createdController, createdWebView2.addr)
      wv.browser.view = createdWebView2
      discard wv.browser.view.lpVtbl.AddRef(cast[ptr IUnknown](wv.browser.view))
      wv.browser.controllerCompleted.store(1)
      return 0
  )
  result = ICoreWebView2CreateCoreWebView2ControllerCompletedHandler(
    lpVtbl: vtbl.addr
  )
  # h.VTBL.BasicVTBL = newBasicVTBL(h.Basic)

proc environmentCompletedHandler*(wv: Webview):ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler =
  
  var invoke = proc(i: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler; errorCode: HRESULT; createdEnvironment: ptr ICoreWebView2Environment): HRESULT =
    # syscall(createdEnvironment.lpVtbl.CreateCoreWebView2Controller, 3, cast[clong](createdEnvironment.addr), cast[clong](wv.window.handle.addr),  cast[clong](wv.controllerCompletedHandler()) )
    var handler = wv.controllerCompletedHandler()
    discard createdEnvironment.lpVtbl.CreateCoreWebView2Controller(createdEnvironment[], wv.window[].handle, handler.addr)
    return 0

  var vtbl = ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL(
      Invoke: invoke
    )
  result = ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler(
    lpVtbl: vtbl.addr
  )

proc resize*(b: Browser) =
  var bounds: RECT 
  GetClientRect(b.hwnd, bounds)
  # syscall(b.controller.lpVtbl.PutBounds,2, cast[clong](b.controller.addr), cast[clong](bounds.addr))
  discard b.controller.lpVtbl.PutBounds(b.controller,bounds)

proc embed*(b: Browser; wv: WebView) =
  b.hwnd = wv.window[].handle
  let exePath = getAppFilename()
  var dataPath = getEnv("AppData") /  extractFilename(exePath)
  var versionInfo: LPWSTR 
  GetAvailableCoreWebView2BrowserVersionString(NULL, versionInfo.addr)
  var h = wv.environmentCompletedHandler()
  let r1 = CreateCoreWebView2EnvironmentWithOptions("", dataPath, NULL, h.addr)
  doAssert r1 == S_OK, "failed to call CreateCoreWebView2EnvironmentWithOptions"
  var msg: MSG
  while GetMessage(msg.addr, 0, 0, 0)<0:
    break
  TranslateMessage(msg.addr)
  DispatchMessage(msg.addr)
  var settings: ICoreWebView2Settings
  # let r = syscall(b.view.lpVtbl.GetSettings, 2, cast[clong](b.view.addr),  cast[clong](settings.addr))
  let r = b.view.lpVtbl.GetSettings(b.view[],settings.addr)
  doAssert r == S_OK, "failed to get webview settings"
  
  b.settings = settings

proc navigate*(b: Browser; url: string) =
  # syscall(b.view.lpVtbl.Navigate, 3, cast[clong](b.view.addr), cast[clong](newWideCString(url)[0].addr), 0)
  discard b.view.lpVtbl.Navigate(b.view[], newWideCString(url))


proc AddScriptToExecuteOnDocumentCreated*(b: Browser; script: string) =
  # syscall(b.view.lpVtbl.AddScriptToExecuteOnDocumentCreated, 3, cast[clong](b.view.addr), cast[clong](newWideCString(script)[0].addr), 0)
  discard b.view.lpVtbl.AddScriptToExecuteOnDocumentCreated(b.view[],newWideCString(script), NUll)

proc ExecuteScript*(b: Browser; script: string) =
  # syscall(b.view.lpVtbl.ExecuteScript, 3, cast[clong](b.view.addr), cast[clong](newWideCString(script)), 0)
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

