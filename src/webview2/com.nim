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
  ICoreWebView2* {.pure.} = object
    # Basic: Basic
    lpVtbl: ptr ICoreWebView2VTBL 
  ICoreWebView2VTBL* = object of IUnknownVtbl
    # BasicVTBL: BasicVTBL         
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
  ICoreWebView2Environment* = object
    # Basic*: Basic
    lpVtbl*: ptr ICoreWebView2EnvironmentVTBL
  ICoreWebView2EnvironmentVTBL* = object of IUnknownVtbl
    # BasicVTBL*: BasicVTBL
    CreateCoreWebView2Controller*     :HRESULT
    CreateWebResourceResponse*        :HRESULT
    GetBrowserVersionString*          :HRESULT
    AddNewBrowserVersionAvailable*    :HRESULT
    RemoveNewBrowserVersionAvailable* :HRESULT
  ICoreWebView2Controller* = object
    lpVtbl*: ptr ICoreWebView2ControllerVTBL
  ICoreWebView2ControllerVTBL* = object of IUnknownVtbl
    # BasicVTBL: BasicVTBL
    GetIsVisible*                      :HRESULT
    PutIsVisible*                      :HRESULT
    GetBounds*                         :HRESULT
    PutBounds*                         :HRESULT
    GetZoomFactor*                     :HRESULT
    PutZoomFactor*                     :HRESULT
    AddZoomFactorChanged*              :HRESULT
    RemoveZoomFactorChanged*           :HRESULT
    SetBoundsAndZoomFactor*            :HRESULT
    MoveFocus*                         :HRESULT
    AddMoveFocusRequested*             :HRESULT
    RemoveMoveFocusRequested*          :HRESULT
    AddGotFocus*                       :HRESULT
    RemoveGotFocus*                    :HRESULT
    AddLostFocus*                      :HRESULT
    RemoveLostFocus*                   :HRESULT
    AddAcceleratorKeyPressed*          :HRESULT
    RemoveAcceleratorKeyPressed*       :HRESULT
    GetParentWindow*                   :HRESULT
    PutParentWindow*                   :HRESULT
    NotifyParentWindowPositionChanged* :HRESULT
    Close*                             :HRESULT
    GetCoreWebView2*                   :HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler* {.pure.} = object
    # Basic*:Basic
    lpVtbl*:ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVTBL* = object of IUnknownVtbl
    # BasicVTBL*:BasicVTBL
    Invoke*:HRESULT
  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerInvoke* = proc (i: ptr ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler; p:HRESULT;createdEnvironment:ptr ICoreWebView2Environment)
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* {.pure.} = object
    # Basic*:Basic
    lpVtbl*: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVTBL* =  object of IUnknownVtbl
    # BasicVTBL*:BasicVTBL
    Invoke*: pointer
  ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerInvoke* = proc (i: ptr  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;p:HRESULT;createdController: ptr ICoreWebView2Controller  )
  ICoreWebView2SettingsVTBL* = object of IUnknownVtbl
    # BasicVTBL*:BasicVTBL
    GetIsScriptEnabled*                :HRESULT
    PutIsScriptEnabled*                :HRESULT
    GetIsWebMessageEnabled*            :HRESULT
    PutIsWebMessageEnabled*            :HRESULT
    GetAreDefaultScriptDialogsEnabled* :HRESULT
    PutAreDefaultScriptDialogsEnabled* :HRESULT
    GetIsStatusBarEnabled*             :HRESULT
    PutIsStatusBarEnabled*             :HRESULT
    GetAreDevToolsEnabled*             :HRESULT
    PutAreDevToolsEnabled*             :HRESULT
    GetAreDefaultContextMenusEnabled*  :HRESULT
    PutAreDefaultContextMenusEnabled*  :HRESULT
    GetAreHostObjectsAllowed*          :HRESULT
    PutAreHostObjectsAllowed*          :HRESULT
    GetIsZoomControlEnabled*           :HRESULT
    PutIsZoomControlEnabled*           :HRESULT
    GetIsBuiltInErrorPageEnabled*      :HRESULT
    PutIsBuiltInErrorPageEnabled*      :HRESULT
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