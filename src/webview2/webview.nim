import window, browser
import std/[os]
import types,com
import winim


proc newWebView*():WebView =
  result = new WebView
  var windowConfig = WindowConfig(width:640,height:480,title:"Webview")
  var window = Window(config:windowConfig)
  var browserConfig = BrowserConfig(
    initialURL:           "about:blank",
    builtInErrorPage:     true,
    defaultContextMenus:  true,
    defaultScriptDialogs: true,
    devtools:             true,
    hostObjects:          true,
    script:               true,
    statusBar:            true,
    webMessage:           true,
    zoomControl:          true,
  )
  var browser = Browser(
    config: browserConfig
    )
  result.window = window
  result.browser = browser
  try:
    if CoInitializeEx(nil, COINIT_APARTMENTTHREADED).FAILED: raise
    defer: CoUninitialize()
  except:
    discard

  # result.dll = CreateCoreWebView2EnvironmentWithOptions

proc initializeWindow*(wv: WebView) =
  # wv.window.SetTitle(wv.window.config.title)
  # wv.window.SetSize(wv.window.config.width, wv.window.config.height)
  # wv.window.Center()
  # wv.window.Show()
  # wv.window.Focus()
  wv.browser.embed(wv)
  # wv.browser.resize()
  # wv.browser.saveSettings()

proc init*(wv: WebView) =
  # for s in ["WEBVIEW2_BROWSER_EXECUTABLE_FOLDER", "WEBVIEW2_USER_DATA_FOLDER", "WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS", "WEBVIEW2_RELEASE_CHANNEL_PREFERENCE"]:
  #   delEnv(s)
  # wv.createWindow()
  wv.initializeWindow()
  wv.browser.navigate(wv.browser.config.initialURL)

