import webview2/[types,webview,browser,context]
import winim
import winim/inc/winuser
import winim/inc/mshtml
import winim/[utils]
import std/[os]

const classname = "WebView"

proc wndproc(hwnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
    var w = cast[Webview](GetWindowLongPtr(hwnd, GWLP_USERDATA))

    case msg
      of WM_SIZE:
        if w.browser.controller != nil:
          w.browser.resize(hwnd)
      of WM_CLOSE:
        DestroyWindow(hwnd)
      of WM_DESTROY:
        # UnEmbedBrowserObject(w)
        PostQuitMessage(0)
        return TRUE
      else:
        return DefWindowProc(hwnd, msg, wParam, lParam)

proc  webview_init*(w: Webview): cint =
  var wc:WNDCLASSEX
  var hInstance:HINSTANCE
  var style:DWORD
  var clientRect:RECT
  var rect:RECT

  hInstance = GetModuleHandle(NULL)
  if hInstance == 0:
    return -1
  if OleInitialize(NULL) != S_OK:
    return -1
  ZeroMemory(&wc, sizeof(WNDCLASSEX))
  wc.cbSize = sizeof(WNDCLASSEX).UINT
  wc.hInstance = hInstance
  wc.lpfnWndProc = wndproc
  wc.lpszClassName = classname
  RegisterClassExW(&wc)

  style = WS_OVERLAPPEDWINDOW
  # if not w.resizable:
  #   style = WS_OVERLAPPED or WS_CAPTION or WS_MINIMIZEBOX or WS_SYSMENU
  rect.left = 0;
  rect.top = 0;
  rect.right = w.window.config.width
  rect.bottom = w.window.config.height
  AdjustWindowRect(&rect, WS_OVERLAPPEDWINDOW, 0)

  GetClientRect(GetDesktopWindow(), &clientRect)
  let left = (clientRect.right div 2) - ((rect.right - rect.left) div 2)
  let top = (clientRect.bottom div 2) - ((rect.bottom - rect.top) div 2)
  rect.right = rect.right - rect.left + left
  rect.left = left
  rect.bottom = rect.bottom - rect.top + top
  rect.top = top
  w.window.handle = CreateWindowW(classname, w.window.config.title, style, rect.left, rect.top,
    rect.right - rect.left, rect.bottom - rect.top,
    HWND_DESKTOP, cast[HMENU](NULL), hInstance, cast[LPVOID](w))
  if (w.window.handle == 0):
    # OleUninitialize()
    return -1

  SetWindowLongPtr(w.window.handle, GWLP_USERDATA, cast[LONG_PTR](w))
  # webviewContext.set(w.window.handle, w)
  # discard DisplayHTMLPage(w)

  SetWindowText(w.window.handle, w.window.config.title)
  ShowWindow(w.window.handle, SW_SHOWDEFAULT)
  UpdateWindow(w.window.handle)
  SetFocus(w.window.handle)
  return 0

proc webview_loop*(w: Webview, blocking:cint):cint =
  var msg: MSG
  if blocking == 1:
    if (GetMessage(msg.addr, 0, 0, 0)<0): return 0
  else:
    if not PeekMessage(msg.addr, 0, 0, 0, PM_REMOVE) == TRUE: return 0

  case msg.message:
  of WM_QUIT:
    return -1
  of WM_COMMAND,
    WM_KEYDOWN,
    WM_KEYUP:
    if (msg.wParam == VK_F5):
      return 0
    # var r:HRESULT = S_OK
    # var webBrowser2:ptr IWebBrowser2
    # var browser = w.priv.browser
    # if (browser[].QueryInterface( &IID_IWebBrowser2,
    #                                     cast[ptr pointer](webBrowser2.addr)) == S_OK) :
    #   var pIOIPAO:ptr IOleInPlaceActiveObject
    #   if (browser[].QueryInterface( &IID_IOleInPlaceActiveObject,
    #           cast[ptr pointer](pIOIPAO.addr)) == S_OK):
    #     r = pIOIPAO.TranslateAccelerator(msg.addr)
    #     discard pIOIPAO.lpVtbl.Release(cast[ptr IUnknown](pIOIPAO))
    #   discard webBrowser2.lpVtbl.Release(cast[ptr IUnknown](webBrowser2))
    # if (r != S_FALSE):
    #   return
  else:
    TranslateMessage(msg.addr)
    DispatchMessage(msg.addr)

  return 0

proc run*(w: Webview) {.inline.} =
  ## `run` starts the main UI loop until the user closes the window or `exit()` is called.
  block mainLoop:
    while w.webview_loop(1) == 0: discard

proc run*(w: Webview, quitProc: proc () {.noconv.}, controlCProc: proc () {.noconv.}, autoClose: static[bool] = true) {.inline.} =
  ## `run` starts the main UI loop until the user closes the window. Same as `run` but with extras.
  ## * `quitProc` is a function to run at exit, needs `{.noconv.}` pragma.
  ## * `controlCProc` is a function to run at CTRL+C, needs `{.noconv.}` pragma.
  ## * `autoClose` set to `true` to automatically run `exit()` at exit.
  system.addQuitProc(quitProc)
  system.setControlCHook(controlCProc)
  block mainLoop:
    while w.webview_loop(1) == 0: discard
  # when autoClose:
  #   w.webview_terminate()
  #   w.webview_exit()

when isMainModule:
  SetCurrentProcessExplicitAppUserModelID("webview2 app")
  var v = newWebView()
  assert v.webview_init() == 0
  v.init

  v.run