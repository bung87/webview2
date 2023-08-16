# webview2

This is proof of concept windows webview2 wrapper in pure Nim, in order to develop this program windows sdk and webview2 runtime sdk are required. for deployment webview2 runtime library is shiped through windows updates on win10 and win11 already supported.

The souce code contains `loader.nim` which take over the `webview2loader.dll` function. so there's no need ship this dll.  

This project is no longer maintained, further updates are going to another project [crowngui](https://github.com/bung87/crowngui)
