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
    GetSettings*: proc (self: ptr ICoreWebView2;
        settings: ptr ICoreWebView2Settings): HRESULT
    GetSource*: HRESULT
    Navigate*: proc(self: ptr ICoreWebView2; url: LPCWSTR): HRESULT
    NavigateToString*: proc(self: ptr ICoreWebView2;
        html_content: LPCWSTR): HRESULT
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
    ExecuteScript*: proc(self: ptr ICoreWebView2; javaScript: LPCWSTR;
        handler: ptr ICoreWebView2ExecuteScriptCompletedHandler): HRESULT
    CapturePreview*: HRESULT
    Reload*: proc(self: ptr ICoreWebView2): HRESULT
    PostWebMessageAsJSON*: HRESULT
    PostWebMessageAsString*: HRESULT
    AddWebMessageReceived*: HRESULT
    RemoveWebMessageReceived*: HRESULT
    CallDevToolsProtocolMethod*: HRESULT
    GetBrowserProcessID*: HRESULT
    GetCanGoBack*: HRESULT
    GetCanGoForward*: HRESULT
    GoBack*: proc(self: ptr ICoreWebView2): HRESULT
    GoForward*: proc(self: ptr ICoreWebView2): HRESULT
    GetDevToolsProtocolEventReceiver*: HRESULT
    Stop*: proc(self: ptr ICoreWebView2): HRESULT
    AddNewWindowRequested*: HRESULT
    RemoveNewWindowRequested*: HRESULT
    AddDocumentTitleChanged*: HRESULT
    RemoveDocumentTitleChanged*: HRESULT
    GetDocumentTitle*: proc(self: ptr ICoreWebView2; title: LPWSTR): HRESULT
    AddHostObjectToScript*: HRESULT
    RemoveHostObjectFromScript*: HRESULT
    OpenDevToolsWindow*: proc(self: ptr ICoreWebView2): HRESULT
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
    GetBrowserVersionString*: proc(self: ptr ICoreWebView2Environment;
        version_info: LPWSTR): HRESULT
    AddNewBrowserVersionAvailable*: HRESULT
    RemoveNewBrowserVersionAvailable*: HRESULT
  ICoreWebView2Controller* {.pure, inheritable.} = object
    lpVtbl*: ptr ICoreWebView2ControllerVTBL
  ICoreWebView2ControllerVTBL* = object of IUnknownVtbl
    GetIsVisible*: proc(self: ptr ICoreWebView2Controller;
        is_visible: ptr bool): HRESULT
    PutIsVisible*: proc(self: ptr ICoreWebView2Controller;
        is_visible: bool): HRESULT
    GetBounds*: proc(self: ptr ICoreWebView2Controller;
        bounds: ptr RECT): HRESULT
    PutBounds*: proc(self: ptr ICoreWebView2Controller; bounds: RECT): HRESULT
    GetZoomFactor*: proc(self: ptr ICoreWebView2Controller;
        factor: ptr float64): HRESULT
    PutZoomFactor*: proc(self: ptr ICoreWebView2Controller;
        factor: float64): HRESULT
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
    GetParentWindow*: proc(self: ptr ICoreWebView2Controller;
        parent: ptr HWND): HRESULT
    PutParentWindow*: proc(self: ptr ICoreWebView2Controller;
        parent: HWND): HRESULT
    NotifyParentWindowPositionChanged*: proc(
        self: ptr ICoreWebView2Controller): HRESULT
    Close*: proc(self: ptr ICoreWebView2Controller): HRESULT
    GetCoreWebView2*: proc (self: ptr ICoreWebView2Controller;
        coreWebView2: ptr ptr ICoreWebView2): HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler * {.pure, inheritable.} = object
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL* {.pure, inheritable.}
    = object
    AddRef*: proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler):ULONG {.stdcall.}
    Release*: proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler):ULONG {.stdcall.}
    QueryInterface*: proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler; riid: REFIID, ppvObject: ptr pointer):HRESULT  {.stdcall.}
    Invoke*: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke * = proc (
      self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
      errorCode: HRESULT; createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.}
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler * {.pure.} = object
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL
  ICoreWebView2ExecuteScriptCompletedHandler * {.pure.} = object
    lpVtbl*: ptr ICoreWebView2ExecuteScriptCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler *
    {.pure.} = object
    lpVtbl*: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL *
    = object of IUnknownVtbl
    Invoke*: proc (self: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler;
        errorCode: HRESULT; id: LPCWSTR) {.stdcall.}
  ICoreWebView2ExecuteScriptCompletedHandlerVTBL * = object of IUnknownVtbl
    Invoke*: proc (self: ICoreWebView2ExecuteScriptCompletedHandler;
        errorCode: HRESULT; resultObjectAsJson: LPCWSTR) {.stdcall.}
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL*  {.pure, inheritable.}
    = object
    AddRef*: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler):ULONG {.stdcall.}
    Release*: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler):ULONG {.stdcall.}
    Invoke*: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
        errorCode: HRESULT; createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.}
    QueryInterface*: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler; riid: REFIID, ppvObject: ptr pointer):HRESULT  {.stdcall.}
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerInvok * = proc (
      i: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
      p: HRESULT; createdController: ptr ICoreWebView2Controller)
  ICoreWebView2SettingsVTBL* = object of IUnknownVtbl
    GetIsScriptEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT
    PutIsScriptEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT
    GetIsWebMessageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT
    PutIsWebMessageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT
    GetAreDefaultScriptDialogsEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT
    PutAreDefaultScriptDialogsEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT
    GetIsStatusBarEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT
    PutIsStatusBarEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT
    GetAreDevToolsEnabled*: proc (self: ptr ICoreWebView2Settings;
        areDevToolsEnabled: ptr bool): HRESULT
    PutAreDevToolsEnabled*: proc (self: ptr ICoreWebView2Settings;
        areDevToolsEnabled: bool): HRESULT
    GetAreDefaultContextMenusEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT
    PutAreDefaultContextMenusEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT
    GetAreHostObjectsAllowed*: proc (self: ptr ICoreWebView2Settings;
        allowed: ptr bool): HRESULT
    PutAreHostObjectsAllowed*: proc (self: ptr ICoreWebView2Settings;
        allowed: bool): HRESULT
    GetIsZoomControlEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT
    PutIsZoomControlEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT
    GetIsBuiltInErrorPageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT
    PutIsBuiltInErrorPageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT
  ICoreWebView2Settings* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2SettingsVTBL
