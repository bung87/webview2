import winim
import com
import types
import globals

const GUID = DEFINE_GUID"4E8A3389-C9D8-4BD2-B6B5-124FEE6CC14D"

using
  self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler

proc Invoke*(self;
          errorCode: HRESULT;
          createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.} =
    echo "ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler.Invoke"
    if errorCode != S_OK:
      return errorCode
    let hr = createdEnvironment.lpVtbl.CreateCoreWebView2Controller(
        createdEnvironment, winHandle, controllerCompletedHandler)
    assert hr == S_OK
    return hr

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
