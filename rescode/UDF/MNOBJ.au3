
#include-once
#include <GuiButton.au3>
#include <ScrollBarConstants.au3>
#include <GuiMenu.au3>
#include <Misc.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <WinAPIEx.au3>
#include <ComboConstants.au3>
#include <Date.au3>
#include <String.au3>
#include <TreeViewRCH.au3>
#include <Lang.au3>
#include <_GDIPlus_StripProgressbar.au3>
Opt('MustDeclareVars', 1)
TraySetIcon(@ScriptDir & '\jmpack.ico')
_GPJ()
Func _GPJ()
	Local $JMPPR = _WinAPI_OpenFileMapping('JMPACKPROC')
	If $JMPPR Then
		Local $RJMP = _WinAPI_MapViewOfFile($JMPPR)
		Local $stData = DllStructCreate('wchar [256]', $RJMP)
		Local $WJM = _WinAPI_EnumProcessWindows(Number(DllStructGetData($stData, 1)), False)
		If Not @error Then MsgBox(16, '', $JMPlangset[42], 0, HWnd($WJM[1][0]))
		Exit
	Else
		Local $CJMF = _WinAPI_CreateFileMapping(-1, 1024, 'JMPACKPROC')
		Local $RJMP = _WinAPI_MapViewOfFile($CJMF)
		Local $stData = DllStructCreate('wchar [256]', $RJMP)
		DllStructSetData($stData, 1, @AutoItPID)
	EndIf
EndFunc   ;==>_GPJ

Global $oSNW = ObjCreate('Scripting.Dictionary')
Sleep(500)
If $oSNW = 0 Then
	MsgBox(16, '', 'Object Scripting.Dictionary - error')
	Exit
EndIf
$oSNW.CompareMode = 1
Global $oMod = ObjCreate('Scripting.Dictionary')
Sleep(500)
If $oMod = 0 Then
	MsgBox(16, '', 'Object Scripting.Dictionary - error')
	Exit
EndIf
$oMod.CompareMode = 1

Global Enum $ltxt = 1000, $fch, $fcl, $pcw, $rsz, $tcl, $delc, _
		$sysico, $trans, $bbmp, $setbck, $ntp, $bckp, _
		$fbck, $fnxt, $fcls, $fcnl, $furl, $grpb, $inst, $desgproc, $dsl, $wlcnr, $glcnr, $gllft, $defl, _
		$itch, $only, $txtmod, $picmod, $nofunc, $clmods, $clresmods, $backup, $pathgame, $chpathgm, $setinst, $infstinst, $chgif, $clmrm, $cash, _
		$ctrlmw, $callp, $chpage, $coordset, $notcoord, $31, $ctrlprnt, $hidectrl, _
		$dtitem, $wdtitem, $ntitem, $ditem, $nitem, $witem, $dittv, $dtv, $onlyTV, _
		$iDummyS, $iDummyE, $iDummyD, $iEditItem, $nbackauset, $nausetmod, $svpt, $ldpt, $reload, $uncheckall, $typebar

Global $aINFCTRL[26], $aINFPG[11], $FormCompile, $LLoadInfprj
Global $aDesignPath[6][2]
For $i = 0 To 5
	$aDesignPath[$i][0] = $i
Next
;~ Состав ячеек $aDesignPath
;~ Общий курсор - arrow.cur(.ani)
;~ Курсор подсветки - force.cur(.ani)
;~ Фоновая музыка - bckau.mp3
;~ Флэш-картинка старта - flash.png
;~ Флэш-картинка удаления - unmod.png
;~ Иконка деинсталятора - uninst.ico

Global $aSetISS[11][2]
$aSetISS[0][0] = 'OutputBaseFilename'
$aSetISS[0][1] = '';имя выходного файла
$aSetISS[1][0] = 'OutputDir'
$aSetISS[1][1] = '';путь к папке проекта или выбор пользователя
$aSetISS[2][0] = 'SetupIconFile'
$aSetISS[2][1] = '';иконка файла(выбор)
$aSetISS[3][0] = 'VersionInfoCompany'
$aSetISS[3][1] = '';компания
$aSetISS[4][0] = 'VersionInfoCopyright'
$aSetISS[4][1] = '';авторские права
$aSetISS[5][0] = 'VersionInfoDescription'
$aSetISS[5][1] = '';комментарий
$aSetISS[6][0] = 'VersionInfoProductName'
$aSetISS[6][1] = '';имя модпака
$aSetISS[7][0] = 'VersionInfoProductTextVersion'
$aSetISS[7][1] = '';версия продукта в текстовом блоке
$aSetISS[8][0] = 'VersionInfoProductVersion'
$aSetISS[8][1] = '';версия продукта
$aSetISS[9][0] = 'VersionInfoTextVersion'
$aSetISS[9][1] = '';версия файла в текстовом блоке
$aSetISS[10][0] = 'VersionInfoVersion'
$aSetISS[10][1] = '';версия файла

Global $prjpath = ''
Global $tID, $flwpic, $pathwpic = @ScriptDir
Global $cx, $cy, $retxt, $szID, $chkrsz, $WCHT, $CHT, $flch, $flsysico, $flbmp, $flmpic, $fldefb, $mmcr
Global $flfont, $flcl, $flbck
Global $tmpsz, $tmpszc, $SLRH, $SLRW, $WOTP, $mntvs, $tmphtv, $objw, $objc, $CurGui = 0
Global $flsvpt, $flsize, $curtv, $tmpcopyc, $flsetbck, $cidch, $flcopyw, $flstyle, $loadpjt, $flsvas, $tmspr
Global $MenuC, $hMenuCR, $elfunc, $flinst, $flitch, $tmpcurtv, $flcomppt, $flpathgame, $flchpathgm, $flfurl
Global $wkdir = @ScriptDir & '\wkdir', $pidwr, $flwot, $flwows
Global $aAllmod[1][5], $copyall, $errorlist = @ScriptDir & '\errorlist.txt', $stoppr = 0
Global $reswin[1], $closeico, $minimico, $chgame = '', $flhide, $idpic, $idtxt, $hGG, $hGIF, $flgif, $flreload, $flchpage
Global $flmove, $flvert, $flhorz, $indv, $indh, $flcoord, $flsetparam = 1, $HVXY[0][3]
Global $exitwin, $miniwin, $setparam, $wot, $wows, $CopyW, $prbar, $dltp, $comppt, _
		$svas, $nwp, $crnpr, $pic, $ico, $bt, $rd, $chk, $str, $crgif, $itinst, $crdid
Local $MapFile = _WinAPI_CreateFileMapping(-1, 1024 * 10, 'DataExchangeFile')
If $MapFile = 0 Then Exit
Local $PosFile = _WinAPI_MapViewOfFile($MapFile)
If $PosFile = 0 Then Exit
Global $t_Data = DllStructCreate('int npage;wchar ctrl[1024];int mc;int cpage;hwnd hwndj;hwnd hwndc;int tip;wchar text[1024];wchar path[1024];int load;int new;wchar lang[1024]', $PosFile)
Global $hDLL = DllOpen('user32.dll')
Global $mvwin, $winw, $winh
Global $CLmodpr, $LBinfps, $FMmod, $flmmcr, $tmpPackName, $LBTitleInfo, $nFuncError
Global $startcrlb, $aModMove[0]
Global $AccelKeys[12][2] = [['{F1}', $svpt], ['{F2}', $ldpt], ['{F3}', $reload], ['^z', $ntp], ['^x', $bckp], ['!{F4}', ''], ['{F5}', $coordset], ['{F6}', $notcoord], ['+1', $31], ['{Enter}', $iDummyS], ['^{Enter}', $iDummyE], ['{DEL}', $iDummyD]]
Global $iPercData, $iPercId, $hHBmp_BG, $WPerc, $HPerc, $BgColorGui = 0x000000, $FgBGColor = 0x808080, $BGColor = 0x0000FF, $TextBGColor = 0xFFFFFF, $sFontProgress = 'Arial', $iVisPerc = 1
Global $fldesgproc, $GuiPercD, $SelectProgressbar = 'barS', $TpBar = 0
Global $picauback = 'picauback.png', $picaubackST = 'picaubackST.png', $picaumod = 'picaumod.png', $picaumodST = 'picaumodST.png'
$UnchkUp = 1
_SetLangFF()
_FixAccelHotKeyLayout()
Func _SetLangFF()
	Local $aGetLangFile, $sListLang = ''
	Local $sLang_def = StringStripWS(FileRead(@ScriptDir & '\language\Default.ini'), 3)
	If Not FileExists(@ScriptDir & '\language\' & $sLang_def & '.txt') Then $sLang_def = 'LangDef'
	$aGetLangFile = _FileListToArray(@ScriptDir & '\language', '*.txt', 1)
	If Not @error Then
		$sListLang = _ArrayToString($aGetLangFile, '|', 1)
		If @error Then
			$sListLang = ''
		Else
			$sListLang = StringReplace(StringReplace($sListLang, '.txt', ''), $sLang_def, '')
			$sListLang = StringReplace($sListLang, '||', '|', 1)
			If StringLeft($sListLang, 1) = '|' Then $sListLang = StringTrimLeft($sListLang, 1)
			If StringRight($sListLang, 1) = '|' Then $sListLang = StringTrimRight($sListLang, 1)
		EndIf
	EndIf
	Local $hLangForm = GUICreate('JMPACK 3.5.1', 315, 80, -1, -1)
	GUISetBkColor(0x808080)
	GUISetFont(9, 400, 0, 'Georgia', $hLangForm)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $hLangForm)
	Local $iLbLang = GUICtrlCreateLabel('Язык\language', 8, 8, 204, 25)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $iComboLang = GUICtrlCreateCombo('', 8, 40, 201, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
	If Not ($sLang_def = 'LangDef') Then
		GUICtrlSetData(-1, $sLang_def & '|' & $sListLang & '|LangDef', $sLang_def)
	Else
		GUICtrlSetData(-1, $sLang_def & '|' & $sListLang, $sLang_def)
	EndIf
	GUICtrlSendMsg(-1, $CB_SETMINVISIBLE, 6, 0)
	Local $iButtonLang = GUICtrlCreateButton('Далее', 232, 38, 75, 25)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x808080)
	GUISetState()
	Local $aRTranslat, $hFO, $sRComboLang
	While 1
		Switch GUIGetMsg()
			Case -3
				Exit
			Case $iButtonLang
				$sRComboLang = GUICtrlRead($iComboLang)
				If FileExists(@ScriptDir & '\language\' & $sRComboLang & '.txt') Then
					$aRTranslat = IniReadSection(@ScriptDir & '\language\' & $sRComboLang & '.txt', 'JMPACK')
					If @error Then
						$sRComboLang = 'LangDef'
					Else
						If UBound($JMPlangset) = $aRTranslat[0][0] Then
							For $i = 1 To $aRTranslat[0][0]
								$JMPlangset[$i - 1] = $aRTranslat[$i][1]
							Next
						Else
							$sRComboLang = 'LangDef'
						EndIf
					EndIf
				Else
					$sRComboLang = 'LangDef'
				EndIf
				If Not ($sRComboLang = 'LangDef') Then
					$hFO = FileOpen(@ScriptDir & '\language\Default.ini', 10)
					FileWrite($hFO, $sRComboLang)
					FileClose($hFO)
				EndIf
				GUIDelete($hLangForm)
				DllStructSetData($t_Data, 'lang', $sRComboLang)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_SetLangFF
;~ 		"VersionInfoOriginalFileName=JmpackISS" & @CRLF & _
Global $SetupISS = "CreateAppDir=no" & @CRLF & _
		"Compression=lzma2/ultra" & @CRLF & _
		"SolidCompression=yes" & @CRLF & _
		"DisableStartupPrompt=yes" & @CRLF & _
		"DisableWelcomePage=yes" & @CRLF & _
		"DisableProgramGroupPage=yes" & @CRLF & _
		"DisableDirPage=yes" & @CRLF & _
		"DisableReadyMemo=yes" & @CRLF & _
		"DisableReadyPage=yes" & @CRLF & _
		"DisableFinishedPage=yes" & @CRLF & _
		"Uninstallable=no" & @CRLF & _
		"AppName=''" & @CRLF & _
		"AppVersion=''" & @CRLF & _
		"PrivilegesRequired=poweruser" & @CRLF & _
		"[Code]" & @CRLF & _
		"var" & @CRLF & _
		"ResultCode: Integer;" & @CRLF & _
		"i: Integer;" & @CRLF & _
		"b: Integer;" & @CRLF & _
		"aStrings: TArrayOfString;" & @CRLF & _
		"function InitializeSetup: Boolean;" & @CRLF & _
		"begin" & @CRLF & _
		"if CheckForMutexes('jmpack_ltd') then  exit;" & @CRLF & _
		"if CheckForMutexes('jmpack_install_mod') then exit;" & @CRLF & _
		"CreateMutex('jmpack_install_mod');" & @CRLF

Global $WisardISS = "SaveStringToFile(ExpandConstant('{tmp}\path.txt'), ExpandConstant('{srcexe}'), True);" & @CRLF & _
		"if Exec(ExpandConstant('{tmp}\AutoIt3.exe" & '" fileprjt.a3x"' & "'), '', '', SW_SHOW, ewNoWait, ResultCode) then" & @CRLF & _
		"begin" & @CRLF & _
		"sleep(5000)" & @CRLF & _
		"i:= 1" & @CRLF & _
		"while i > 0 do begin" & @CRLF & _
		"sleep(100)" & @CRLF & _
		"if not CheckForMutexes('jmpack_ltd') then  exit;" & @CRLF & _
		"if CheckForMutexes('jmunpack7z') then" & @CRLF & _
		"begin" & @CRLF & _
		"LoadStringsFromFile(ExpandConstant('{tmp}\path.txt'), aStrings)" & @CRLF & _
		"for b:= 0 to GetArrayLength(aStrings) - 1 do ExtractTemporaryFile(aStrings[b]);" & @CRLF & _
		"CreateMutex('jmpack_end_unzip');" & @CRLF & _
		"while i > 0 do begin" & @CRLF & _
		"sleep(100)" & @CRLF & _
		"if not CheckForMutexes('jmpack_ltd') then exit;" & @CRLF & _
		"end" & @CRLF & _
		"end" & @CRLF & _
		"end" & @CRLF & _
		"end" & @CRLF & _
		"else begin" & @CRLF & _
		"MsgBox('Startup error', mbCriticalError, MB_OK);" & @CRLF & _
		"exit;" & @CRLF & _
		"end;" & @CRLF & _
		"end;" & @CRLF & _
		"[Languages]" & @CRLF & _
		'Name: "default"; MessagesFile: "compiler:Default.isl"' & @CRLF

Func _FixAccelHotKeyLayout()
	Static $iKbrdLayout, $aKbrdLayouts
	If Execute('@exitMethod') <> '' Then
		Local $iUnLoad = 1
		For $i = 1 To UBound($aKbrdLayouts) - 1
			If Hex($iKbrdLayout) = Hex('0x' & StringRight($aKbrdLayouts[$i], 4)) Then
				$iUnLoad = 0
				ExitLoop
			EndIf
		Next
		If $iUnLoad Then
			_WinAPI_UnloadKeyboardLayout($iKbrdLayout)
		EndIf
		Return
	EndIf
	$iKbrdLayout = 0x0409
	$aKbrdLayouts = _WinAPI_GetKeyboardLayoutList()
	_WinAPI_LoadKeyboardLayout($iKbrdLayout, $KLF_ACTIVATE)
	OnAutoItExitRegister('_FixAccelHotKeyLayout')
EndFunc   ;==>_FixAccelHotKeyLayout

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

Func _MenuCTRL($HW, $Crid = 0)
	If Not $objc.Exists($Crid) Then Return
	Local $getinfclass = $objc.Item($Crid)
	Local $hMenu = _GUICtrlMenu_CreatePopup(1)
	Switch String($getinfclass[0])
		Case 'checkbox'
			_GUICtrlMenu_InsertMenuItem($hMenu, 0, $JMPlangset[189], $ltxt)
			_GUICtrlMenu_InsertMenuItem($hMenu, 1, $JMPlangset[163], $fch)
			_GUICtrlMenu_InsertMenuItem($hMenu, 2, $JMPlangset[185], $fcl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 3, $JMPlangset[9], $tcl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 4, $JMPlangset[190], $trans)
			_GUICtrlMenu_InsertMenuItem($hMenu, 5, $JMPlangset[191], $rsz)
			_GUICtrlMenu_InsertMenuItem($hMenu, 6, $JMPlangset[192], $callp)
			If $oSNW.Exists('page' & $CurGui + 1) Then
				_GUICtrlMenu_SetItemEnabled($hMenu, 6)
			Else
				_GUICtrlMenu_SetItemDisabled($hMenu, 6)
			EndIf
			_GUICtrlMenu_InsertMenuItem($hMenu, 7, '', 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 8, $JMPlangset[8], $delc)
			_GUICtrlMenu_InsertMenuItem($hMenu, 9, '', 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 10, $JMPlangset[193], $clmods)
			_GUICtrlMenu_InsertMenuItem($hMenu, 11, $JMPlangset[194], $clresmods)
			_GUICtrlMenu_InsertMenuItem($hMenu, 12, $JMPlangset[195], $clmrm)
			_GUICtrlMenu_InsertMenuItem($hMenu, 13, $JMPlangset[196], $backup)
			_GUICtrlMenu_InsertMenuItem($hMenu, 14, $JMPlangset[148], $cash)
			_GUICtrlMenu_InsertMenuItem($hMenu, 15, $JMPlangset[151], $nbackauset)
			_GUICtrlMenu_InsertMenuItem($hMenu, 16, $JMPlangset[152], $nausetmod)
			_GUICtrlMenu_InsertMenuItem($hMenu, 17, $JMPlangset[197], $nofunc)
			Switch Number($getinfclass[25])
				Case 16
					_GUICtrlMenu_InsertMenuItem($hMenu, 17, $JMPlangset[198], $hidectrl)
			EndSwitch
		Case 'mod'
			_GUICtrlMenu_InsertMenuItem($hMenu, 0, $JMPlangset[189], $ltxt)
			_GUICtrlMenu_InsertMenuItem($hMenu, 1, $JMPlangset[163], $fch)
			_GUICtrlMenu_InsertMenuItem($hMenu, 2, $JMPlangset[185], $fcl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 3, $JMPlangset[9], $tcl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 4, $JMPlangset[190], $trans)
			_GUICtrlMenu_InsertMenuItem($hMenu, 5, $JMPlangset[191], $rsz)
			_GUICtrlMenu_InsertMenuItem($hMenu, 6, '', 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 7, $JMPlangset[199], $itch)
			_GUICtrlMenu_InsertMenuItem($hMenu, 8, $JMPlangset[156], $only)
			_GUICtrlMenu_InsertMenuItem($hMenu, 9, $JMPlangset[172], $inst)
			_GUICtrlMenu_InsertMenuItem($hMenu, 10, '', 0)
			Switch Number($getinfclass[25])
				Case 16
					_GUICtrlMenu_InsertMenuItem($hMenu, 11, $JMPlangset[198], $hidectrl)
			EndSwitch
			_GUICtrlMenu_InsertMenuItem($hMenu, 12, $JMPlangset[8], $delc)
			If $getinfclass[17] Then _GUICtrlMenu_CheckMenuItem($hMenu, $only, True, False)
		Case 'label'
			_GUICtrlMenu_InsertMenuItem($hMenu, 0, $JMPlangset[189], $ltxt)
			_GUICtrlMenu_InsertMenuItem($hMenu, 1, $JMPlangset[163], $fch)
			_GUICtrlMenu_InsertMenuItem($hMenu, 2, $JMPlangset[185], $fcl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 3, $JMPlangset[9], $tcl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 4, $JMPlangset[190], $trans)
			_GUICtrlMenu_InsertMenuItem($hMenu, 5, $JMPlangset[191], $rsz)
			_GUICtrlMenu_InsertMenuItem($hMenu, 6, '', 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 7, $JMPlangset[200], $wlcnr)
			_GUICtrlMenu_InsertMenuItem($hMenu, 8, $JMPlangset[201], $glcnr)
			_GUICtrlMenu_InsertMenuItem($hMenu, 9, $JMPlangset[202], $gllft)
			_GUICtrlMenu_InsertMenuItem($hMenu, 10, $JMPlangset[203], $defl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 11, '', 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 12, $JMPlangset[204], $fnxt)
			_GUICtrlMenu_InsertMenuItem($hMenu, 13, $JMPlangset[205], $fbck)
			_GUICtrlMenu_InsertMenuItem($hMenu, 14, $JMPlangset[144], $chpage)
			_GUICtrlMenu_InsertMenuItem($hMenu, 15, $JMPlangset[132], $fcnl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 16, $JMPlangset[133], $fcls)
			_GUICtrlMenu_InsertMenuItem($hMenu, 17, $JMPlangset[206], $furl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 18, $JMPlangset[137], $txtmod)
			_GUICtrlMenu_InsertMenuItem($hMenu, 19, $JMPlangset[207], $pathgame)
			_GUICtrlMenu_InsertMenuItem($hMenu, 20, $JMPlangset[208], $chpathgm)
			_GUICtrlMenu_InsertMenuItem($hMenu, 21, $JMPlangset[209], $ctrlprnt)
			_GUICtrlMenu_InsertMenuItem($hMenu, 22, $JMPlangset[147], $infstinst)
			_GUICtrlMenu_InsertMenuItem($hMenu, 23, $JMPlangset[210], $setinst)
			_GUICtrlMenu_InsertMenuItem($hMenu, 24, $JMPlangset[150], $ctrlmw)
			_GUICtrlMenu_InsertMenuItem($hMenu, 25, $JMPlangset[197], $nofunc)
			_GUICtrlMenu_InsertMenuItem($hMenu, 26, '', 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 27, $JMPlangset[192], $callp)
			If $oSNW.Exists('page' & $CurGui + 1) Then
				_GUICtrlMenu_SetItemEnabled($hMenu, 27)
			Else
				_GUICtrlMenu_SetItemDisabled($hMenu, 27)
			EndIf
			_GUICtrlMenu_InsertMenuItem($hMenu, 28, $JMPlangset[8], $delc)
		Case 'pic'
			_GUICtrlMenu_InsertMenuItem($hMenu, 0, $JMPlangset[211], $pcw)
			_GUICtrlMenu_InsertMenuItem($hMenu, 1, $JMPlangset[212], $setbck)
			_GUICtrlMenu_InsertMenuItem($hMenu, 2, $JMPlangset[191], $rsz)
			_GUICtrlMenu_InsertMenuItem($hMenu, 3, '', 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 4, $JMPlangset[204], $fnxt)
			_GUICtrlMenu_InsertMenuItem($hMenu, 5, $JMPlangset[205], $fbck)
			_GUICtrlMenu_InsertMenuItem($hMenu, 6, $JMPlangset[144], $chpage)
			_GUICtrlMenu_InsertMenuItem($hMenu, 7, $JMPlangset[132], $fcnl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 8, $JMPlangset[133], $fcls)
			_GUICtrlMenu_InsertMenuItem($hMenu, 9, $JMPlangset[206], $furl)
			_GUICtrlMenu_InsertMenuItem($hMenu, 10, $JMPlangset[136], $picmod)
			_GUICtrlMenu_InsertMenuItem($hMenu, 11, $JMPlangset[208], $chpathgm)
			_GUICtrlMenu_InsertMenuItem($hMenu, 12, $JMPlangset[210], $setinst)
			_GUICtrlMenu_InsertMenuItem($hMenu, 13, $JMPlangset[149], $ctrlprnt)
			_GUICtrlMenu_InsertMenuItem($hMenu, 14, $JMPlangset[150], $ctrlmw)
			_GUICtrlMenu_InsertMenuItem($hMenu, 15, $JMPlangset[151], $nbackauset)
			_GUICtrlMenu_InsertMenuItem($hMenu, 16, $JMPlangset[152], $nausetmod)
			_GUICtrlMenu_InsertMenuItem($hMenu, 17, $JMPlangset[197], $nofunc)
			_GUICtrlMenu_InsertMenuItem($hMenu, 18, '', 0)
			Switch Number($getinfclass[9])
				Case 128
					_GUICtrlMenu_InsertMenuItem($hMenu, 19, $JMPlangset[213], $dsl)
					For $i = 3 To 17
						_GUICtrlMenu_SetItemDisabled($hMenu, $i)
					Next
				Case 64
					_GUICtrlMenu_InsertMenuItem($hMenu, 19, $JMPlangset[214], $dsl)
;~ 					_GUICtrlMenu_SetItemEnabled($hMenu, 13)
			EndSwitch
			_GUICtrlMenu_InsertMenuItem($hMenu, 20, $JMPlangset[192], $callp)
			If $oSNW.Exists('page' & $CurGui + 1) Then
				_GUICtrlMenu_SetItemEnabled($hMenu, 20)
			Else
				_GUICtrlMenu_SetItemDisabled($hMenu, 20)
			EndIf
			_GUICtrlMenu_InsertMenuItem($hMenu, 21, $JMPlangset[8], $delc)
		Case 'progress'
			_GUICtrlMenu_InsertMenuItem($hMenu, 0, $JMPlangset[215], $desgproc)
			Switch $getinfclass[24]
				Case 'barS'
					_GUICtrlMenu_SetItemDisabled($hMenu, 0)
			EndSwitch
			_GUICtrlMenu_InsertMenuItem($hMenu, 1, $JMPlangset[191], $rsz)
			_GUICtrlMenu_InsertMenuItem($hMenu, 2, $JMPlangset[235], $typebar)
			_GUICtrlMenu_InsertMenuItem($hMenu, 3, $JMPlangset[8], $delc)
	EndSwitch
	If $Crid > 0 Then
		If Not ($getinfclass[14] == 0) Then
			Switch String($getinfclass[14])
				Case 'next'
					_GUICtrlMenu_CheckMenuItem($hMenu, $fnxt, True, False)
				Case 'back'
					_GUICtrlMenu_CheckMenuItem($hMenu, $fbck, True, False)
				Case 'stop'
					_GUICtrlMenu_CheckMenuItem($hMenu, $fcnl, True, False)
				Case 'close'
					_GUICtrlMenu_CheckMenuItem($hMenu, $fcls, True, False)
				Case 'url'
					_GUICtrlMenu_CheckMenuItem($hMenu, $furl, True, False)
				Case 'pic'
					_GUICtrlMenu_CheckMenuItem($hMenu, $picmod, True, False)
				Case 'txt'
					_GUICtrlMenu_CheckMenuItem($hMenu, $txtmod, True, False)
				Case 'clmods'
					_GUICtrlMenu_CheckMenuItem($hMenu, $clmods, True, False)
				Case 'clresmods'
					_GUICtrlMenu_CheckMenuItem($hMenu, $clresmods, True, False)
				Case 'clmrm'
					_GUICtrlMenu_CheckMenuItem($hMenu, $clmrm, True, False)
				Case 'backup'
					_GUICtrlMenu_CheckMenuItem($hMenu, $backup, True, False)
				Case 'path'
					_GUICtrlMenu_CheckMenuItem($hMenu, $pathgame, True, False)
				Case 'chpath'
					_GUICtrlMenu_CheckMenuItem($hMenu, $chpathgm, True, False)
				Case 'inst'
					_GUICtrlMenu_CheckMenuItem($hMenu, $setinst, True, False)
				Case 'info'
					_GUICtrlMenu_CheckMenuItem($hMenu, $infstinst, True, False)
				Case 'cash'
					_GUICtrlMenu_CheckMenuItem($hMenu, $cash, True, False)
				Case 'ctrlprnt'
					_GUICtrlMenu_CheckMenuItem($hMenu, $ctrlprnt, True, False)
					_GUICtrlMenu_SetItemDisabled($hMenu, $dsl, True, False)
				Case 'mini'
					_GUICtrlMenu_CheckMenuItem($hMenu, $ctrlmw, True, False)
				Case 'chpage'
					_GUICtrlMenu_CheckMenuItem($hMenu, $chpage, True, False)
				Case 'backauset'
					_GUICtrlMenu_CheckMenuItem($hMenu, $nbackauset, True, False)
				Case 'ausetmod'
					_GUICtrlMenu_CheckMenuItem($hMenu, $nausetmod, True, False)
			EndSwitch
		EndIf
	EndIf
	_GUICtrlMenu_TrackPopupMenu($hMenu, $HW)
	_GUICtrlMenu_DestroyMenu($hMenu)
EndFunc   ;==>_MenuCTRL

Func _MenuItem($HW)
	Local $hMenu = _GUICtrlMenu_CreatePopup(1)
	_GUICtrlMenu_InsertMenuItem($hMenu, 0, $JMPlangset[216], $dtitem)
	_GUICtrlMenu_InsertMenuItem($hMenu, 1, $JMPlangset[217], $wdtitem)
	_GUICtrlMenu_InsertMenuItem($hMenu, 2, $JMPlangset[218], $ntitem)
	_GUICtrlMenu_InsertMenuItem($hMenu, 3, $JMPlangset[219], $onlyTV)
	_GUICtrlMenu_InsertMenuItem($hMenu, 4, $JMPlangset[220], $ditem)
	_GUICtrlMenu_InsertMenuItem($hMenu, 5, '', 0)
	_GUICtrlMenu_InsertMenuItem($hMenu, 6, $JMPlangset[172], $inst)
	_GUICtrlMenu_InsertMenuItem($hMenu, 7, $JMPlangset[221], $iDummyE)
	_GUICtrlMenu_TrackPopupMenu($hMenu, $HW)
	_GUICtrlMenu_DestroyMenu($hMenu)
EndFunc   ;==>_MenuItem

Func _MenuTV($HW)
	Local $hMenu = _GUICtrlMenu_CreatePopup(1)
	_GUICtrlMenu_InsertMenuItem($hMenu, 0, $JMPlangset[222], $nitem)
	_GUICtrlMenu_InsertMenuItem($hMenu, 1, $JMPlangset[223], $witem)
	_GUICtrlMenu_InsertMenuItem($hMenu, 2, $JMPlangset[224], $fch)
	_GUICtrlMenu_InsertMenuItem($hMenu, 3, $JMPlangset[225], $fcl)
	_GUICtrlMenu_InsertMenuItem($hMenu, 4, $JMPlangset[191], $rsz)
	_GUICtrlMenu_InsertMenuItem($hMenu, 5, $JMPlangset[226], $uncheckall)
	_GUICtrlMenu_InsertMenuItem($hMenu, 6, '', 0)
	_GUICtrlMenu_InsertMenuItem($hMenu, 7, $JMPlangset[227], $dittv)
	_GUICtrlMenu_InsertMenuItem($hMenu, 8, $JMPlangset[228], $dtv)
	_GUICtrlMenu_TrackPopupMenu($hMenu, $HW)
	_GUICtrlMenu_DestroyMenu($hMenu)
EndFunc   ;==>_MenuTV

Func _font($HW, $CTRL = 0, $sNmFont = 'Georgia')
	Local $getfont, $kyid
	If $CTRL Then
		If Not $objc.Exists($CTRL) Then Return SetError(-1)
		$kyid = $objc.Item($CTRL)
		$getfont = StringSplit($kyid[8], '!', 2)
	Else
		Dim $getfont[4]
		$getfont[0] = 10
		$getfont[1] = 0
		$getfont[3] = $sNmFont
	EndIf ;==>_font
	Local $Cfont = _ChooseFont($getfont[3], $getfont[0], 0, $getfont[1], False, False, False, $HW)
	If Not @error Then
		Select
			Case $CTRL > 0
				GUICtrlSetFont($CTRL, $Cfont[3], $Cfont[4], $Cfont[1], $Cfont[2])
				Local $setdata
				$setdata = $objc.Item($CTRL)
				$setdata[8] = $Cfont[3] & '!' & $Cfont[4] & '!' & $Cfont[1] & '!' & $Cfont[2]
				$objc.Item($CTRL) = $setdata
			Case $CTRL = 0
				Return $Cfont
		EndSelect
	Else
		Return SetError(@error)
	EndIf
EndFunc   ;==>_font

Func _colortext($HW, $CTRL = 0)
	If Not $objc.Exists($CTRL) Then Return
	Local $ccText = _ChooseColor(2, 0, 2, $HW)
	If $ccText <> -1 And Number($ccText) <> 50 Then
		GUICtrlSetColor($CTRL, $ccText)
		Local $setdata
		$setdata = $objc.Item($CTRL)
		$setdata[10] = Number($ccText)
		$objc.Item($CTRL) = $setdata
	EndIf
EndFunc   ;==>_colortext

Func _clback($HW, $CTRL = -1, $nCurColor = 0)
	Local $setdata
	Local $ccText = _ChooseColor(2, Number($nCurColor), 2, $HW)
	If $ccText <> -1 And Number($ccText) <> 50 Then
		Select
			Case $CTRL > 0
				If Not $objc.Exists($CTRL) Then Return SetError(1)
				GUICtrlSetBkColor($CTRL, $ccText)
				$setdata = $objc.Item($CTRL)
				$setdata[11] = Number($ccText)
				$objc.Item($CTRL) = $setdata
			Case $CTRL = 0
				GUISetBkColor($ccText, $HW)
				$setdata = $objw.Item($CTRL)
				$setdata[4] = Number($ccText)
				$objw.Item($CTRL) = $setdata
			Case Else
				Return $ccText
		EndSelect
	Else
		Return SetError(1)
	EndIf
EndFunc   ;==>_clback
