
import winim
import com
import types
import std/[os, atomics, dynlib]
import memlib

const loaderPath = currentSourcePath().parentDir() / "webviewloader" / "x64" /
    "WebView2Loader.dll"
const dll = staticReadDll(loaderPath)
withPragma {cdecl, memlib: dll, importc: "CreateCoreWebView2Environment"}:
  proc CreateCoreWebView2Environment(environmentCreatedHandler:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT
withPragma {cdecl, memlib: dll, importc: "CreateCoreWebView2EnvironmentWithOptions"}:
  proc CreateCoreWebView2EnvironmentWithOptions(browserExecutableFolder: PCWSTR; userDataFolder: PCWSTR; environmentOptions: ptr ICoreWebView2EnvironmentOptions; environmentCreatedHandler:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT
withPragma {cdecl, memlib: dll, importc: "GetAvailableCoreWebView2BrowserVersionString"}:
  proc GetAvailableCoreWebView2BrowserVersionString(
    browserExecutableFolder: PCWSTR; versionInfo: ptr LPWSTR; )

# type CreateCoreWebView2EnvironmentWithOptions = proc(
#     browserExecutableFolder: PCWSTR; userDataFolder: PCWSTR;
#     environmentOptions: ptr ICoreWebView2EnvironmentOptions;
#     environmentCreatedHandler: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): HRESULT {.stdcall.}

type ControllerCompletedHandlerVTBL = object of ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL
  controller: ptr ICoreWebView2Controller
  view: ptr ICoreWebView2

type EnvironmentCompletedHandlerVTBL = object of ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
  controllerCompletedHandler: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler
  handle: HWND

proc controllerCompletedHandler(wv: WebView): ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler =
  result = cast[ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler](
      alloc0(sizeof(ICoreWebView2CreateCoreWebView2ControllerCompletedHandler)))
  var vtbl = ControllerCompletedHandlerVTBL(
    Invoke: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
        errorCode: HRESULT;
        createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.} =
    discard createdController.lpVtbl.GetCoreWebView2(createdController, cast[
        ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view.addr)
    discard createdController.lpVtbl.AddRef(cast[ptr IUnknown](createdController))
    cast[ptr ControllerCompletedHandlerVTBL](
        self.lpVtbl).controller = createdController

    discard cast[ptr ControllerCompletedHandlerVTBL](
        self.lpVtbl).view.lpVtbl.AddRef(cast[ptr IUnknown](cast[
        ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view))
    # wv.browser.controllerCompleted.store(1)
    return 0
  )
  result.lpVtbl = cast[ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL](vtbl.addr)
  result.lpVtbl.AddRef = proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): ULONG {.stdcall.} = 1
  result.lpVtbl.Release = proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): ULONG {.stdcall.} = 1
  result.lpVtbl.QueryInterface = proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
      riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
    ppvObject[] = self
    discard self.lpVtbl.AddRef(self)
    return S_OK
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
      Invoke: proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
          errorCode: HRESULT;
          createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.} =
    discard createdEnvironment.lpVtbl.CreateCoreWebView2Controller(
        createdEnvironment, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).handle, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).controllerCompletedHandler)
    return 0
    )
  result.lpVtbl = vtbl.addr
  result.lpVtbl.AddRef = proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): ULONG {.stdcall.} = 1
  result.lpVtbl.Release = proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): ULONG {.stdcall.} = 1
  result.lpVtbl.QueryInterface = proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
      riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
    ppvObject[] = self
    discard self.lpVtbl.AddRef(self)
    return S_OK

proc resize*(b: Browser) =
  var bounds: RECT
  GetClientRect(b.hwnd, bounds)
  discard b.controller.lpVtbl.PutBounds(b.controller, bounds)

proc embed*(b: Browser; wv: WebView) =
  b.hwnd = wv.window[].handle
  let exePath = getAppFilename()
  var dataPath = getEnv("AppData") / extractFilename(exePath)
  var versionInfo: LPWSTR
  GetAvailableCoreWebView2BrowserVersionString(NULL, versionInfo.addr)
  echo versionInfo
  CoTaskMemFree(versionInfo)

  var h = wv.environmentCompletedHandler()
  # let lib = loadLib loaderPath
  # let createCoreWebView2EnvironmentWithOptions = cast[
  #     CreateCoreWebView2EnvironmentWithOptions](lib.symAddr("CreateCoreWebView2EnvironmentWithOptions"))
  let r1 = CreateCoreWebView2EnvironmentWithOptions(NULL, dataPath, NULL, h)
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

