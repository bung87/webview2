import winim
import com
# import std/[atomics]

type 
  BrowserContext* = object
    windowHandle*: HWND
    view*: ptr ICoreWebView2
    controller*: ptr ICoreWebView2Controller
    settings*: ptr ICoreWebView2Settings
  BrowserConfig* = object
    initialURL*:string
    builtInErrorPage*     :bool
    defaultContextMenus*  :bool
    defaultScriptDialogs* :bool
    devtools*             :bool
    hostObjects*          :bool
    script*               :bool
    statusBar*            :bool
    webMessage*           :bool
    zoomControl*          :bool
  BrowserObj = object
    # hwnd*: HWND
    ctx*: BrowserContext
    config*: BrowserConfig

    # view*: ptr ICoreWebView2
    # controller*: ptr ICoreWebView2Controller
    # settings*: ptr ICoreWebView2Settings
    # controllerCompleted*:  Atomic[int32]
  Browser* = ref BrowserObj

type WindowConfig* = object
  title*: string
  width*, height*: int32
  maxWidth*, maxHeight*: int32
  minWidth*, minHeight*: int32

type 
  WindowObj = object
    config*: WindowConfig
    handle*: HWND
  Window* = ref WindowObj

type 
  WebViewObj = object
    window*: Window
    browser*: Browser
  WebView* = ref WebViewObj
