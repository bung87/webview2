import winim
import com

var controller* = create(ICoreWebView2Controller)
var view*:ptr ICoreWebView2 = nil
var controllerCompletedHandler* = create(ICoreWebView2CreateCoreWebView2ControllerCompletedHandler)
var winHandle*: HWND