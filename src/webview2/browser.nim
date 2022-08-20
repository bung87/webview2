
import winim
import com
import syscall
import types
import std/[os,atomics]
import memlib

const loaderPath = currentSourcePath().parentDir() / "webviewloader" / "x64" / "WebView2Loader.dll"
const dll = staticReadDll(loaderPath)
proc CreateCoreWebView2EnvironmentWithOptions*(browserExecutableFolder: PCWSTR; userDataFolder: PCWSTR; environmentOptions: pointer; environmentCreatedHandler: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT {.cdecl, memlib: dll, importc: "CreateCoreWebView2EnvironmentWithOptions".}


proc controllerCompletedHandler*(wv: WebView): ICoreWebView2CreateCoreWebView2ControllerCompletedHandler  =
  var vtbl = ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL(
    Invoke: proc(i: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;p: pointer;createdController:ICoreWebView2Controller) =
      syscall(cast[clong](createdController.lpVtbl.AddRef), 1, cast[clong](createdController.addr),0,0 )
      wv.browser.controller = createdController
      var createdWebView2: ICoreWebView2
      syscall(createdController.lpVtbl.GetCoreWebView2, 2,cast[clong](createdController.addr), cast[clong](createdWebView2.addr))
      wv.browser.view = createdWebView2
      syscall(cast[clong](wv.browser.view.lpVtbl.AddRef), 1, cast[clong](wv.browser.view.addr), 0, 0)
      wv.browser.controllerCompleted.store(1)
      # return 0
  )
  var h = ICoreWebView2CreateCoreWebView2ControllerCompletedHandler(
    lpVtbl: vtbl
  )
  # h.VTBL.BasicVTBL = newBasicVTBL(h.Basic)
  return h

proc environmentCompletedHandler*(wv: Webview):ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler =
  var invoke = proc(i: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;p: clong;createdEnvironment: ICoreWebView2Environment):HRESULT =
    syscall(createdEnvironment.lpVtbl.CreateCoreWebView2Controller, 3, cast[clong](createdEnvironment.addr), cast[clong](wv.window.handle.addr),  cast[clong](wv.controllerCompletedHandler()) )
  var vtbl = ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL(
      Invoke: invoke
    )
  result = ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler(
    lpVtbl:vtbl
  )
  # h.VTBL.BasicVTBL = newBasicVTBL(h.Basic)
  # return h.addr

proc embed*(b: Browser; wv: WebView) =
  b.hwnd = wv.window[].handle
  let exePath = getAppFilename()
  let dataPath = getEnv("AppData") /  extractFilename(exePath)
  let r1 = CreateCoreWebView2EnvironmentWithOptions(newWideCString(""), newWideCString(dataPath), nil, wv.environmentCompletedHandler())
  # let hr1 = HRESULT(r1)
  # if hr1 != S_OK:
  var msg: MSG
  while GetMessage(msg.addr, 0, 0, 0)<0:
    break
  TranslateMessage(msg.addr)
  DispatchMessage(msg.addr)
  var settings:ICoreWebView2Settings
  let r = syscall(b.view.lpVtbl.GetSettings, 2, cast[clong](b.view.addr),  cast[clong](settings.addr))
  let hr = r.HRESULT
  # if hr != S_OK:
  
  b.settings = settings

proc navigate*(b: Browser; url: string) =
  syscall(b.view.lpVtbl.Navigate, 3, cast[clong](b.view.addr), cast[clong](newWideCString(url)[0].addr), 0)


proc AddScriptToExecuteOnDocumentCreated*(b: Browser; script: string) =
  syscall(b.view.lpVtbl.AddScriptToExecuteOnDocumentCreated, 3, cast[clong](b.view.addr), cast[clong](newWideCString(script)[0].addr), 0)

proc ExecuteScript*(b: Browser; script: string) =
  syscall(b.view.lpVtbl.ExecuteScript, 3, cast[clong](b.view.addr), cast[clong](newWideCString(script)[0].addr), 0)

proc saveSetting*(b: Browser;setter:pointer; enabled: bool) =
  var flag:clong = 0

  if enabled:
    flag = 1
  syscall(cast[clong](setter), 3, cast[clong](b.settings.addr), flag, 0)

proc saveSettings*(b: Browser;) =
  b.saveSetting(b.settings.lpVtbl.PutIsBuiltInErrorPageEnabled, b.config.builtInErrorPage)
  b.saveSetting(b.settings.lpVtbl.PutAreDefaultContextMenusEnabled, b.config.defaultContextMenus)
  b.saveSetting(b.settings.lpVtbl.PutAreDefaultScriptDialogsEnabled, b.config.defaultScriptDialogs)
  b.saveSetting(b.settings.lpVtbl.PutAreDevToolsEnabled, b.config.devtools)
  b.saveSetting(b.settings.lpVtbl.PutAreHostObjectsAllowed, b.config.hostObjects)
  b.saveSetting(b.settings.lpVtbl.PutIsScriptEnabled, b.config.script)
  b.saveSetting(b.settings.lpVtbl.PutIsStatusBarEnabled, b.config.statusBar)
  b.saveSetting(b.settings.lpVtbl.PutIsWebMessageEnabled, b.config.webMessage)
  b.saveSetting(b.settings.lpVtbl.PutIsZoomControlEnabled, b.config.zoomControl)

