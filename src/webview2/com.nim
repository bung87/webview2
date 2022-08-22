import winim


type
  ICoreWebView2EnvironmentOptions* {.pure.} = object
    AdditionalBrowserArguments: LPWSTR
    AllowSingleSignOnUsingOSPrimaryAccount: BOOL
    Language: LPWSTR
    TargetCompatibleBrowserVersion: LPCWSTR
  ICoreWebView2* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2VTBL
  ICoreWebView2VTBL* = object of IUnknownVtbl
    GetSettings*: proc (self:ptr ICoreWebView2;
        settings: ptr ICoreWebView2Settings): HRESULT
    GetSource*: HRESULT
    Navigate*: proc(self:ptr ICoreWebView2; url: LPCWSTR): HRESULT
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
    ExecuteScript*: proc(self: ptr ICoreWebView2; javaScript:LPCWSTR;
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
    lpVtbl*: ptr ICoreWebView2EnvironmentVTBL
  ICoreWebView2EnvironmentVTBL* = object of IUnknownVtbl
    CreateCoreWebView2Controller*: proc(self: ptr ICoreWebView2Environment;
        parentWindow: HWND;
        handler: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): HRESULT
    CreateWebResourceResponse*: HRESULT
    GetBrowserVersionString*: HRESULT
    AddNewBrowserVersionAvailable*: HRESULT
    RemoveNewBrowserVersionAvailable*: HRESULT
  ICoreWebView2Controller* {.pure, inheritable.} = object
    lpVtbl*: ptr ICoreWebView2ControllerVTBL
  ICoreWebView2ControllerVTBL* = object of IUnknownVtbl
    GetIsVisible*: HRESULT
    PutIsVisible*: HRESULT
    GetBounds*: HRESULT
    PutBounds*: proc(self: ptr ICoreWebView2Controller; bounds: RECT): HRESULT
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
    GetCoreWebView2*: proc (self:ptr ICoreWebView2Controller;coreWebView2: ptr ptr ICoreWebView2): HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL*
    = object of IUnknownVtbl
    Invoke*: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke * = proc (
      self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
      p: HRESULT; createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.}
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL
  ICoreWebView2ExecuteScriptCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2ExecuteScriptCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL* = object of IUnknownVtbl
    Invoke*: proc (self:ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler;
        errorCode: HRESULT; id: LPCWSTR) {.stdcall.}
  ICoreWebView2ExecuteScriptCompletedHandlerVTBL * = object of IUnknownVtbl
    Invoke*: proc (self: ICoreWebView2ExecuteScriptCompletedHandler;
        errorCode: HRESULT; resultObjectAsJson: LPCWSTR) {.stdcall.}
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL*
    = object of IUnknownVtbl
    Invoke*: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
        errorCode:HRESULT; createdController:ptr ICoreWebView2Controller): HRESULT {.stdcall.}
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerInvok* = proc (
      i: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
      p: HRESULT; createdController: ptr ICoreWebView2Controller)
  ICoreWebView2SettingsVTBL* = object of IUnknownVtbl
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
    lpVtbl*: ptr ICoreWebView2SettingsVTBL
