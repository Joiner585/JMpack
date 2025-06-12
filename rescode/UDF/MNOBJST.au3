
#include-once
#include <Array.au3>
#include <Icons.au3>
#include <FFSearch.au3>
#include <Bass.au3>
#include <TreeViewRCH.au3>
#include <File.au3>
#include <Lang.au3>
#include <_GDIPlus_StripProgressbar.au3>
Opt("MustDeclareVars", 1)

_CheckDouble()
Func _CheckDouble()
	If Not _WinAPI_CreateMutex('jmpack_ltd') Then Exit
EndFunc   ;==>_CheckDouble

Global $oSNW = ObjCreate('Scripting.Dictionary')
Sleep(500)
If $oSNW = 0 Then
	MsgBox(16, '', 'Object Scripting.Dictionary.oSNW - error')
	Exit
EndIf
$oSNW.CompareMode = 1
Global $oMod = ObjCreate('Scripting.Dictionary')
Sleep(500)
If $oMod = 0 Then
	MsgBox(16, '', 'Object Scripting.Dictionary.oMod - error')
	Exit
EndIf
$oMod.CompareMode = 1
Global $stoppr, $sNameMod[0], $flhide, $UpIdC = 0
Global $WOTP, $Title, $Mini, $Close, $tmphtv, $objw, $objc, $CurGui = 0, $volume = 100
Global $wkdir = @ScriptDir, $pidwr, $curani = $wkdir & '\arrow.ani', $curc = $wkdir & '\arrow.cur', $force_a = $wkdir & '\force.ani', $force_c = $wkdir & '\force.cur'
Global $curtv, $tmpcurtv, $flpathgame, $flchpathgm
Global $flfunc = '', $flclmods, $flclresmods, $flbackup = 0, $infstinst, $flclmrm = 0, $flclcash = 0
Global $ALLTTF[0], $aALLAU, $aModsC, $flhide, $idpic, $idtxt = 0, $backlight = 0, $curidpos = 0
Global $nExistsTV = -1, $imgbackw = $wkdir & '\bck0.png', $aLoadTV[0][2], $nflagsetimgtv = 0
Global $setpathgame = '', $flagpath = 0, $playbck = $wkdir & '\bckau.mp3', $flinstset = 0, $clip = '', $setunmod = 0, $exmods[0], $endex = 0, $tmprcld = 0, $prcall = 0
Global $itmpFileName = '', $sNameG = '', $g_hCursor = 0, $g_hCursorLight = 0, $setcur = 0, $actcur = 0, $VerGameInst = ''
Global $FlashGui, $tmpiWRSZF, $iTMPProc, $iPrwrf, $tmpDest, $aWrex, $sBackupFiles
Global $nbackauset = 4, $nausetmod = 4, $MusicHandleBck, $MusicHandleMod, $Song_Length
Global $7zaPath = $wkdir & '\7za.exe'
Global $aIco[4] = [$wkdir & '\chk.ico', $wkdir & '\unchk.ico', $wkdir & '\rd.ico', $wkdir & '\unrd.ico']
Global $backlightcolor, $flpgtv, $flpg
Global $iPercData, $iPercId, $hHBmp_BG, $WPerc, $HPerc, $BgColorGui, $FgBGColor, $BGColor, $TextBGColor, $sFontProgress, $iVisPerc
Global $PathSFX = StringStripWS(FileRead($wkdir & '\path.txt'), 3)
Global $GetPathExe = '', $sListModsF = ''
TraySetIcon($PathSFX)
$nFlagSelect = 1
$UnchkUp = 1

_HideWinISS($PathSFX)
_Getinilang()

Func _HideWinISS($sProcISS)
	Local $getslashIss = StringTrimLeft($sProcISS, StringInStr($sProcISS, '\', 0, -1))
	Local $NameProcISS = StringReplace($getslashIss, '.exe', '.tmp')
	Local Const $sCLSID_TaskbarList = "{56FDF344-FD6D-11D0-958A-006097C9A090}"
	Local Const $sIID_ITaskbarList = "{56FDF342-FD6D-11D0-958A-006097C9A090}"
	Local Const $sTagITaskbarList = "HrInit hresult(); AddTab hresult(hwnd); DeleteTab hresult(hwnd); ActivateTab hresult(hwnd); SetActiveAlt hresult(hwnd);"
	Local $oTaskbarList = ObjCreateInterface($sCLSID_TaskbarList, $sIID_ITaskbarList, $sTagITaskbarList)
	$oTaskbarList.HrInit()
	Local $prl = ProcessList($NameProcISS)
	Local $getwin = _WinAPI_EnumProcessWindows($prl[1][1])
	If Not @error Then
		For $i = 1 To $getwin[0][0]
			$oTaskbarList.DeleteTab($getwin[$i][0])
		Next
	EndIf
EndFunc   ;==>_HideWinISS

Func _Getinilang()
	Local $getinilang
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
EndFunc   ;==>_Getinilang

Func _PageCreate(ByRef $obj, $key)
	Local $one = ObjCreate('Scripting.Dictionary')
	Local $k
	Do
		If $k = 50 Then Return SetError(1)
		$k += 1
		Sleep(10)
	Until VarGetType($one) = 'Object'
	$one.CompareMode = 1
	Local $two = ObjCreate('Scripting.Dictionary')
	$k = 0
	Do
		If $k = 50 Then Return SetError(1)
		$k += 1
		Sleep(10)
	Until VarGetType($two) = 'Object'
	$two.CompareMode = 1
	Local $aObj[2] = [$one, $two]
	$obj.Add($key, $aObj)
EndFunc   ;==>_PageCreate

Func _ANSIToOEM($strText)
	Local $sBUFFER = DllStructCreate("char[" & StringLen($strText) + 1 & "]")
	Local $aRet = DllCall("User32.dll", "int", "CharToOem", "str", $strText, "ptr", DllStructGetPtr($sBUFFER))
	If Not IsArray($aRet) Then Return SetError(1, 0, '')
	If $aRet[0] = 0 Then Return SetError(2, $aRet[0], '')
	Return DllStructGetData($sBUFFER, 1)
EndFunc   ;==>_ANSIToOEM

Func _OEM2ANSI($strText)
	Local $sBUFFER = DllStructCreate("char[" & StringLen($strText) + 1 & "]")
	Local $aRet = DllCall("User32.dll", "int", "OemToChar", "str", $strText, "ptr", DllStructGetPtr($sBUFFER))
	If Not IsArray($aRet) Then Return SetError(1, 0, '') ; DLL error
	If $aRet[0] = 0 Then Return SetError(2, $aRet[0], '') ; Function error
	Return DllStructGetData($sBUFFER, 1)
EndFunc   ;==>_OEM2ANSI

Func _CGW($NameExe, $GameVer)
	Local $all_key[3]
	$all_key[0] = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	$all_key[1] = "HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	$all_key[2] = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall'
	Local $AppKey_all = '', $gtprname = '', $PathNameExe = '', $n_Count_Step
	For $i = 0 To 2
		$n_Count_Step = 1
		While 1
			$AppKey_all = RegEnumKey($all_key[$i], $n_Count_Step)
			If @error Then ExitLoop
			$PathNameExe = StringReplace(StringStripWS(RegRead($all_key[$i] & "\" & $AppKey_all, "InstallLocation"), 3), '"', '')
			If $PathNameExe <> '' Then
				If StringRight($PathNameExe, 1) = '\' Then $PathNameExe = StringTrimRight($PathNameExe, 1)
				If FileExists($PathNameExe & '\win64\' & $NameExe) Then
					$gtprname = FileGetVersion($PathNameExe & '\win64\' & $NameExe, 'FileVersion')
					Switch $NameExe
						Case 'WorldOfTanks.exe' ;WarGaming.net
							If StringInStr($gtprname, $GameVer) Then
								$PathNameExe = StringStripWS($PathNameExe, 3)
								If FileExists($PathNameExe) Then Return $PathNameExe
							EndIf
						Case 'Tanki.exe' ;Lesta
							If StringInStr($gtprname, $GameVer) Then
								$PathNameExe = StringStripWS($PathNameExe, 3)
								If FileExists($PathNameExe) Then Return $PathNameExe
							EndIf
					EndSwitch
				EndIf
			EndIf
			$n_Count_Step += 1
		WEnd
	Next
	Local $PathWG[3]
	$PathWG[0] = 'HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\Shell\MuiCache'
	$PathWG[1] = 'HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache'
	$PathWG[2] = 'HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers'
	For $i = 0 To 2
		$n_Count_Step = 1
		While 1
			$AppKey_all = RegEnumVal($PathWG[$i], $n_Count_Step)
			If @error Then ExitLoop
			If StringStripWS($AppKey_all, 3) <> '' Then
				If StringInStr($AppKey_all, $NameExe) Then
					$PathNameExe = StringLeft($AppKey_all, StringInStr($AppKey_all, '\', 0, -1) - 1)
					If FileExists($PathNameExe & '\' & $NameExe) Then
						$gtprname = FileGetVersion($PathNameExe & '\' & $NameExe, 'FileVersion')
						Switch $NameExe
							Case 'WorldOfTanks.exe' ;WarGaming.net
								$PathNameExe = StringReplace($PathNameExe & '\win64\' & $NameExe, '\win64\WorldOfTanks.exe', '')
								If StringInStr($gtprname, $GameVer) Then
									$PathNameExe = StringStripWS($PathNameExe, 3)
									If FileExists($PathNameExe) Then Return $PathNameExe
								EndIf
							Case 'Tanki.exe' ;Lesta
								$PathNameExe = StringReplace($PathNameExe & '\win64\' & $NameExe, '\win64\Tanki.exe', '')
								ConsoleWrite($PathNameExe & @LF)
								If StringInStr($gtprname, $GameVer) Then
									$PathNameExe = StringStripWS($PathNameExe, 3)
									If FileExists($PathNameExe) Then Return $PathNameExe
								EndIf
						EndSwitch
					EndIf
				EndIf
			EndIf
			$n_Count_Step += 1
		WEnd
	Next
	Return ''
EndFunc   ;==>_CGW
