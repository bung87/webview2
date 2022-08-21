import winim

# type
#   BasicPtr = ptr Basic
#   Basic* = object
#     QueryInterface: proc (self: BasicPtr,
#                           riid: ptr UUID,
#                           pvObject: ptr pointer): HRESULT {.gcsafe,stdcall.}
#     AddRef: proc(self: BasicPtr): ULONG {.gcsafe, stdcall.}
#     Release: proc(self: BasicPtr): ULONG {.gcsafe, stdcall.}
#   BasicVTBLPtr = ptr BasicVTBL
#   BasicVTBL* = object
#     QueryInterface: proc (self: BasicVTBLPtr,
#                           riid: ptr UUID,
#                           pvObject: ptr pointer): HRESULT {.gcsafe,stdcall.}
#     AddRef: proc(self: BasicVTBLPtr): ULONG {.gcsafe, stdcall.}
#     Release: proc(self: BasicVTBLPtr): ULONG {.gcsafe, stdcall.}
type
  ICoreWebView2EnvironmentOptions* {.pure.} = object
    AdditionalBrowserArguments: LPWSTR
    AllowSingleSignOnUsingOSPrimaryAccount: BOOL
    Language: LPWSTR
    TargetCompatibleBrowserVersion: LPCWSTR
  ICoreWebView2* {.pure.} = object
    # Basic: Basic
    lpVtbl*: ptr ICoreWebView2VTBL
  ICoreWebView2VTBL* = object of IUnknownVtbl
    # BasicVTBL: BasicVTBL
    GetSettings*: proc (self: ICoreWebView2;
        settings: ptr ICoreWebView2Settings): HRESULT
    GetSource*: HRESULT
    Navigate*: proc(self: ICoreWebView2; url: LPCWSTR): HRESULT
    NavigateToString*: HRESULT
    AddNavigationStarting*: HRESULT
    RemoveNavigationStarting*: HRESULT
    AddContentLoading*: HRESULT
    RemoveContentLoading*: HRESULT
    AddSourceChanged*: HRESULT
    RemoveSourceChanged*: HRESULT
    AddHistoryChanged*: HRESULT
    RemoveHistoryChanged*: HRESULT
    AddNavigationCompleted*: HRESULT
    RemoveNavigationCompleted*: HRESULT
    AddFrameNavigationStarting*: HRESULT
    RemoveFrameNavigationStarting*: HRESULT
    AddFrameNavigationCompleted*: HRESULT
    RemoveFrameNavigationCompleted*: HRESULT
    AddScriptDialogOpening*: HRESULT
    RemoveScriptDialogOpening*: HRESULT
    AddPermissionRequested*: HRESULT
    RemovePermissionRequested*: HRESULT
    AddProcessFailed*: HRESULT
    RemoveProcessFailed*: HRESULT
    AddScriptToExecuteOnDocumentCreated * : proc(self: ICoreWebView2;
        javaScript: LPCWSTR;
        handler: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler): HRESULT
    RemoveScriptToExecuteOnDocumentCreated * : HRESULT
    ExecuteScript*: proc(self: ICoreWebView2; javaScript:LPCWSTR;
        handler: ptr ICoreWebView2ExecuteScriptCompletedHandler): HRESULT
    CapturePreview*: HRESULT
    Reload*: HRESULT
    PostWebMessageAsJSON*: HRESULT
    PostWebMessageAsString*: HRESULT
    AddWebMessageReceived*: HRESULT
    RemoveWebMessageReceived*: HRESULT
    CallDevToolsProtocolMethod*: HRESULT
    GetBrowserProcessID*: HRESULT
    GetCanGoBack*: HRESULT
    GetCanGoForward*: HRESULT
    GoBack*: HRESULT
    GoForward*: HRESULT
    GetDevToolsProtocolEventReceiver*: HRESULT
    Stop*: HRESULT
    AddNewWindowRequested*: HRESULT
    RemoveNewWindowRequested*: HRESULT
    AddDocumentTitleChanged*: HRESULT
    RemoveDocumentTitleChanged*: HRESULT
    GetDocumentTitle*: HRESULT
    AddHostObjectToScript*: HRESULT
    RemoveHostObjectFromScript*: HRESULT
    OpenDevToolsWindow*: HRESULT
    AddContainsFullScreenElementChanged * : HRESULT
    RemoveContainsFullScreenElementChanged * : HRESULT
    GetContainsFullScreenElement*: HRESULT
    AddWebResourceRequested*: HRESULT
    RemoveWebResourceRequested*: HRESULT
    AddWebResourceRequestedFilter*: HRESULT
    RemoveWebResourceRequestedFilter*: HRESULT
    AddWindowCloseRequested*: HRESULT
    RemoveWindowCloseRequested*: HRESULT
  ICoreWebView2Environment* {.pure.} = object
    # Basic*: Basic
    lpVtbl*: ptr ICoreWebView2EnvironmentVTBL
  ICoreWebView2EnvironmentVTBL* = object of IUnknownVtbl
    # BasicVTBL*: BasicVTBL
    CreateCoreWebView2Controller*: proc(self: ICoreWebView2Environment;
        parentWindow: HWND;
        handler: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): HRESULT
    CreateWebResourceResponse*: HRESULT
    GetBrowserVersionString*: HRESULT
    AddNewBrowserVersionAvailable*: HRESULT
    RemoveNewBrowserVersionAvailable*: HRESULT
  ICoreWebView2Controller* {.pure, inheritable.} = object
    lpVtbl*: ptr ICoreWebView2ControllerVTBL
  ICoreWebView2ControllerVTBL* = object of IUnknownVtbl
    # BasicVTBL: BasicVTBL
    GetIsVisible*: HRESULT
    PutIsVisible*: HRESULT
    GetBounds*: HRESULT
    PutBounds*: proc(self: ICoreWebView2Controller; bounds: RECT): HRESULT
    GetZoomFactor*: HRESULT
    PutZoomFactor*: HRESULT
    AddZoomFactorChanged*: HRESULT
    RemoveZoomFactorChanged*: HRESULT
    SetBoundsAndZoomFactor*: HRESULT
    MoveFocus*: HRESULT
    AddMoveFocusRequested*: HRESULT
    RemoveMoveFocusRequested*: HRESULT
    AddGotFocus*: HRESULT
    RemoveGotFocus*: HRESULT
    AddLostFocus*: HRESULT
    RemoveLostFocus*: HRESULT
    AddAcceleratorKeyPressed*: HRESULT
    RemoveAcceleratorKeyPressed*: HRESULT
    GetParentWindow*: HRESULT
    PutParentWindow*: HRESULT
    NotifyParentWindowPositionChanged*: HRESULT
    Close*: HRESULT
    GetCoreWebView2*: proc (self:ICoreWebView2Controller;coreWebView2: ptr ref ICoreWebView2): HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler * {.pure.} = object
    # Basic*:Basic
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL *
    = object of IUnknownVtbl
    # BasicVTBL*:BasicVTBL
    Invoke*: proc(i: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
         errorCode: HRESULT; createdEnvironment: ptr ICoreWebView2Environment): HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke * = proc (
      i: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
      p: HRESULT; createdEnvironment: ptr ICoreWebView2Environment)
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* {.pure.} = object
    # Basic*:Basic
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL
  ICoreWebView2ExecuteScriptCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2ExecuteScriptCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL* = object of IUnknownVtbl
    Invoke*: proc (self: ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler;
        errorCode: HRESULT; id: LPCWSTR)
  ICoreWebView2ExecuteScriptCompletedHandlerVTBL * = object of IUnknownVtbl
    Invoke*: proc (self: ICoreWebView2ExecuteScriptCompletedHandler;
        errorCode: HRESULT; resultObjectAsJson: LPCWSTR)
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL*
    = object of IUnknownVtbl
    # BasicVTBL*:BasicVTBL
    Invoke*: proc(i: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
        errorCode:HRESULT; createdController: ICoreWebView2Controller): HRESULT
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerInvok* = proc (
      i: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
      p: HRESULT; createdController: ptr ICoreWebView2Controller)
  ICoreWebView2SettingsVTBL* = object of IUnknownVtbl
    # BasicVTBL*:BasicVTBL
    GetIsScriptEnabled*: pointer
    PutIsScriptEnabled*: pointer
    GetIsWebMessageEnabled*: pointer
    PutIsWebMessageEnabled*: pointer
    GetAreDefaultScriptDialogsEnabled*: pointer
    PutAreDefaultScriptDialogsEnabled*: pointer
    GetIsStatusBarEnabled*: pointer
    PutIsStatusBarEnabled*: pointer
    GetAreDevToolsEnabled*: pointer
    PutAreDevToolsEnabled*: pointer
    GetAreDefaultContextMenusEnabled*: pointer
    PutAreDefaultContextMenusEnabled*: pointer
    GetAreHostObjectsAllowed*: pointer
    PutAreHostObjectsAllowed*: pointer
    GetIsZoomControlEnabled*: pointer
    PutIsZoomControlEnabled*: pointer
    GetIsBuiltInErrorPageEnabled*: pointer
    PutIsBuiltInErrorPageEnabled*: pointer
  ICoreWebView2Settings* {.pure.} = object
    # Basic*:Basic
    lpVtbl*: ptr ICoreWebView2SettingsVTBL

# proc QueryInterface*(self:BasicPtr;_:ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler):HRESULT =
#   result = 0

# proc AddRef*(self:BasicPtr;_:ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler):HRESULT =
#   result = 1

# proc Release*(self:BasicPtr;_:ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler):HRESULT =
#   result = 1


# proc newBasicVTBL*(h: BasicPtr): BasicVTBL =
#   result = BasicVTBL(
#     QueryInterface: cast[BasicVTBLPtr](h).QueryInterface,
#     AddRef:         cast[BasicVTBLPtr](h).AddRef,
#     Release:        cast[BasicVTBLPtr](h).Release,
#   )
