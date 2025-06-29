#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=controlw.a3x
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #include <UDF\AutoItErrorHandler.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPIEx.au3>
#include <GuiTreeView.au3>
#include <EditConstants.au3>
#include <UDF\Lang.au3>
#include <Array.au3>
Opt("TrayIconHide", 1)
Opt('GUICloseOnESC', 0)
Opt('MustDeclareVars', 1)
Opt('TrayMenuMode', 1)
;~ ------------------------------------------
;~ Local $PosFile
;~ ------------------------------------------
Local $MapFile = _WinAPI_OpenFileMapping('DataExchangeFile')
If $MapFile = 0 Then Exit
Local $PosFile = _WinAPI_MapViewOfFile($MapFile)
If $PosFile = 0 Then Exit
Global $htmpItem, $nPage, $fDel, $flgame, $fltip
Global $t_Data = DllStructCreate('int npage;wchar ctrl[1024];int mc;int cpage;HWND hwndj;HWND hwndc;int tip;wchar text[1024];wchar path[1024];int load;int new;wchar lang[1024]', $PosFile)
Global $State, $newprjt
Local $sGetLangST = DllStructGetData($t_Data, 'lang'), $aRTranslat
If Not ($sGetLangST = 'LangDef') Then
	If FileExists(@ScriptDir & '\language\' & $sGetLangST & '.txt') Then
		$aRTranslat = IniReadSection(@ScriptDir & '\language\' & $sGetLangST & '.txt', 'JMPACK')
		If Not @error Then
			If UBound($JMPlangset) = $aRTranslat[0][0] Then
				For $i = 1 To $aRTranslat[0][0]
					$JMPlangset[$i - 1] = $aRTranslat[$i][1]
				Next
			EndIf
		EndIf
	EndIf
EndIf
Global $CurGui = 0, $CurHtv = 0
_FixAccelHotKeyLayout()
Global $FormCRPage = GUICreate('JMPACK 3.5.1', 270, 910, 10, 10)
GUISetIcon(@ScriptDir & '\jmpack.ico', '', $FormCRPage)
GUISetFont(9, 400, 0, 'Georgia')
GUISetBkColor(0x808080)
DllStructSetData($t_Data, 6, $FormCRPage)
Global $TreeViewPages = GUICtrlCreateTreeView(5, 5, 150, 250, BitOR($TVS_DISABLEDRAGDROP, $TVS_TRACKSELECT, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_HASBUTTONS, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetFont(-1, 10, 800, 0, 'MS Sans Serif')
GUICtrlSetColor(-1, 0xFFFFFF)
Global $hTreeViewPages = GUICtrlGetHandle($TreeViewPages)
_GUICtrlTreeView_Add($hTreeViewPages, 0, $JMPlangset[0] & ' - 0')

Local $svpt = GUICtrlCreateButton($JMPlangset[1], 166, 5, 100, 25) ;1
GUICtrlSetBkColor(-1, 0x808080)
Local $ldpt = GUICtrlCreateButton($JMPlangset[2], 166, 35, 100, 25) ;2
GUICtrlSetBkColor(-1, 0x808080)
Local $reload = GUICtrlCreateButton($JMPlangset[3], 166, 65, 100, 25) ;3
GUICtrlSetBkColor(-1, 0x808080)
Local $svas = GUICtrlCreateButton($JMPlangset[4], 166, 95, 100, 25) ;4
GUICtrlSetBkColor(-1, 0x808080)
Global $crnpr = GUICtrlCreateButton($JMPlangset[5], 166, 125, 100, 25) ;5
GUICtrlSetBkColor(-1, 0x808080)
GUICtrlCreateLabel($JMPlangset[0], 166, 185, 100, 18)
GUICtrlSetColor(-1, 0xFFA900)
Local $nwp = GUICtrlCreateButton($JMPlangset[6], 166, 208, 100, 25) ;7
GUICtrlSetBkColor(-1, 0x808080)
Local $CopyW = GUICtrlCreateButton($JMPlangset[7], 166, 238, 100, 25) ;8
GUICtrlSetBkColor(-1, 0x808080)
Local $dltp = GUICtrlCreateButton($JMPlangset[8], 166, 268, 100, 25) ;9
GUICtrlSetBkColor(-1, 0x808080)
Local $tcl = GUICtrlCreateButton($JMPlangset[9], 166, 298, 100, 25) ;10
GUICtrlSetBkColor(-1, 0x808080)
Local $tcl1 = GUICtrlCreateButton($JMPlangset[10], 166, 328, 100, 25) ;10 размер
GUICtrlSetBkColor(-1, 0x808080)
Local $CRctrl = GUICtrlCreateButton($JMPlangset[11], 166, 155, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)

GUIStartGroup()
Local $Label2 = GUICtrlCreateLabel($JMPlangset[12], 5, 260, 150, 18)
GUICtrlSetColor(-1, 0xFFA900)
Global $backlight0 = GUICtrlCreateRadio($JMPlangset[13], 5, 283, 150, 17) ;11
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, 1)
Global $backlight1 = GUICtrlCreateRadio($JMPlangset[14], 5, 305, 150, 17) ;12
GUICtrlSetColor(-1, 0x000000)
Global $backlight2 = GUICtrlCreateRadio($JMPlangset[15], 5, 327, 150, 17) ;13
GUICtrlSetColor(-1, 0x000000)
Global $backlight3 = GUICtrlCreateRadio($JMPlangset[16], 5, 349, 150, 17) ;13
GUICtrlSetColor(-1, 0x000000)

GUIStartGroup()
Local $Label3 = GUICtrlCreateLabel($JMPlangset[17], 5, 372, 150, 18)
GUICtrlSetColor(-1, 0xFFA900)
Global $wot = GUICtrlCreateRadio('Wargaming', 5, 394, 150, 17) ;14
GUICtrlSetColor(-1, 0x000000)
Global $wows = GUICtrlCreateRadio('Lesta', 5, 416, 150, 17) ;15
GUICtrlSetColor(-1, 0x000000)
Global $wowp = GUICtrlCreateRadio('World of Warplanes', 5, 438, 150, 17) ;15
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetColor(-1, 0x000000)
GUIStartGroup()
Local $setparam = GUICtrlCreateLabel($JMPlangset[18], 5, 460, 150, 17)
GUICtrlSetColor(-1, 0xFFA900)
Global $deinstY = GUICtrlCreateRadio($JMPlangset[19], 5, 482, 150, 17) ;16
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, 1)
Global $deinstN = GUICtrlCreateRadio($JMPlangset[20], 5, 507, 150, 17) ;17
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $comppt = GUICtrlCreateButton($JMPlangset[21], 5, 575, 100, 25) ;6 Собрать
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808080)
GUICtrlSetFont(-1, 9, 600, 0, 'Georgia')
Global $idInfStr = GUICtrlCreateLabel($JMPlangset[22] & @LF & $JMPlangset[23] & @LF & $JMPlangset[24], 0, 0, 270, 80)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetFont(-1, 10, 800, 0, 'Georgia')
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
Local $AccelKeys[4][2] = [['{F1}', $svpt], ['{F2}', $ldpt], ['{F3}', $reload], ['!{F4}', '']]
GUISetAccelerators($AccelKeys, $FormCRPage)

;~ элементы окна
Local $bt = GUICtrlCreateButton($JMPlangset[26], 166, 385, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
GUICtrlSetState(-1, $GUI_HIDE)
Local $chk = GUICtrlCreateButton($JMPlangset[27], 166, 383, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
Local $prbar = GUICtrlCreateButton($JMPlangset[28],166, 415, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
Local $str = GUICtrlCreateButton($JMPlangset[29], 166, 447, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
Local $pic = GUICtrlCreateButton($JMPlangset[30], 166, 479, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
Local $ico = GUICtrlCreateButton($JMPlangset[31], 5, 155, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
GUICtrlSetState(-1, $GUI_HIDE)
Local $crgif = GUICtrlCreateButton($JMPlangset[32], 5, 185, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
GUICtrlSetState(-1, $GUI_HIDE)
Local $itinst = GUICtrlCreateButton($JMPlangset[33], 166, 511, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
Local $tvmod = GUICtrlCreateButton($JMPlangset[34], 166, 543, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
Local $rd = GUICtrlCreateButton($JMPlangset[35], 166, 575, 100, 25)
GUICtrlSetBkColor(-1, 0x808080)
GUICtrlSetColor(-1, 0xFFA900)
Global $hEditInfo = GUICtrlCreateEdit('', 0, 610, 270, 300)
GUICtrlSetBkColor(-1, 0x088880)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 9, 400, 0, 'Georgia')
Local $CTRL = GUICtrlCreateLabel($JMPlangset[230], 166, 360, 100, 18)
GUICtrlSetColor(-1, 0xFFA900)
GUISetState(@SW_SHOW, $FormCRPage)
GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')
GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
GUIRegisterMsg($WM_SYSCOMMAND, 'WM_SYSCOMMAND')
_GUICtrlTreeView_SelectItem($hTreeViewPages, _GUICtrlTreeView_GetFirstItem($hTreeViewPages))
DllStructSetData($t_Data, 1, 0)
$CurHtv = _GUICtrlTreeView_GetFirstItem($hTreeViewPages)
Local $nMsg, $gtc, $sname, $tmptext, $iState, $WST
WinActivate(DllStructGetData($t_Data, 5))
While 1
	If Not WinExists(DllStructGetData($t_Data, 5)) Then Exit
	$tmptext = DllStructGetData($t_Data, 9) & @CRLF & DllStructGetData($t_Data, 8)
	If StringCompare($tmptext, GUICtrlRead($hEditInfo)) Then GUICtrlSetData($hEditInfo, $tmptext)
	If DllStructGetData($t_Data, 4) > 0 Then
		_GUICtrlTreeView_DeleteAll($hTreeViewPages)
		For $i = 0 To (DllStructGetData($t_Data, 4) - 1)
			_GUICtrlTreeView_Add($hTreeViewPages, 0, $JMPlangset[0] & ' - ' & $i)
		Next
		DllStructSetData($t_Data, 4, 0)
		_GUICtrlTreeView_SelectItem($hTreeViewPages, _GUICtrlTreeView_GetFirstItem($hTreeViewPages))
		DllStructSetData($t_Data, 1, 0)
		$CurHtv = _GUICtrlTreeView_GetFirstItem($hTreeViewPages)
	EndIf
	If $fDel Then
		$gtc = _GUICtrlTreeView_GetCount($hTreeViewPages)
		$sname = _GUICtrlTreeView_GetText($hTreeViewPages, $htmpItem)
		If $gtc > 1 And $sname <> $JMPlangset[0] & ' - 0' Then
			DllStructSetData($t_Data, 2, $JMPlangset[8])
			_GUICtrlTreeView_DeleteAll($hTreeViewPages)
			For $i = 1 To $gtc - 1
				_GUICtrlTreeView_Add($hTreeViewPages, 0, $JMPlangset[0] & ' - ' & ($i - 1))
			Next
			_GUICtrlTreeView_SelectItem($hTreeViewPages, _GUICtrlTreeView_GetFirstItem($hTreeViewPages))
			DllStructSetData($t_Data, 1, 0)
			$CurHtv = _GUICtrlTreeView_GetFirstItem($hTreeViewPages)
		EndIf
		$fDel = 0
	EndIf
	If DllStructGetData($t_Data, 'tip') Then
		If Not $fltip Then
			GUICtrlSetState($idInfStr, $GUI_SHOW)
			$fltip = 1
		EndIf
	Else
		If $fltip Then
			GUICtrlSetState($idInfStr, $GUI_HIDE)
			$fltip = 0
		EndIf
	EndIf
	$CurGui = DllStructGetData($t_Data, 1)
	If $CurGui > $nPage Then
		If _GUICtrlTreeView_GetNext($hTreeViewPages, $CurHtv) Then _GUICtrlTreeView_SelectItem($hTreeViewPages, _GUICtrlTreeView_GetNext($hTreeViewPages, $CurHtv))
	ElseIf $CurGui < $nPage Then
		If _GUICtrlTreeView_GetPrev($hTreeViewPages, $CurHtv) Then _GUICtrlTreeView_SelectItem($hTreeViewPages, _GUICtrlTreeView_GetPrev($hTreeViewPages, $CurHtv))
	EndIf
	$WST = DllStructGetData($t_Data, 10)
	Switch $WST
		Case 1
			GUISetState(@SW_HIDE, $FormCRPage)
		Case 2
			GUISetState(@SW_SHOW, $FormCRPage)
			DllStructSetData($t_Data, 10, 0)
			WinActivate($FormCRPage)
			WinActivate(DllStructGetData($t_Data, 5))
	EndSwitch
	If DllStructGetData($t_Data, 11) = 1 Then
		DllStructSetData($t_Data, 11, 0)
		_GUICtrlTreeView_DeleteAll($hTreeViewPages)
		_GUICtrlTreeView_Add($hTreeViewPages, 0, $JMPlangset[0] & ' - 0')
		DllStructSetData($t_Data, 4, 0)
		_GUICtrlTreeView_SelectItem($hTreeViewPages, _GUICtrlTreeView_GetFirstItem($hTreeViewPages))
		GUICtrlSetState($wot, 4)
		GUICtrlSetState($wows, 4)
		GUICtrlSetState($backlight0, 1)
		GUICtrlSetState($deinstY, 1)
		$CurHtv = _GUICtrlTreeView_GetFirstItem($hTreeViewPages)
	EndIf
	Sleep(10)
WEnd

Func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $lParam
	Switch _WinAPI_LoWord($wParam)
		Case 61472
			DllStructSetData($t_Data, 3, 1)
			GUISetState(@SW_MINIMIZE, $FormCRPage)
		Case 61728
			GUISetState(@SW_RESTORE, $FormCRPage)
			DllStructSetData($t_Data, 3, 3)
			WinActivate(DllStructGetData($t_Data, 5))
		Case 61536
			DllStructSetData($t_Data, 3, 2)
			Exit
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SYSCOMMAND

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $FSID = _WinAPI_LoWord($iwParam)
	Local $gtc, $sname
	ConsoleWrite($FSID & ', ')
	Switch $FSID
		Case 17, 18, 19, 20, 22, 23, 26, 28, 4, 5, 6, 7, 15, 13, 14, 31, 32, 33, 34, 37, 38, 39
			Local $Rctrl = GUICtrlRead($FSID, 1)
			DllStructSetData($t_Data, 2, $Rctrl)
		Case 8
			Local $Rctrl = GUICtrlRead($FSID, 1)
			DllStructSetData($t_Data, 2, $Rctrl)
			_GUICtrlTreeView_DeleteAll($hTreeViewPages)
			_GUICtrlTreeView_Add($hTreeViewPages, 0, $JMPlangset[0] & ' - 0')
			DllStructSetData($t_Data, 4, 0)
			_GUICtrlTreeView_SelectItem($hTreeViewPages, _GUICtrlTreeView_GetFirstItem($hTreeViewPages))
			GUICtrlSetState($wot, 4)
			GUICtrlSetState($wows, 4)
			GUICtrlSetState($backlight0, 1)
			GUICtrlSetState($deinstY, 1)
			$CurHtv = _GUICtrlTreeView_GetFirstItem($hTreeViewPages)
		Case 10, 11
			$gtc = _GUICtrlTreeView_GetCount($hTreeViewPages)
			Local $hNTvi = _GUICtrlTreeView_Add($hTreeViewPages, 0, $JMPlangset[0] & ' - ' & $gtc)
			_GUICtrlTreeView_SelectItem($hTreeViewPages, $hNTvi)
			Local $Rctrl = GUICtrlRead($FSID, 1)
			DllStructSetData($t_Data, 2, $Rctrl)
			$CurHtv = $hNTvi
		Case 12
			$fDel = 1
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hItem, $tInfo
	Local $tStruct = DllStructCreate('struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct;' & _
			'uint Action;struct;uint OldMask;handle OldhItem;uint OldState;uint OldStateMask;' & _
			'ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;endstruct;' & _
			'struct;uint NewMask;handle NewhItem;uint NewState;uint NewStateMask;' & _
			'ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;endstruct;' & _
			'struct;long PointX;long PointY;endstruct', $lParam)
	Local $iIDFrom = DllStructGetData($tStruct, 'hWndFrom')
	Local $iCode = DllStructGetData($tStruct, 'Code')
	Switch $iIDFrom
		Case $hTreeViewPages
			Switch $iCode
				Case $TVN_SELCHANGEDW, $TVN_SELCHANGEDA
					$hItem = DllStructGetData($tStruct, 'NewhItem')
					If $hItem Then
;~ 						_GUICtrlTreeView_SetState($hTreeViewPages, $hItem, $TVIS_SELECTED, 1)
						$htmpItem = $hItem
						$CurHtv = $hItem
						$nPage = Number(StringReplace(_GUICtrlTreeView_GetText($hTreeViewPages, $hItem), $JMPlangset[0] & ' - ', ''))
						If Not $fDel Then DllStructSetData($t_Data, 1, $nPage)
					EndIf

			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

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



