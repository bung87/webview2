import winim 

type WindowConfig* = object
  title: string
  width, height: int32
  maxWidth, maxHeight: int32
  minWidth, minHeight: int32

type Window* = object
  config: ptr WindowConfig
  handle: HWND
