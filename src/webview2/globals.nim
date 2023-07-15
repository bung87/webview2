import winim
import com

var controller* {.cursor.}: ptr ICoreWebView2Controller
var view* {.cursor.}: ptr ICoreWebView2
var controllerCompletedHandler* {.cursor.}:ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler
var winHandle*: HWND