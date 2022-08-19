import std/[locks, tables]
import winim
import webview

type WebviewContextStore = object
  mu: Lock
  store: Table[HWND, WebView]

var webviewContext*: WebviewContextStore
webviewContext.mu.initLock()

proc set*(wcs: WebviewContext; hwnd: HWND;wv: WebView) = 
  wcs.mu.acquire
  defer wcs.mu.release
  wcs.store[hwnd] = wv

proc get*(hwnd: HWND;):WebView =
  wcs.mu.acquire
  defer wcs.mu.release
  return wcs.store[hwnd]