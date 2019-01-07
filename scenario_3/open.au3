#include <Constants.au3>
#include <WinAPI.au3>
#include <File.au3>

WinWaitActive( "[REGEXPTITLE:Open]","",20)
Local $hWnd =  WinGetHandle( "[REGEXPTITLE:Open]","")
WinActivate($hWnd)
SendKeepActive($hWnd)
ControlFocus($hWnd, "", "[CLASS:Button; INSTANCE:1]")
Sleep(3000)
ControlSend("[REGEXPTITLE:Open]", "", "[CLASS:Edit; INSTANCE:1]",@ScriptDir &"\test.jpg")
ControlClick("[REGEXPTITLE:Open]","Open","[CLASS:Button; INSTANCE:1]")
sleep(2000)