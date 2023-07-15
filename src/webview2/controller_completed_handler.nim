import winim
import com
import globals

const GUID = DEFINE_GUID"6C4819F3-C9B7-4260-8127-C9F5BDE7F68C"
const  IID_ICoreWebView2Controller2 = DEFINE_GUID"C979903E-D4CA-4228-92EB-47EE3FA96EAB"

using
  self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler

proc Invoke*(self;
    errorCode: HRESULT;
    createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.} =
  if errorCode != S_OK:
    return errorCode
  assert createdController != nil
  controller = createdController
  var bounds: RECT
  GetClientRect(winHandle, bounds)
  discard controller.lpVtbl.AddRef(controller)
  discard controller.lpVtbl.put_Bounds(controller, bounds)
  discard controller.lpVtbl.put_IsVisible(controller, true)
  let hr = controller.lpVtbl.get_CoreWebView2(controller, view.addr)
  discard view.lpVtbl.AddRef(view)
  if S_OK != hr:
    return hr
  doAssert view != nil
  var settings: ptr ICoreWebView2Settings
  let hr1 = view.lpVtbl.get_Settings(view, settings.addr)
  discard settings.lpVtbl.PutIsScriptEnabled(settings, true)
  discard settings.lpVtbl.PutAreDefaultScriptDialogsEnabled(settings, true)
  discard settings.lpVtbl.PutIsWebMessageEnabled(settings, true)
  discard settings.lpVtbl.PutAreDevToolsEnabled(settings, true)
  discard view.lpVtbl.Navigate(view, L"https://nim-lang.org")
  return S_OK

proc AddRef*(self): ULONG {.stdcall.} =
  return 1

proc Release*(self): ULONG {.stdcall.} =
  return 0

proc QueryInterface*(self; riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
  if ppvObject == nil:
    return E_NOINTERFACE
  if riid[] == GUID or riid[] == IID_IUnknown:
    ppvObject[] = self
    return S_OK
  else:
    ppvObject[] = nil
    return E_NOINTERFACE
