import winim
import com
import types

using
  self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler

proc Invoke*(self;
          errorCode: HRESULT;
          createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.} =
    discard createdEnvironment.lpVtbl.CreateCoreWebView2Controller(
        createdEnvironment, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).handle, cast[ptr EnvironmentCompletedHandlerVTBL](
        self.lpVtbl).controllerCompletedHandler)
    return 0

proc AddRef*(self): ULONG {.stdcall.} = 1

proc Release*(self): ULONG {.stdcall.} = 1

proc QueryInterface*(self;
      riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
    var guid = DEFINE_GUID"4E8A3389-C9D8-4BD2-B6B5-124FEE6CC14D"
    if IsEqualIID(riid, guid.addr):
      ppvObject[] = self
      discard self.lpVtbl.AddRef(self)
      return S_OK
    else:
      ppvObject[] = nil
      return E_NOINTERFACE