import winim
import com

var controller*: ptr ICoreWebView2Controller
var view*: ptr ICoreWebView2
var controllerCompletedHandler*: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler = create(ICoreWebView2CreateCoreWebView2ControllerCompletedHandler)
var winHandle*: HWND