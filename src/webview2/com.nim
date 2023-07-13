import winim


type
  ICoreWebView2EnvironmentOptions* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2EnvironmentOptionsVTBL

  ICoreWebView2EnvironmentOptionsVTBL* {.pure.} = object
    QueryInterface*: proc(self: ptr ICoreWebView2EnvironmentOptions;
        riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.}
    AddRef*: proc (self: ptr ICoreWebView2EnvironmentOptions): ULONG {.stdcall.}
    Release*: proc (self: ptr ICoreWebView2EnvironmentOptions): ULONG {.stdcall.}
    get_AdditionalBrowserArguments*: proc (
        self: ptr ICoreWebView2EnvironmentOptions;
        value: ptr LPWSTR): HRESULT {.stdcall.}
    put_AdditionalBrowserArguments*: proc (
        self: ptr ICoreWebView2EnvironmentOptions;
        value: LPCWSTR): HRESULT {.stdcall.}
    get_Language*: proc(self: ptr ICoreWebView2EnvironmentOptions;
        value: ptr LPWSTR): HRESULT {.stdcall.}
    put_Language*: proc (self: ptr ICoreWebView2EnvironmentOptions;
        value: LPCWSTR): HRESULT {.stdcall.}
    get_TargetCompatibleBrowserVersion* : proc (
        self: ptr ICoreWebView2EnvironmentOptions;
        value: ptr LPWSTR): HRESULT {.stdcall.}
    put_TargetCompatibleBrowserVersion* : proc (
        self: ptr ICoreWebView2EnvironmentOptions;
        value: LPCWSTR): HRESULT {.stdcall.}
    get_AllowSingleSignOnUsingOSPrimaryAccount* : proc(
        self: ptr ICoreWebView2EnvironmentOptions;
        allow: ptr BOOL): HRESULT {.stdcall.}
    put_AllowSingleSignOnUsingOSPrimaryAccount* : proc(
        self: ptr ICoreWebView2EnvironmentOptions;
        allow: BOOL): HRESULT {.stdcall.}
    # ICoreWebView2EnvironmentOptions2
    get_ExclusiveUserDataFolderAccess*: proc (self: ptr ICoreWebView2EnvironmentOptions;value: ptr BOOL): HRESULT {.stdcall.}
    put_ExclusiveUserDataFolderAccess*: proc (self: ptr ICoreWebView2EnvironmentOptions;value: BOOL): HRESULT {.stdcall.}
  ICoreWebView2* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2VTBL
  ICoreWebView2VTBL* = object of IUnknownVtbl
    GetSettings*: proc (self: ptr ICoreWebView2;
        settings: ptr ICoreWebView2Settings): HRESULT {.stdcall.}
    GetSource*: HRESULT
    Navigate*: proc (self: ptr ICoreWebView2; url: LPCWSTR): HRESULT {.stdcall.}
    NavigateToString*: proc (self: ptr ICoreWebView2;
        html_content: LPCWSTR): HRESULT {.stdcall.}
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
    AddScriptToExecuteOnDocumentCreated * : proc (self: ICoreWebView2;
        javaScript: LPCWSTR;
        handler: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler): HRESULT {.stdcall.}
    RemoveScriptToExecuteOnDocumentCreated * : HRESULT
    ExecuteScript*: proc (self: ptr ICoreWebView2; javaScript: LPCWSTR;
        handler: ptr ICoreWebView2ExecuteScriptCompletedHandler): HRESULT {.stdcall.}
    CapturePreview*: HRESULT
    Reload*: proc (self: ptr ICoreWebView2): HRESULT {.stdcall.}
    PostWebMessageAsJSON*: HRESULT
    PostWebMessageAsString*: HRESULT
    AddWebMessageReceived*: HRESULT
    RemoveWebMessageReceived*: HRESULT
    CallDevToolsProtocolMethod*: HRESULT
    GetBrowserProcessID*: HRESULT
    GetCanGoBack*: HRESULT
    GetCanGoForward*: HRESULT
    GoBack*: proc (self: ptr ICoreWebView2): HRESULT {.stdcall.}
    GoForward*: proc (self: ptr ICoreWebView2): HRESULT {.stdcall.}
    GetDevToolsProtocolEventReceiver*: HRESULT
    Stop*: proc (self: ptr ICoreWebView2): HRESULT {.stdcall.}
    AddNewWindowRequested*: HRESULT
    RemoveNewWindowRequested*: HRESULT
    AddDocumentTitleChanged*: HRESULT
    RemoveDocumentTitleChanged*: HRESULT
    GetDocumentTitle*: proc (self: ptr ICoreWebView2; title: LPWSTR): HRESULT {.stdcall.}
    AddHostObjectToScript*: HRESULT
    RemoveHostObjectFromScript*: HRESULT
    OpenDevToolsWindow*: proc (self: ptr ICoreWebView2): HRESULT {.stdcall.}
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
    CreateCoreWebView2Controller*: proc (self: ptr ICoreWebView2Environment;
        parentWindow: HWND;
        handler: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): HRESULT {.stdcall.}
    CreateWebResourceResponse*: HRESULT
    GetBrowserVersionString*: proc (self: ptr ICoreWebView2Environment;
        version_info: LPWSTR): HRESULT {.stdcall.}
    AddNewBrowserVersionAvailable*: HRESULT
    RemoveNewBrowserVersionAvailable*: HRESULT
    # ICoreWebView2Environment7
    get_UserDataFolder*: proc (self: ptr ICoreWebView2Environment;value: ptr LPWSTR): HRESULT
  ICoreWebView2Controller* {.pure, inheritable.} = object
    lpVtbl*: ptr ICoreWebView2ControllerVTBL
  ICoreWebView2ControllerVTBL* = object of IUnknownVtbl
    add_AcceleratorKeyPressed*: proc (): HRESULT {.stdcall.}
    add_GotFocus*: proc (): HRESULT {.stdcall.}
    add_LostFocus*: proc (): HRESULT {.stdcall.}
    add_MoveFocusRequested*: proc (): HRESULT {.stdcall.}
    add_ZoomFactorChanged*: proc (): HRESULT {.stdcall.}
    Close*: proc (self: ptr ICoreWebView2Controller): HRESULT {.stdcall.}
    get_Bounds*: proc (self: ptr ICoreWebView2Controller;
        bounds: ptr RECT): HRESULT {.stdcall.}
    get_CoreWebView2*: proc (self: ptr ICoreWebView2Controller;
        coreWebView2: ptr ptr ICoreWebView2): HRESULT {.stdcall.}
    get_IsVisible*: proc (self: ptr ICoreWebView2Controller;
        is_visible: ptr bool): HRESULT {.stdcall.}
    get_ParentWindow*: proc (self: ptr ICoreWebView2Controller;
        parent: ptr HWND): HRESULT {.stdcall.}
    get_ZoomFactor*: proc (self: ptr ICoreWebView2Controller;
        factor: ptr float64): HRESULT {.stdcall.}
    MoveFocus*: proc (): HRESULT {.stdcall.}
    NotifyParentWindowPositionChanged*: proc (
        self: ptr ICoreWebView2Controller): HRESULT {.stdcall.}
    put_Bounds*: proc (self: ptr ICoreWebView2Controller; bounds: RECT): HRESULT
    put_IsVisible*: proc (self: ptr ICoreWebView2Controller;
        is_visible: bool): HRESULT {.stdcall.}
    put_ParentWindow*: proc (self: ptr ICoreWebView2Controller;
        parent: HWND): HRESULT {.stdcall.}
    put_ZoomFactor*: proc (self: ptr ICoreWebView2Controller;
        factor: float64): HRESULT {.stdcall.}
    remove_AcceleratorKeyPressed*: proc (): HRESULT {.stdcall.}
    remove_GotFocus*: proc (): HRESULT {.stdcall.}
    remove_LostFocus*: proc (): HRESULT {.stdcall.}
    remove_MoveFocusRequested*: proc (): HRESULT {.stdcall.}
    remove_ZoomFactorChanged*: proc (): HRESULT {.stdcall.}
    SetBoundsAndZoomFactor*: proc (): HRESULT {.stdcall.}
    # ICoreWebView2Controller2
    get_DefaultBackgroundColor*: proc (): HRESULT {.stdcall.}
    put_DefaultBackgroundColor*: proc (): HRESULT {.stdcall.}
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler* {.pure, inheritable.} = object
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
    # refCount*: ULONG
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL* {.pure, inheritable.} = object
    QueryInterface*: proc(self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
        riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.}
    AddRef*: proc (self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): ULONG {.stdcall.}
    Release*: proc (self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): ULONG {.stdcall.}
    Invoke*: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke

  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke* = proc (
      self: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
      errorCode: HRESULT; createdEnvironment: ptr ICoreWebView2Environment): HRESULT {.stdcall.}
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL

  ICoreWebView2ExecuteScriptCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2ExecuteScriptCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL
  ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVTBL* = object of IUnknownVtbl
    Invoke*: proc (self: ptr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler;
        errorCode: HRESULT; id: LPCWSTR) {.stdcall.}
  ICoreWebView2ExecuteScriptCompletedHandlerVTBL * = object of IUnknownVtbl
    Invoke*: proc (self: ICoreWebView2ExecuteScriptCompletedHandler;
        errorCode: HRESULT; resultObjectAsJson: LPCWSTR) {.stdcall.}

  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL* {.pure, inheritable.} = object
    QueryInterface*: proc(self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
        riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.}
    AddRef*: proc (self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): ULONG {.stdcall.}
    Release*: proc (self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): ULONG {.stdcall.}
    Invoke*: ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerInvoke

  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerInvoke* = proc (
      i: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
      errorCode: HRESULT; createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.}
  ICoreWebView2SettingsVTBL* = object of IUnknownVtbl
    GetIsScriptEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT {.stdcall.}
    PutIsScriptEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT {.stdcall.}
    GetIsWebMessageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT {.stdcall.}
    PutIsWebMessageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT {.stdcall.}
    GetAreDefaultScriptDialogsEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT {.stdcall.}
    PutAreDefaultScriptDialogsEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT {.stdcall.}
    GetIsStatusBarEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT {.stdcall.}
    PutIsStatusBarEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT {.stdcall.}
    GetAreDevToolsEnabled*: proc (self: ptr ICoreWebView2Settings;
        areDevToolsEnabled: ptr bool): HRESULT {.stdcall.}
    PutAreDevToolsEnabled*: proc (self: ptr ICoreWebView2Settings;
        areDevToolsEnabled: bool): HRESULT
    GetAreDefaultContextMenusEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT {.stdcall.}
    PutAreDefaultContextMenusEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT {.stdcall.}
    GetAreHostObjectsAllowed*: proc (self: ptr ICoreWebView2Settings;
        allowed: ptr bool): HRESULT {.stdcall.}
    PutAreHostObjectsAllowed*: proc (self: ptr ICoreWebView2Settings;
        allowed: bool): HRESULT {.stdcall.}
    GetIsZoomControlEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT {.stdcall.}
    PutIsZoomControlEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT {.stdcall.}
    GetIsBuiltInErrorPageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: ptr bool): HRESULT {.stdcall.}
    PutIsBuiltInErrorPageEnabled*: proc (self: ptr ICoreWebView2Settings;
        enabled: bool): HRESULT {.stdcall.}
  ICoreWebView2Settings* {.pure.} = object
    lpVtbl*: ptr ICoreWebView2SettingsVTBL
