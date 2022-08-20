
import winim
import com
import syscall
import types
import std/[os]

proc controllerCompletedHandler*(wv: WebView): ICoreWebView2CreateCoreWebView2ControllerCompletedHandler  =
  var vtbl = ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL(
    Invoke: proc(i: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;p: pointer;createdController:ICoreWebView2Controller )=
      syscall(createdController.lpVtbl.AddRef, 1, createdController.addr,0,0 )
      wv.browser.controller = createdController
      var createdWebView2: ICoreWebView2
      syscall(createdController.lpVtbl.GetCoreWebView2, 2,createdController.addr, createdWebView2.addr)
      wv.browser.view = createdWebView2
      syscall(wv.browser.view.lpVtbl.AddRef, 1, wv.browser.view.addr, 0, 0)
      wv.browser.controllerCompleted.store(1)
      return 0
  )
  var h = ICoreWebView2CreateCoreWebView2ControllerCompletedHandler(
    lpVtbl: vtbl
  )
  # h.VTBL.BasicVTBL = newBasicVTBL(h.Basic)
  return h

proc environmentCompletedHandler*(wv: Webview):pointer =
  var h = ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler(
    lpVtbl:ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL(
      Invoke: proc(i: clong;p: clong;createdEnvironment: ICoreWebView2Environment) =
        syscall(createdEnvironment.lpVtbl.CreateCoreWebView2Controller, 3, createdEnvironment.addr,wv.window.handle.addr,wv.controllerCompletedHandler())
    )
  )
  # h.VTBL.BasicVTBL = newBasicVTBL(h.Basic)
  return h.addr

proc embed*(b: Browser; wv: WebView) =
  b.hwnd = wv.window[].handle
  let exePath = getAppFilename()
  let dataPath = getEnv("AppData") /  extractFilename(exePath)
  var settings: ICoreWebView2Settings
  let r1 = wv.dll(0, newWideCString(dataPath), 0, uint64(wv.environmentCompletedHandler()))
  let hr1 = HRESULT(r1)
  # if hr1 != S_OK:
  var msg: MSG
  while GetMessage(msg.addr, 0, 0, 0)<0:
    break
  TranslateMessage(msg.addr)
  DispatchMessage(msg.addr)
  var settings:ICoreWebView2Settings
  let r = syscall(b.view.VTBL.GetSettings, 2, b.view.addr, settings.addr)
  let hr = r.HRESDULT
  # if hr != S_OK:
  
  b.settings = settings

proc navigate*(b: Browser; url: string) =
  syscall(b.view.VTBL.Navigate,3,b.view.addr, newWideCString(url).unsafeAddr, 0)


proc AddScriptToExecuteOnDocumentCreated*(b: Browser; script: string) =
  syscall(b.view.VTBL.AddScriptToExecuteOnDocumentCreated, 3, b.view.addr, newWideCString(script).unsafeAddr, 0)

proc ExecuteScript*(b: Browser; script: string) =
  syscall(b.view.VTBL.ExecuteScript, 3, b.view.addr, newWideCString(script).unsafeAddr, 0)

proc saveSetting*(b: Browser;setter:pointer; enabled: bool) =
  var flag:clong = 0

	if enabled:
		flag = 1
  syscall(setter, 3, b.settings.addr, flag, 0)

proc saveSettings*(b: Browser;) =
  b.saveSetting(b.settings.VTBL.PutIsBuiltInErrorPageEnabled, b.config.builtInErrorPage)
  b.saveSetting(b.settings.VTBL.PutAreDefaultContextMenusEnabled, b.config.defaultContextMenus)
  b.saveSetting(b.settings.VTBL.PutAreDefaultScriptDialogsEnabled, b.config.defaultScriptDialogs)
  b.saveSetting(b.settings.VTBL.PutAreDevToolsEnabled, b.config.devtools)
  b.saveSetting(b.settings.VTBL.PutAreHostObjectsAllowed, b.config.hostObjects)
  b.saveSetting(b.settings.VTBL.PutIsScriptEnabled, b.config.script)
  b.saveSetting(b.settings.VTBL.PutIsStatusBarEnabled, b.config.statusBar)
  b.saveSetting(b.settings.VTBL.PutIsWebMessageEnabled, b.config.webMessage)
  b.saveSetting(b.settings.VTBL.PutIsZoomControlEnabled, b.config.zoomControl)

