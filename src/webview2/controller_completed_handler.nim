import winim
import com
import types

const GUID = DEFINE_GUID"6C4819F3-C9B7-4260-8127-C9F5BDE7F68C"

using
  self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler

proc Invoke*(self;
    errorCode: HRESULT;
    createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.} =
  discard createdController.lpVtbl.AddRef(cast[ptr IUnknown](createdController))
  let hr = createdController.lpVtbl.GetCoreWebView2(createdController, cast[
    ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view.addr)
  if S_OK != hr:
    return hr

  cast[ptr ControllerCompletedHandlerVTBL](
    self.lpVtbl).controller = createdController

  discard cast[ptr ControllerCompletedHandlerVTBL](
    self.lpVtbl).view.lpVtbl.AddRef(cast[ptr IUnknown](cast[
    ptr ControllerCompletedHandlerVTBL](self.lpVtbl).view))
  # wv.browser.controllerCompleted.store(1)
  return S_OK

proc AddRef*(self): ULONG {.stdcall.} =
  inc self.refCount
  return self.refCount

proc Release*(self): ULONG {.stdcall.} =
  if self.refCount > 1:
    dec self.refCount
    return self.refCount

  dealloc self
  return 0

proc QueryInterface*(self; riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
  if ppvObject == nil:
    return E_NOINTERFACE
  if riid[] == GUID:
    ppvObject[] = self
    discard self.lpVtbl.AddRef(self)
    return S_OK
  else:
    ppvObject[] = nil
    return E_NOINTERFACE
