import winim
import com
import types

using
  self: ptr ICoreWebView2EnvironmentOptions


proc get_AdditionalBrowserArguments*(self;value: ptr LPWSTR): HRESULT {.stdcall.} =
  value[] = self.lpVtbl.AdditionalBrowserArguments
  return S_OK
proc get_AllowSingleSignOnUsingOSPrimaryAccount*(self;allow: ptr BOOL): HRESULT {.stdcall.} =
  allow[] = self.lpVtbl.AllowSingleSignOnUsingOSPrimaryAccount
  return S_OK
proc get_Language*(self;value: ptr LPWSTR): HRESULT {.stdcall.} =
  value[] = self.lpVtbl.Language
  return S_OK
proc get_TargetCompatibleBrowserVersion*(self; value: ptr LPWSTR ): HRESULT {.stdcall.} =
  value[] = self.lpVtbl.TargetCompatibleBrowserVersion
  return S_OK
proc put_AdditionalBrowserArguments*(self;value:LPCWSTR ): HRESULT {.stdcall.} =
  self.lpVtbl.AdditionalBrowserArguments = value
  return S_OK
proc put_AllowSingleSignOnUsingOSPrimaryAccount*(self;allow: BOOL ): HRESULT {.stdcall.} =
  self.lpVtbl.AllowSingleSignOnUsingOSPrimaryAccount = allow
  return S_OK
proc put_Language*(self;value:LPCWSTR ): HRESULT {.stdcall.} =
  self.lpVtbl.Language = value
proc put_TargetCompatibleBrowserVersion*(self; value:LPCWSTR ): HRESULT {.stdcall.} =
  self.lpVtbl.TargetCompatibleBrowserVersion = value
  return S_OK
proc get_ExclusiveUserDataFolderAccess*(self;value:ptr BOOL): HRESULT {.stdcall.} =
  value[] = self.lpVtbl.ExclusiveUserDataFolderAccess
  return S_OK
proc put_ExclusiveUserDataFolderAccess*(self;value: BOOL): HRESULT {.stdcall.} =
  self.lpVtbl.ExclusiveUserDataFolderAccess = value
  return S_OK