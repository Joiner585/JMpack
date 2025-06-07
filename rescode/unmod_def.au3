#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=unmod.a3x
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>
#include <UDF\Lang.au3>
#include <winapiex.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
Opt('TrayMenuMode', 1)
Opt('MustDeclareVars', 1)
Opt('GUICloseOnESC', 0)
TraySetIcon(@ScriptDir & '\uninst.ico')
Global $sfp = FileGetShortName(@ScriptFullPath)
Global $gtfp = StringReplace($sfp, '\' & @ScriptName, '')
Global $pthg, $modname, $hGG, $hgif, $getinilang
If FileExists(@ScriptDir & '\lang.txt') Then
	$getinilang = IniReadSection(@ScriptDir & '\lang.txt', 'INSTALL')
	If Not @error Then
		If UBound($Instjmplang) = $getinilang[0][0] Then
			For $i = 1 To $getinilang[0][0]
				$Instjmplang[$i - 1] = $getinilang[$i][1]
			Next
		EndIf
	EndIf
EndIf
If Not FileExists(@ScriptDir & '\unmod.ini') Or Not FileExists(@ScriptDir & '\Dfile.ini') Then
	MsgBox(16, '1', $Instjmplang[18] & ' unmod.ini')
	Exit
Else
	$pthg = IniReadSection(@ScriptDir & '\unmod.ini', 'pathgm')
	If @error Then
		MsgBox(16, '2', $Instjmplang[18] & ' unmod.ini')
		Exit
	EndIf
	$modname = $pthg[2][1]
	If FileExists($pthg[1][1]) Then
		_WinExFF()
		If MsgBox(36, $Instjmplang[31], $Instjmplang[32] & ' ' & $modname & ' ?') = 7 Then Exit
		FileDelete(@DesktopDir & '\' & $modname & '.lnk')
		Local $getfl
		$getfl = FileReadToArray(@ScriptDir & '\Dfile.ini')
		If Not @error Then
			For $i = 0 To UBound($getfl) - 1
				FileSetAttrib($getfl[$i], '-RS')
				FileDelete($getfl[$i])
			Next
		EndIf
		$getfl = FileReadToArray(@ScriptDir & '\Bfile.ini')
		If Not @error Then
			For $i = 0 To UBound($getfl) - 1
				FileSetAttrib($getfl[$i], '-RS')
				FileMove($getfl[$i], StringTrimRight($getfl[$i], 4), 1)
			Next
		EndIf
		Run('cmd.exe /C rmdir /S /Q "' & @ScriptDir & '"', '', @SW_HIDE)
	EndIf
EndIf

Func _WinExFF()
	_GDIPlus_Startup()
	Local $hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & '\unmod.png')
	If @error Then Return SetError(1)
	Local $XW = _GDIPlus_ImageGetWidth($hImage)
	Local $YH = _GDIPlus_ImageGetHeight($hImage)
	Local $hGui = GUICreate('', $XW, $YH, -1, -1, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_LAYERED, $WS_EX_TOPMOST))
	GUISetState()
	Local $hScrDC = _WinAPI_GetDC($hGui)
	Local $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	Local $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	Local $tSize = DllStructCreate($tagSIZE)
	Local $pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, 'X', $XW)
	DllStructSetData($tSize, 'Y', $YH)
	Local $tSource = DllStructCreate($tagPOINT)
	Local $pSource = DllStructGetPtr($tSource)
	Local $tBlend = DllStructCreate($tagBLENDFUNCTION)
	Local $pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, 'Format', 1)
	For $i = 0 To 255 Step 5
		DllStructSetData($tBlend, 'Alpha', $i)
		_WinAPI_UpdateLayeredWindow($hGui, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
		Sleep(10)
	Next
	Sleep(3000)
	For $i = 255 To 0 Step -5
		DllStructSetData($tBlend, 'Alpha', $i)
		_WinAPI_UpdateLayeredWindow($hGui, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
		Sleep(10)
	Next
	GUIDelete($hGui)
	_GDIPlus_ImageDispose($hImage)
	_WinAPI_ReleaseDC($hGui, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
	_GDIPlus_Shutdown()
EndFunc   ;==>_WinExFF

