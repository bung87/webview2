import winim
import com
import types

using
  self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler

proc Invoke*(self;
        errorCode: HRESULT;
        createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.} =
    discard createdController.lpVtbl.AddRef(cast[ptr IUnknown](createdController))
    discard createdController.lpVtbl.GetCoreWebView2(createdController, cast[
        ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view.addr)
    
    cast[ptr ControllerCompletedHandlerVTBL](
        self.lpVtbl).controller = createdController

    discard cast[ptr ControllerCompletedHandlerVTBL](
        self.lpVtbl).view.lpVtbl.AddRef(cast[ptr IUnknown](cast[
        ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view))
    # wv.browser.controllerCompleted.store(1)
    return 0

proc AddRef*(self): ULONG {.stdcall.} = 1

proc Release*(self): ULONG {.stdcall.} = 1

proc QueryInterface*(self; riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
    ppvObject[] = self
    discard self.lpVtbl.AddRef(self)
    return S_OK