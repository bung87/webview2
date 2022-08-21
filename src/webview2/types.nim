import winim
import com
import std/[atomics]

type 
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
    hwnd*: HWND
    config*: BrowserConfig
    view*: ref ICoreWebView2
    controller*: ICoreWebView2Controller
    settings*: ICoreWebView2Settings
    controllerCompleted*:  Atomic[int32]
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
# https://arsd-official.dpldocs.info/arsd.webview.ICoreWebView2EnvironmentOptions.html
# ptr ICoreWebView2EnvironmentOptions
type 
  WebViewObj = object
    # dll*: proc (browserExecutableFolder: PCWSTR; userDataFolder: PCWSTR; environmentOptions: pointer; environmentCreatedHandler: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ): HRESULT {.cdecl,gcsafe.}
    window*: Window
    browser*: Browser
  WebView* = ref WebViewObj