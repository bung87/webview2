import winim
import com
import types

const GUID = DEFINE_GUID"6671e93d-1a4b-49b3-b510-3d2fdb8ac864"

using
  self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler

proc Invoke*(self;
          errorCode: HRESULT;
          createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.} =
    return createdEnvironment.lpVtbl.CreateCoreWebView2Controller(
        createdEnvironment, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).handle, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).controllerCompletedHandler)

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
