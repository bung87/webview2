import webview2/[types,webview,browser,context]
import winim
import winim/inc/winuser
import winim/inc/mshtml
import winim/[utils]
import std/[os]

# {.passl: "-lole32 -lcomctl32 -lcomdlg32 -loleaut32 -luuid -lgdi32".}

const classname = "WebView"

const WEBVIEW_KEY_FEATURE_BROWSER_EMULATION = "Software\\Microsoft\\Internet Explorer\\Main\\FeatureControl\\FEATURE_BROWSER_EMULATION"

proc webview_fix_ie_compat_mode():int =
  var hKey:HKEY
  var ie_version:DWORD = 11000
  let p = extractFilename(getAppFilename())
  if (RegCreateKey(HKEY_CURRENT_USER, WEBVIEW_KEY_FEATURE_BROWSER_EMULATION,
                   &hKey) != ERROR_SUCCESS) :
    return -1
  
  if (RegSetValueEx(hKey, p, 0, REG_DWORD, cast[ptr BYTE](ie_version.addr),
                    sizeof(ie_version).DWORD) != ERROR_SUCCESS) :
    RegCloseKey(hKey)
    return -1
  
  RegCloseKey(hKey)
  return 0

proc wndproc(hwnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
    var w = cast[Webview](GetWindowLongPtr(hwnd, GWLP_USERDATA))

    case msg
      of WM_SIZE:
        w.browser.resize()

      of WM_CREATE:
        let cs = cast[ptr CREATESTRUCT](lParam)
        w = cast[Webview](cs.lpCreateParams)
        w[].window.handle = hwnd
        return EmbedBrowserObject(w)

      of WM_DESTROY:
        UnEmbedBrowserObject(w)
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

  if (webview_fix_ie_compat_mode() < 0):
    return -1

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
  RegisterClassEx(&wc)

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

  w.window.handle = CreateWindowEx(0, classname, w.window.config.title, style, rect.left, rect.top,
                     rect.right - rect.left, rect.bottom - rect.top,
                     HWND_DESKTOP, cast[HMENU](NULL), hInstance, w)
  if (w.window.handle == 0):
    OleUninitialize()
    return -1

  SetWindowLongPtr(w.window.handle, GWLP_USERDATA, cast[LONG_PTR](w))
  webviewContext.set(w.window.handle, w)
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