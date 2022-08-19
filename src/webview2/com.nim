import winim

type
  Basic* = object
  BasicVTBL* = object 
    # QueryInterface 
  ICoreWebView2* = object
    Basic: Basic
    VTBL: ptr ICoreWebView2VTBL 
  ICoreWebView2VTBL* = object
    BasicVTBL: BasicVTBL         
    GetSettings: HRESULT 
    GetSource: HRESULT 
    Navigate                               :HRESULT 
    NavigateToString                       :HRESULT 
    AddNavigationStarting                  :HRESULT 
    RemoveNavigationStarting               :HRESULT 
    AddContentLoading                      :HRESULT 
    RemoveContentLoading                   :HRESULT 
    AddSourceChanged                       :HRESULT 
    RemoveSourceChanged                    :HRESULT 
    AddHistoryChanged                      :HRESULT 
    RemoveHistoryChanged                   :HRESULT 
    AddNavigationCompleted                 :HRESULT 
    RemoveNavigationCompleted              :HRESULT 
    AddFrameNavigationStarting             :HRESULT 
    RemoveFrameNavigationStarting          :HRESULT 
    AddFrameNavigationCompleted            :HRESULT 
    RemoveFrameNavigationCompleted         :HRESULT 
    AddScriptDialogOpening                 :HRESULT 
    RemoveScriptDialogOpening              :HRESULT 
    AddPermissionRequested                 :HRESULT 
    RemovePermissionRequested              :HRESULT 
    AddProcessFailed                       :HRESULT 
    RemoveProcessFailed                    :HRESULT 
    AddScriptToExecuteOnDocumentCreated    :HRESULT 
    RemoveScriptToExecuteOnDocumentCreated :HRESULT 
    ExecuteScript                          :HRESULT 
    CapturePreview                         :HRESULT 
    Reload                                 :HRESULT 
    PostWebMessageAsJSON                   :HRESULT 
    PostWebMessageAsString                 :HRESULT 
    AddWebMessageReceived                  :HRESULT 
    RemoveWebMessageReceived               :HRESULT 
    CallDevToolsProtocolMethod             :HRESULT 
    GetBrowserProcessID                    :HRESULT 
    GetCanGoBack                           :HRESULT 
    GetCanGoForward                        :HRESULT 
    GoBack                                 :HRESULT 
    GoForward                              :HRESULT 
    GetDevToolsProtocolEventReceiver       :HRESULT 
    Stop                                   :HRESULT 
    AddNewWindowRequested                  :HRESULT 
    RemoveNewWindowRequested               :HRESULT 
    AddDocumentTitleChanged                :HRESULT 
    RemoveDocumentTitleChanged             :HRESULT 
    GetDocumentTitle                       :HRESULT 
    AddHostObjectToScript                  :HRESULT 
    RemoveHostObjectFromScript             :HRESULT 
    OpenDevToolsWindow                     :HRESULT 
    AddContainsFullScreenElementChanged    :HRESULT 
    RemoveContainsFullScreenElementChanged :HRESULT 
    GetContainsFullScreenElement           :HRESULT 
    AddWebResourceRequested                :HRESULT 
    RemoveWebResourceRequested             :HRESULT 
    AddWebResourceRequestedFilter          :HRESULT 
    RemoveWebResourceRequestedFilter       :HRESULT 
    AddWindowCloseRequested                :HRESULT 
    RemoveWindowCloseRequested             :HRESULT 
  ICoreWebView2Controller* = object
    VTBL: ptr ICoreWebView2ControllerVTBL
  ICoreWebView2ControllerVTBL* = object
    BasicVTBL: BasicVTBL
    GetIsVisible                      :HRESULT
    PutIsVisible                      :HRESULT
    GetBounds                         :HRESULT
    PutBounds                         :HRESULT
    GetZoomFactor                     :HRESULT
    PutZoomFactor                     :HRESULT
    AddZoomFactorChanged              :HRESULT
    RemoveZoomFactorChanged           :HRESULT
    SetBoundsAndZoomFactor            :HRESULT
    MoveFocus                         :HRESULT
    AddMoveFocusRequested             :HRESULT
    RemoveMoveFocusRequested          :HRESULT
    AddGotFocus                       :HRESULT
    RemoveGotFocus                    :HRESULT
    AddLostFocus                      :HRESULT
    RemoveLostFocus                   :HRESULT
    AddAcceleratorKeyPressed          :HRESULT
    RemoveAcceleratorKeyPressed       :HRESULT
    GetParentWindow                   :HRESULT
    PutParentWindow                   :HRESULT
    NotifyParentWindowPositionChanged :HRESULT
    Close                             :HRESULT
    GetCoreWebView2                   :HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler* = object
    Basic:Basic
    VTBL:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL* = object
    BasicVTBL:BasicVTBL
    Invoke:HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke* = proc (i: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke; p:HRESULT;createdEnvironment:ptr ICoreWebView2Environment)
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* = object
    Basic:Basic
    VTBL: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL* = object
    BasicVTBL:BasicVTBL
    Invoke: pointer
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerInvoke* = proc (i: ptr  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;p:HRESULT;createdController: ptr ICoreWebView2Controller  )
  ICoreWebView2SettingsVTBL* = object
    BasicVTBL:BasicVTBL
    GetIsScriptEnabled                :HRESULT
    PutIsScriptEnabled                :HRESULT
    GetIsWebMessageEnabled            :HRESULT
    PutIsWebMessageEnabled            :HRESULT
    GetAreDefaultScriptDialogsEnabled :HRESULT
    PutAreDefaultScriptDialogsEnabled :HRESULT
    GetIsStatusBarEnabled             :HRESULT
    PutIsStatusBarEnabled             :HRESULT
    GetAreDevToolsEnabled             :HRESULT
    PutAreDevToolsEnabled             :HRESULT
    GetAreDefaultContextMenusEnabled  :HRESULT
    PutAreDefaultContextMenusEnabled  :HRESULT
    GetAreHostObjectsAllowed          :HRESULT
    PutAreHostObjectsAllowed          :HRESULT
    GetIsZoomControlEnabled           :HRESULT
    PutIsZoomControlEnabled           :HRESULT
    GetIsBuiltInErrorPageEnabled      :HRESULT
    PutIsBuiltInErrorPageEnabled      :HRESULT
  ICoreWebView2Settings* = object
    Basic:Basic
    VTBL: ptr ICoreWebView2SettingsVTBL

proc newBasicVTBL*(h: Basic): BasicVTBL =
  result = BasicVTBL(
    QueryInterface: h.QueryInterface,
    AddRef:         h.AddRef,
    Release:        h.Release,
  )