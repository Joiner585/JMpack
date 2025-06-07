#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=JMPACK.a3x
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#pragma compile(AutoItExecuteAllowed, true)
#include <UDF\MNOBJ.au3>
#include <UDF\FFSearch.au3>
#include <UDF\GIFAnimation.au3>
;~ #include <UDF\AutoItErrorHandler.au3>
#include <UDF\Icons.au3>
Opt("GUIOnEventMode", 1)
Opt('WinWaitDelay', 0)
Opt('TrayMenuMode', 1)
Opt('MustDeclareVars', 1)
Opt('GUICloseOnESC', 0)

;~ _OnAutoItErrorRegister('_MyErrorHandler')

_CurGui()

Func _CurGui()
	_PageCreate($OSNW, 'page' & $CurGui)
	Local $aGetObj = $OSNW.Item('page' & $CurGui)
	$objw = $aGetObj[0]
	$objc = $aGetObj[1]
	$WOTP = GUICreate('jmp_project', 615, 462, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $WOTP)
	GUISetBkColor(0X808080)
	_Middle($WOTP, 615, 462)
	Local $posw = WinGetPos($WOTP)
	$aINFPG[0] = $posw[0]
	$aINFPG[1] = $posw[1]
	$aINFPG[2] = $posw[2]
	$aINFPG[3] = $posw[3]
	$aINFPG[4] = 0X808080
	$aINFPG[5] = 1 ; деинсталятор. 1- да,
	$aINFPG[6] = 0
	$aINFPG[7] = 0 ;название игры
	$aINFPG[8] = 0 ; номер патча
	$aINFPG[9] = 0 ; подсветка управляющих элементов
	$aINFPG[10] = 0
	$objw.Add(0, $aINFPG)
	_REGMSG()
	DllStructSetData($t_Data, 5, $WOTP)
	GUISetAccelerators($AccelKeys, $WOTP)
	Local $TWH, $TWW
	Local $aInfo, $XDD, $YDD, $XD, $YD, $PC, $WGP, $ID, $ofp, $osp, $TXDD, $TYDD, $l1, $l2, $l3, $l4
	Local $lexp, $stgtst, $msmvc, $tmpx, $tmpy
	DllStructSetData($t_Data, 4, 0)
	Run(@ScriptDir & '\AutoIt3.exe' & ' controlw.a3x')
	Local $trdf = TimerInit()
	Do
		If WinExists(DllStructGetData($t_Data, 6)) Then ExitLoop
	Until TimerDiff($trdf) >= 5000
	If Not WinExists(DllStructGetData($t_Data, 6)) Then
		MsgBox(16, '', $JMPlangset[43])
		Exit
	EndIf
	_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
	GUISetState(@SW_SHOW, $WOTP)
	Local $nGetgui, $sGetFunc
	While 1
		If Not WinExists(DllStructGetData($t_Data, 6)) Then Exit
		$nGetgui = DllStructGetData($t_Data, 1)
		If $CurGui <> $nGetgui Then
			$flsize = 1
			If Not (DllStructGetData($t_Data, 2) == $JMPlangset[8]) Then _PAGECH($nGetgui)
		EndIf
		If $nFuncError Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_CLOSEREG()
			$nFuncError = 0
			MsgBox(64, '', $JMPlangset[44], 0, $WOTP)
			_REGMSG()
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		_MoveCtrlMod()
		While $mvwin
			$msmvc = MouseGetPos()
			If $tmpx = $msmvc[0] And $tmpy = $msmvc[1] Then
				Sleep(1)
				ContinueLoop
			EndIf
			WinMove($WOTP, '', $msmvc[0] - $winw, $msmvc[1] - $winh)
			$tmpx = $msmvc[0]
			$tmpy = $msmvc[1]
		WEnd
		If $flchpage Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_CLOSEREG()
			Local $gttpg = $objc.Item($tID)
			Local $setcpg
			If $gttpg[15] > -1 Then
				$setcpg = $gttpg[15]
			Else
				$setcpg = ''
			EndIf
			Local $inpage = InputBox($JMPlangset[0], $JMPlangset[45], $setcpg, '', 200, 130, Default, Default, 0, $WOTP)
			If Not @error And $inpage <> '' Then
				$gttpg[14] = 'chpage'
				$gttpg[15] = Number($inpage)
				$objc.Item($tID) = $gttpg
				_INFOCTRL($tID)
			EndIf
			$flchpage = 0
			_REGMSG()
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		If $flfurl Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_CLOSEREG()
			Local $gcs = $objc.Item($tID)
			Local $inurl = InputBox($JMPlangset[46], $JMPlangset[47], $gcs[15], '', 400, 130, Default, Default, 0, $WOTP)
			If Not @error And $inurl <> '' Then
				$gcs[14] = 'url'
				$gcs[15] = StringReplace($inurl, '<>', '')
				$objc.Item($tID) = $gcs
				_INFOCTRL($tID)
			EndIf
			$flfurl = 0
			_REGMSG()
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		If $flinst Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_SETMOD()
			$flinst = 0
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		If $flmmcr Then
			Local $GCC = GUIGetCursorInfo($WOTP)
			$cx = $GCC[0]
			$cy = $GCC[1]
			_CRCTRL()
			$flmmcr = 0
			_INFOCTRL($GCC[4])
		EndIf
		Switch DllStructGetData($t_Data, 3)
			Case 3
				GUISetState(@SW_SHOW, $WOTP)
				_WinAPI_RedrawWindow($WOTP)
				_WinAPI_UpdateWindow($WOTP)
				DllStructSetData($t_Data, 3, 0)
			Case 2
				Exit
			Case 1
				GUISetState(@SW_HIDE, $WOTP)
				$mmcr = 0
				$flsize = 1
				$flmmcr = 0
		EndSwitch
		If $nNewTxtItemTV Then
			Local $aInfTVItem = _GUITreeViewEx_GetItemData($g_GTVEx_aTVData)
			$aInfTVItem[0] = $sNewTxtItemTV
			_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $aInfTVItem)
			$nNewTxtItemTV = 0
		EndIf
		If $nFlagKeyDn Then
			_SetInfItem()
			$nFlagKeyDn = 0
		EndIf
		If $MnTVs Then
			$tID = _WinAPI_GetDlgCtrlID($g_GTVEx_aTVData)
			$szID = $tID
			Local $tPoint = _WinAPI_GetMousePos(1, $g_GTVEx_aTVData)
			Local $tTVHTI = _GUICtrlTreeView_HitTestEx($g_GTVEx_aTVData, DllStructGetData($tPoint, 1, 1), DllStructGetData($tPoint, 2))
			Local $hItemTV = DllStructGetData($tTVHTI, 'Item')
			If $hItemTV Then
				Switch DllStructGetData($tTVHTI, 'Flags')
					Case 4, 64
						_GUICtrlTreeView_SelectItem($g_GTVEx_aTVData, $hItemTV)
						_MenuItem($WOTP)
					Case Else
						_MenuTV($WOTP)
				EndSwitch
			Else
				_MenuTV($WOTP)
			EndIf
			$MnTVs = 0
		EndIf
		If $fldesgproc Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_CLOSEREG()
			$fldesgproc = 0
			_SetProgressDes()
			_REGMSG()
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		If $TpBar Then
			$TpBar = 0
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_CLOSEREG()
			_SelectProgressbar()
			_REGMSG()
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		$sGetFunc = DllStructGetData($t_Data, 2)
		If $sGetFunc <> '' Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			Switch String($sGetFunc)
				Case $JMPlangset[10]
					$flsize = 1
					_RSZW()
				Case $JMPlangset[8]
					_REMOVEPAGE()
					_PAGECH(0)
				Case $JMPlangset[7]
					_COPYW()
				Case $JMPlangset[35]
					Local $aKeys = $objc.Keys()
					Local $gcs
					For $i = 0 To UBound($aKeys) - 1
						$gcs = $objc.Item(Number($aKeys[$i]))
						Switch String($gcs[0])
							Case 'mod', 'checkbox'
								If Number($gcs[25]) = 32 Then
									GUICtrlSetState($aKeys[$i], $GUI_SHOW)
									$gcs[25] = 16
									$objc.Item($aKeys[$i]) = $gcs
								EndIf
						EndSwitch
					Next
				Case $JMPlangset[5]
					_NEWPR()
				Case $JMPlangset[11]
					_DesignPjt()
				Case $JMPlangset[6]
					_NEWPAGE()
				Case $JMPlangset[34]
					Local $GetAmount = $oMod.Keys(), $errcm = 0
					For $i In $GetAmount
						If StringIsDigit($i) Then
							$errcm = 1
							ExitLoop
						EndIf
					Next
					If Not $g_GTVEx_aTVData And Not $errcm Then
						$mmcr = 7
					ElseIf $errcm Then
						MsgBox(64, '', $JMPlangset[48], 0, $WOTP)
					ElseIf $g_GTVEx_aTVData Then
						Local $aGetNamectrl, $ncounttv = 0
						$GetAmount = $objc.Keys()
						For $i In $GetAmount
							$aGetNamectrl = $objc.Item($i)
							If $aGetNamectrl[0] = 'treeview' Then $ncounttv = 1
						Next
						If $ncounttv Then
							MsgBox(64, '', $JMPlangset[49], 0, $WOTP)
						Else
							$mmcr = 7
						EndIf
					EndIf
				Case $JMPlangset[27]
					$mmcr = 3
				Case $JMPlangset[28]
					If $oMod.Exists('perc') Then
						MsgBox(64, '', $JMPlangset[50], 0, $WOTP)
					Else
						$mmcr = 5
					EndIf
				Case $JMPlangset[29]
					$mmcr = 6
				Case $JMPlangset[30]
					$mmcr = 8
				Case $JMPlangset[33]
					If Not $g_GTVEx_aTVData Then
						$mmcr = 10
					Else
						MsgBox(64, '', $JMPlangset[51], 0, $WOTP)
					EndIf
				Case $JMPlangset[13]
					Local $aGetObj = $OSNW.Item('page0')
					Local $oWot = $aGetObj[0]
					Local $gttpg = $oWot.Item(0)
					$gttpg[9] = 0
					$oWot.Item(0) = $gttpg
				Case $JMPlangset[14]
					Local $aGetObj = $OSNW.Item('page0')
					Local $oWot = $aGetObj[0]
					Local $gttpg = $oWot.Item(0)
					$gttpg[9] = 1
					$oWot.Item(0) = $gttpg
				Case $JMPlangset[15]
					Local $aGetObj = $OSNW.Item('page0')
					Local $oWot = $aGetObj[0]
					Local $gttpg = $oWot.Item(0)
					$gttpg[9] = 2
					$oWot.Item(0) = $gttpg
				Case $JMPlangset[16]
					_CLOSEREG()
					Local $aGetObj = $OSNW.Item('page0')
					Local $oWot = $aGetObj[0]
					Local $gttpg = $oWot.Item(0)
					Local $backlightcolor = _clback($WOTP, -1, Number($gttpg[10]))
					If Not @error Then
						$gttpg[9] = 3
						$gttpg[10] = Number($backlightcolor)
						$oWot.Item(0) = $gttpg
					EndIf
					_REGMSG()
				Case $JMPlangset[19]
					Local $aGetObj = $OSNW.Item('page0')
					Local $oWot = $aGetObj[0]
					Local $gttpg = $oWot.Item(0)
					$gttpg[5] = 1
					$oWot.Item(0) = $gttpg
				Case $JMPlangset[20]
					Local $aGetObj = $OSNW.Item('page0')
					Local $oWot = $aGetObj[0]
					Local $gttpg = $oWot.Item(0)
					$gttpg[5] = 0
					$oWot.Item(0) = $gttpg
				Case 'Lesta', 'Wargaming'
					_CLOSEREG()
					Local $aGetObj = $OSNW.Item('page0')
					Local $oWows = $aGetObj[0]
					Local $gttpg = $oWows.Item(0)
					Local $curpt
					If Not (String($gttpg[8]) == '0') Then
						$curpt = $gttpg[8]
					Else
						$curpt = ''
					EndIf
					Local $GetPathExe = ''
					Switch String($sGetFunc)
						Case 'Wargaming'
							$GetPathExe = 'WorldofTanks.exe'
						Case 'Lesta'
							$GetPathExe = 'Tanki.exe'
					EndSwitch
					Local $inver = InputBox($sGetFunc, $JMPlangset[52] & ' ' & $GetPathExe & ' (0.0.0.0|0.0.0.0)', $curpt, '', 500, 130, Default, Default, 0, $WOTP)
					If Not @error Then
						If $inver = '' Then $inver = 0
						$gttpg[7] = String($sGetFunc)
						$gttpg[8] = $inver
						$oWows.Item(0) = $gttpg
						$chgame = String($sGetFunc)
					EndIf
					_REGMSG()
				Case $JMPlangset[21]
					DllStructSetData($t_Data, 10, 1)
					Opt("GUIOnEventMode", 0)
					GUIRegisterMsg($WM_SETCURSOR, '')
					GUIRegisterMsg($WM_MOUSEWHEEL, '')
					GUISetState(@SW_HIDE, $WOTP)
					Local $comperror
					_COMPPR()
					$comperror = @error
					Dim $aAllmod[1][5]
					Dim $reswin[1]
					Dim $aINFCTRL[26]
					GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
					GUIRegisterMsg($WM_MOUSEWHEEL, 'WM_MOUSEWHEEL')
					Opt("GUIOnEventMode", 1)
					If $comperror <> 4 Then
						_CLOSEREG()
						_GLPR($WOTP, $JMPlangset[53])
						_LOADPJT($prjpath)
						Switch @error
							Case 0, 1
								DllStructSetData($t_Data, 9, $prjpath)
							Case 2, 3
								DllStructSetData($t_Data, 11, 1)
								_NEWPR()
						EndSwitch
						_REGMSG()
					EndIf
					WinSetState(DllStructGetData($t_Data, 6), '', @SW_SHOW)
					DllStructSetData($t_Data, 10, 2)
					GUISetState(@SW_SHOW, $WOTP)
				Case $JMPlangset[1]
					_CLOSEREG()
					If Not FileExists($prjpath) Then
						$ofp = FileSelectFolder($JMPlangset[54], @ScriptDir, 7, '', $WOTP)
						If Not @error Then
							_SavePJT($ofp)
							If @error Then
								MsgBox(16, @error, $JMPlangset[55], 0, $WOTP)
							Else
								MsgBox(64, '', $JMPlangset[56], 1, $WOTP)
								$prjpath = $ofp
								DllStructSetData($t_Data, 9, $prjpath)
							EndIf
						EndIf
					Else
						_SavePJT($prjpath)
						If @error Then
							MsgBox(16, @error, $JMPlangset[55], 0, $WOTP)
						Else
							MsgBox(64, '', $JMPlangset[56], 1, $WOTP)
						EndIf
					EndIf
					_REGMSG()
				Case $JMPlangset[4]
					_CLOSEREG()
					$tmspr = $prjpath
					Local $fileinfpack = $tmspr & '\fileinf.ini'
					$prjpath = ''
					$ofp = FileSelectFolder($JMPlangset[54], @ScriptDir, 7, '', $WOTP)
					If Not @error Then
						_SavePJT($ofp)
						If @error Then
							If $tmspr Then $prjpath = $tmspr
							MsgBox(16, @error, $JMPlangset[55], 0, $WOTP)
						Else
							If FileExists($fileinfpack) Then FileCopy($fileinfpack, $ofp & '\fileinf.ini')
							MsgBox(64, '', $JMPlangset[56], 1, $WOTP)
							$prjpath = $ofp
							DllStructSetData($t_Data, 9, $prjpath)
							If $tmspr Then $tmspr = 0
						EndIf
					Else
						If $tmspr Then
							$prjpath = $tmspr
							$tmspr = 0
						EndIf
					EndIf
					_REGMSG()
				Case $JMPlangset[9]
					_CLOSEREG()
					_GuiTrans()
					_REGMSG()
				Case $JMPlangset[2]
					_CLOSEREG()
					Local $ldpjt = FileSelectFolder($JMPlangset[57], @ScriptDir, 7, '', $WOTP)
					If Not @error Then
						DllStructSetData($t_Data, 10, 1)
						GUISetState(@SW_HIDE, $WOTP)
						_GLPR($WOTP, $JMPlangset[53])
						_LOADPJT($ldpjt)
						If @error Then
							Switch @error
								Case 0, 1
									DllStructSetData($t_Data, 9, $prjpath)
								Case 2, 3
									DllStructSetData($t_Data, 11, 1)
									_NEWPR()
							EndSwitch
						Else
							DllStructSetData($t_Data, 9, $ldpjt)
						EndIf
						WinSetState(DllStructGetData($t_Data, 6), '', @SW_SHOW)
						DllStructSetData($t_Data, 10, 2)
						GUISetState(@SW_SHOW, $WOTP)
					EndIf
					WinActivate($WOTP)
					WinActivate(DllStructGetData($t_Data, 6))
					_REGMSG()
				Case $JMPlangset[3]
					If FileExists($prjpath) Then
						_CLOSEREG()
						DllStructSetData($t_Data, 10, 1)
						GUISetState(@SW_HIDE, $WOTP)
						_GLPR($WOTP, $JMPlangset[58])
						_LOADPJT($prjpath)
						Switch @error
							Case 0, 1
								DllStructSetData($t_Data, 9, $prjpath)
							Case 2, 3
								DllStructSetData($t_Data, 11, 1)
								_NEWPR()
						EndSwitch
						WinSetState(DllStructGetData($t_Data, 6), '', @SW_SHOW)
						DllStructSetData($t_Data, 10, 2)
						GUISetState(@SW_SHOW, $WOTP)
						WinActivate($WOTP)
						WinActivate(DllStructGetData($t_Data, 6))
						_REGMSG()
					EndIf
			EndSwitch
			DllStructSetData($t_Data, 2, '')
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		If $flwpic Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_CLOSEREG()
			$ofp = FileOpenDialog($JMPlangset[59], $pathwpic, '(*.png;*.jpg;*.bmp)', 2, '', $WOTP)
			If Not @error Then
				If $objc.Exists($tID) Then
					$osp = $objc.Item($tID)
					_SetImage($tID, $ofp, $osp[4], $osp[5], -1)
					If Not @error Then
						GUICtrlSetPos($tID, $osp[2], $osp[3], $osp[4], $osp[5])
						$osp[12] = $ofp
						$objc.Item($tID) = $osp
						$pathwpic = StringTrimLeft($ofp, StringInStr($ofp, '\', 0, -1))
					EndIf
					_WinAPI_RedrawWindow($WOTP)
					_WinAPI_UpdateWindow($WOTP)
				EndIf
			EndIf
			$flwpic = 0
			_REGMSG()
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
		EndIf
		If $flfont Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			GUIRegisterMsg($WM_SETCURSOR, '')
			GUIRegisterMsg($WM_COMMAND, '')
			_font($WOTP, $tID)
			$flfont = 0
			GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
			GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
			_WinAPI_RedrawWindow($WOTP)
			_WinAPI_UpdateWindow($WOTP)
		EndIf
		If $flcl Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			GUIRegisterMsg($WM_SETCURSOR, '')
			GUIRegisterMsg($WM_COMMAND, '')
			_colortext($WOTP, $tID)
			$flcl = 0
			GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
			GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
			_WinAPI_RedrawWindow($WOTP)
			_WinAPI_UpdateWindow($WOTP)
		EndIf
		If $flbck Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			GUIRegisterMsg($WM_SETCURSOR, '')
			GUIRegisterMsg($WM_COMMAND, '')
			_clback($WOTP, $tID)
			$flbck = 0
			GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
			GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
			_WinAPI_RedrawWindow($WOTP)
			_WinAPI_UpdateWindow($WOTP)
		EndIf
		If $retxt Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_CHT()
			$retxt = 0
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
			_WinAPI_RedrawWindow($WOTP)
			_WinAPI_UpdateWindow($WOTP)
		EndIf
		If $chkrsz Then
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
			_RSZ($tID)
			$chkrsz = 0
			WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
			_WinAPI_RedrawWindow($WOTP)
			_WinAPI_UpdateWindow($WOTP)
		EndIf
		If $flmove Then
			$aInfo = GUIGetCursorInfo($WOTP)
			If Not @error Then
				Switch $aInfo[4]
					Case 0
						$flmove = 0
						ContinueLoop
					Case Else
						$stgtst = $objc.Item($aInfo[4])
						If $stgtst[9] = 128 Or $stgtst[7] = $GUI_WS_EX_PARENTDRAG Then
							$flmove = 0
							ContinueLoop
						EndIf
				EndSwitch
				$ID = $aInfo[4]
				$WGP = WinGetPos($WOTP)
				$TWW = $WGP[2]
				$TWH = $WGP[3]
				If $aInfo[4] Then
					GUIRegisterMsg($WM_SETCURSOR, '')
					$mmcr = 0
					$PC = ControlGetPos($WOTP, '', $ID)
					$XD = $aInfo[0] - $PC[0]
					$YD = $aInfo[1] - $PC[1]
					$l1 = GUICtrlCreateLabel('', $PC[0], 0, 1, $TWH)
					GUICtrlSetBkColor(-1, 0xFF0000)
					$l2 = GUICtrlCreateLabel('', 0, $PC[1], $TWW, 1)
					GUICtrlSetBkColor(-1, 0xFF0000)
					$l3 = GUICtrlCreateLabel('', $PC[0] + $PC[2], 0, 1, $TWH)
					GUICtrlSetBkColor(-1, 0xFF0000)
					$l4 = GUICtrlCreateLabel('', 0, $PC[1] + $PC[3], $TWW, 1)
					GUICtrlSetBkColor(-1, 0xFF0000)
					While $aInfo[2] ;
						Sleep(1)
						If Not _IsPressed('11', $hDLL) Then ExitLoop
						$aInfo = GUIGetCursorInfo($WOTP)
						$XDD = $aInfo[0] - $XD
						$YDD = $aInfo[1] - $YD
						If $TXDD = $XDD And $TYDD = $YDD Then ContinueLoop
						GUICtrlSetPos($l1, $XDD, 0, 1, $TWH)
						GUICtrlSetPos($l2, 0, $YDD, $TWW, 1)
						GUICtrlSetPos($l3, $XDD + $PC[2], 0, 1, $TWH)
						GUICtrlSetPos($l4, 0, $YDD + $PC[3], $TWW, 1)
						GUICtrlSetPos($ID, $XDD, $YDD, $PC[2], $PC[3])
						$TXDD = $XDD
						$TYDD = $YDD
						$osp = $objc.Item($ID)
						$osp[2] = $XDD
						$osp[3] = $YDD
						$objc.Item($ID) = $osp
						_INFOCTRL($ID)
					WEnd
					$flmove = 0
					GUICtrlDelete($l1)
					GUICtrlDelete($l2)
					GUICtrlDelete($l3)
					GUICtrlDelete($l4)
					_WinAPI_RedrawWindow($WOTP)
					_WinAPI_UpdateWindow($WOTP)
					GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
				EndIf
			EndIf
		EndIf
		_CoordSet()
		Sleep(10)
	WEnd
EndFunc   ;==>_CurGui

Func _GuiTrans()
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $gttpg
	$gttpg = $objw.Item(0)
	Local $hGuiColorTrans = GUICreate($JMPlangset[60], 200, 100, -1, -1, -1, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $hGuiColorTrans)
	GUISetBkColor(0x808080)
	GUISetFont(10, 400, 0, 'Georgia')
	Local $TransGui = GUICtrlCreateCheckbox($JMPlangset[61], 16, 16, 140, 25)
	DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($TransGui), 'wstr', '', 'wstr', '')
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x808080)
	If Number($gttpg[6]) Then GUICtrlSetState(-1, 1)
	Local $GSColor = GUICtrlCreateButton($JMPlangset[62], 16, 56, 140, 25)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x808080)
	GUISetState(@SW_SHOW, $hGuiColorTrans)
	While 1
		Switch GUIGetMsg()
			Case -3
				GUIDelete($hGuiColorTrans)
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				WinActivate($WOTP)
				Return
			Case $TransGui
				Switch GUICtrlRead($TransGui)
					Case 1
						$gttpg = $objw.Item(0)
						$gttpg[6] = 1
						$gttpg[4] = 50
						$objw.Item(0) = $gttpg
						GUISetBkColor(50, $WOTP)
						_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
					Case 4
						$gttpg = $objw.Item(0)
						$gttpg[6] = 0
						$gttpg[4] = 0x808080
						$objw.Item(0) = $gttpg
						GUISetBkColor(0x808080, $WOTP)
						_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
				EndSwitch
			Case $GSColor
				_clback($WOTP, 0)
				$gttpg = $objw.Item(0)
				$gttpg[6] = 0
				$objw.Item(0) = $gttpg
				GUIDelete($hGuiColorTrans)
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				WinActivate($WOTP)
				Return _WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
		EndSwitch
	WEnd
EndFunc   ;==>_GuiTrans

Func _MoveCtrlMod()
	Local $l1, $l2, $l3, $l4, $TWH, $TWW, $aInfo1, $aInfo, $XDD, $YDD
	While _IsPressed('12', $hDLL)
		If $startcrlb = 1 Then
			$startcrlb = 0
			GUIRegisterMsg($WM_SETCURSOR, '')
			$aInfo = GUIGetCursorInfo($WOTP)
			$l1 = GUICtrlCreateLabel('', $aInfo[0], $aInfo[1], 1, 1)
			GUICtrlSetBkColor(-1, 0xFF0000)
			$l2 = GUICtrlCreateLabel('', $aInfo[0], $aInfo[1], 1, 1)
			GUICtrlSetBkColor(-1, 0xFF0000)
			$l3 = GUICtrlCreateLabel('', $aInfo[0], $aInfo[1], 1, 1)
			GUICtrlSetBkColor(-1, 0xFF0000)
			$l4 = GUICtrlCreateLabel('', $aInfo[0], $aInfo[1], 1, 1)
			GUICtrlSetBkColor(-1, 0xFF0000)
			While _IsPressed('01', $hDLL) ; нажата левая кнопка мыши
				Sleep(1)
				If Not _IsPressed('12', $hDLL) Then ExitLoop
				$aInfo1 = GUIGetCursorInfo($WOTP)
				If $aInfo1[0] < $aInfo[0] Then
					$TWW = $aInfo[0] - $aInfo1[0] ; ширина прямоульника
					GUICtrlSetPos($l1, $aInfo1[0], $aInfo[1], $TWW, 1) ;верх
					GUICtrlSetPos($l2, $aInfo1[0], $aInfo1[1], $TWW, 1) ;низ
					$XDD = $aInfo[0] - $TWW ; Х координата прямоугольника
				ElseIf $aInfo1[0] > $aInfo[0] Then
					$TWW = $aInfo1[0] - $aInfo[0]
					GUICtrlSetPos($l1, $aInfo[0], $aInfo[1], $TWW, 1)
					GUICtrlSetPos($l2, $aInfo[0], $aInfo1[1], $TWW, 1)
					$XDD = $aInfo1[0] - $TWW

				EndIf
				If $aInfo1[1] < $aInfo[1] Then
					$TWH = $aInfo[1] - $aInfo1[1]
					GUICtrlSetPos($l3, $aInfo1[0], $aInfo1[1], 1, $TWH) ;лево
					GUICtrlSetPos($l4, $aInfo[0], $aInfo1[1], 1, $TWH) ;право
					$YDD = $aInfo1[1] ;Y координата прямоугольника
				ElseIf $aInfo1[1] > $aInfo[1] Then
					$TWH = $aInfo1[1] - $aInfo[1] ; высота прямоугольника
					GUICtrlSetPos($l3, $aInfo[0], $aInfo[1], 1, $TWH)
					GUICtrlSetPos($l4, $aInfo1[0], $aInfo[1], 1, $TWH)
					$YDD = $aInfo[1]
				EndIf
				DllStructSetData($t_Data, 8, 'X - ' & $XDD & @CRLF & 'Y - ' & $YDD & @CRLF & $JMPlangset[63] & ' - ' & $TWW & @CRLF & $JMPlangset[64] & ' - ' & $TWH)
			WEnd
			GUICtrlDelete($l1)
			GUICtrlDelete($l2)
			GUICtrlDelete($l3)
			GUICtrlDelete($l4)
			Local $aGetAllItems = $objc.Keys(), $aItemInf
			For $i In $aGetAllItems
				_ArraySearch($aModMove, $i)
				If @error Then
					$aItemInf = $objc.Item($i)
					If ((($aItemInf[2] >= $XDD And $aItemInf[2] <= ($XDD + $TWW) Or ($aItemInf[2] + $aItemInf[4]) <= ($XDD + $TWW) And ($aItemInf[2] + $aItemInf[4]) >= $XDD)) And _
							(($aItemInf[3] >= $YDD And $aItemInf[3] <= ($YDD + $TWH) Or ($aItemInf[3] + $aItemInf[5]) <= ($YDD + $TWH) And ($aItemInf[3] + $aItemInf[5]) >= $YDD))) Or _
							(($aItemInf[2] < $XDD And ($aItemInf[2] + $aItemInf[4]) > ($XDD + $TWW)) And _
							(($aItemInf[3] >= $YDD And $aItemInf[3] <= ($YDD + $TWH) Or ($aItemInf[3] + $aItemInf[5]) <= ($YDD + $TWH) And ($aItemInf[3] + $aItemInf[5]) >= $YDD))) Then
						GUICtrlSetBkColor($i, 0x0000FF)
						If Not (Number($aItemInf[9]) = 128 Or Number($aItemInf[7]) = $GUI_WS_EX_PARENTDRAG) Then _ArrayAdd($aModMove, $i)
					EndIf
				EndIf
			Next
			GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
			Return
		EndIf
		If $startcrlb = 2 Then
			$startcrlb = 0
			GUIRegisterMsg($WM_SETCURSOR, '')
			If UBound($aModMove) And _IsPressed('01', $hDLL) And _IsPressed('12', $hDLL) Then
				Local $aInfo, $TXDD, $TYDD, $XDD, $YDD, $aItemInf, $iXDD, $iYDD
				$aInfo = GUIGetCursorInfo($WOTP)
				$TXDD = $aInfo[0]
				$TYDD = $aInfo[1]
				Local $XDiff, $YDiff, $vlmove = $aInfo[4], $curidmov = $aInfo[4]
				Local $PC = ControlGetPos($WOTP, '', $vlmove)
				Local $XD = $aInfo[0] - $PC[0]
				Local $YD = $aInfo[1] - $PC[1]
				If _ArraySearch($aModMove, $aInfo[4]) = -1 Then $vlmove = 0
				While $vlmove
					Sleep(1)
					$vlmove = _IsPressed('01', $hDLL)
					If Not _IsPressed('12', $hDLL) Then ExitLoop
					$aInfo = GUIGetCursorInfo($WOTP)
					$iXDD = $aInfo[0] - $XD
					$iYDD = $aInfo[1] - $YD
					If $TXDD = $aInfo[0] And $TYDD = $aInfo[1] Then
						ContinueLoop
					Else
						$XDiff = $TXDD - $aInfo[0]
						$YDiff = $TYDD - $aInfo[1]
						For $i = 0 To UBound($aModMove) - 1
							$aItemInf = $objc.Item($aModMove[$i])
							$XDD = $aItemInf[2] - $XDiff
							$YDD = $aItemInf[3] - $YDiff
							GUICtrlSetPos($aModMove[$i], $XDD, $YDD, Default, Default)
							$aItemInf[2] = $XDD
							$aItemInf[3] = $YDD
							$objc.Item($aModMove[$i]) = $aItemInf
						Next
						$TXDD = $aInfo[0]
						$TYDD = $aInfo[1]
					EndIf
					_INFOCTRL($curidmov)
				WEnd
				_setcolor()
			EndIf
			GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
			Return
		EndIf
		Sleep(1)
	WEnd
	_setcolor()
EndFunc   ;==>_MoveCtrlMod

Func _setcolor()
	Local $aItemInf
	For $i = 0 To UBound($aModMove) - 1
		$aItemInf = $objc.Item($aModMove[$i])
		GUICtrlSetBkColor($aModMove[$i], $aItemInf[11])
	Next
	Dim $aModMove[0]
EndFunc   ;==>_setcolor

Func _INDENTH($iNum, $aEL)
	If UBound($aEL) = 0 Then Return
	Local $aMinIndV[0]
	Local $CurIndG
	While 1
		$CurIndG = _ArrayMinIndex($aEL, 1, 0, 0, 1)
		If @error Then
;~ 			_ArrayAdd($aMinIndV, $aEL[0][0])
			ExitLoop
		EndIf
		_ArrayAdd($aMinIndV, $aEL[$CurIndG][0])
		_ArrayDelete($aEL, $CurIndG)
	WEnd
	Local $gtinfar
	$gtinfar = $objc.Item(Number($aMinIndV[0]))
	Local $bmy = $gtinfar[4] + $gtinfar[2]
	For $i = 1 To UBound($aMinIndV) - 1
		$gtinfar = $objc.Item(Number($aMinIndV[$i]))
		GUICtrlSetPos(Number($aMinIndV[$i]), $bmy + $iNum)
		$gtinfar[2] = $bmy + $iNum
		$objc.Item(Number($aMinIndV[$i])) = $gtinfar
		$bmy = $gtinfar[2] + $gtinfar[4]
	Next
EndFunc   ;==>_INDENTH

Func _INDENTV($iNum, $aEL)
	If UBound($aEL) = 0 Then Return
	Local $aMinIndV[0]
	Local $CurIndG
	While 1
		$CurIndG = _ArrayMinIndex($aEL, 1, 0, 0, 2)
		If @error Then
;~ 			_ArrayAdd($aMinIndV, $aEL[0][0])
			ExitLoop
		EndIf
		_ArrayAdd($aMinIndV, $aEL[$CurIndG][0])
		_ArrayDelete($aEL, $CurIndG)
	WEnd
	Local $gtinfar
	$gtinfar = $objc.Item(Number($aMinIndV[0]))
	Local $bmy = $gtinfar[5] + $gtinfar[3]
	For $i = 1 To UBound($aMinIndV) - 1
		$gtinfar = $objc.Item(Number($aMinIndV[$i]))
		GUICtrlSetPos(Number($aMinIndV[$i]), $gtinfar[2], $bmy + $iNum)
		$gtinfar[3] = $bmy + $iNum
		$objc.Item(Number($aMinIndV[$i])) = $gtinfar
		$bmy = $gtinfar[3] + $gtinfar[5]
	Next
EndFunc   ;==>_INDENTV

Func _MOVEALLXY($iNum, $aEL, $xy = 0)
	If UBound($aEL) = 0 Then Return
	Local $gtinfar
	For $i = 0 To UBound($aEL) - 1
		$gtinfar = $objc.Item(Number($aEL[$i][0]))
		If $xy Then
			GUICtrlSetPos(Number($aEL[$i][0]), $gtinfar[2], $iNum)
			$gtinfar[3] = $iNum
		Else
			GUICtrlSetPos(Number($aEL[$i][0]), $iNum, $gtinfar[3])
			$gtinfar[2] = $iNum
		EndIf
		$objc.Item(Number($aEL[$i][0])) = $gtinfar
	Next
EndFunc   ;==>_MOVEALLXY

Func _SETCOORD()
	Local $gtind = _SETIND()
	If Not @error Then
		Switch $gtind[0]
			Case 1
				_MOVEALLXY($gtind[1], $HVXY)
			Case 2
				_MOVEALLXY($gtind[1], $HVXY, 1)
			Case 3
				_INDENTV($gtind[1], $HVXY) ;
			Case 4
				_INDENTH($gtind[1], $HVXY) ;
		EndSwitch
	EndIf
EndFunc   ;==>_SETCOORD

Func _SETIND()
	_CLOSEREG()
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $aXY[2]
	Local $flxy = 1
	Local $STP = GUICreate('', 240, 178, -1, -1, -1, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $STP)
	GUISetBkColor(0x808080)
	GUISetFont(9, 400, 0, 'Georgia', $STP)
	Local $Radio1 = GUICtrlCreateRadio($JMPlangset[65], 16, 16, 200, 17)
	GUICtrlSetState(-1, 1)
	Local $Radio2 = GUICtrlCreateRadio($JMPlangset[66], 16, 48, 200, 17)
	Local $Radio3 = GUICtrlCreateRadio($JMPlangset[67], 16, 80, 200, 17)
	Local $Radio4 = GUICtrlCreateRadio($JMPlangset[68], 16, 112, 200, 17)
	Local $IND = GUICtrlCreateInput('', 16, 144, 121, 21) ;, $ES_NUMBER)
	GUISetState(@SW_SHOW, $STP)
	Local $RI
	While 1
		If Not WinExists(DllStructGetData($t_Data, 6)) Then Exit
		Switch GUIGetMsg()
			Case -3
				$RI = Number(GUICtrlRead($IND))
				If $RI Then
					GUIDelete($STP)
					_REGMSG()
					Opt("GUIOnEventMode", 1)
					Opt('GUICloseOnESC', 0)
					$aXY[0] = $flxy
					$aXY[1] = $RI
					WinActivate($WOTP)
					Return $aXY
				Else
					GUIDelete($STP)
					_REGMSG()
					Opt("GUIOnEventMode", 1)
					Opt('GUICloseOnESC', 0)
					WinActivate($WOTP)
					Return SetError(1)
				EndIf
			Case $Radio1
				$flxy = 1
			Case $Radio2
				$flxy = 2
			Case $Radio3
				$flxy = 3
			Case $Radio4
				$flxy = 4
		EndSwitch
	WEnd
EndFunc   ;==>_SETIND

Func _CLOSEREG()
	GUIRegisterMsg($WM_SETCURSOR, '')
	GUIRegisterMsg($WM_COMMAND, '')
	GUIRegisterMsg($WM_MOUSEWHEEL, '')
EndFunc   ;==>_CLOSEREG

Func _REGMSG()
	GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
	GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
	GUIRegisterMsg($WM_MOUSEWHEEL, 'WM_MOUSEWHEEL')
EndFunc   ;==>_REGMSG

Func _WINPACK()
	GUIRegisterMsg($WM_COMMAND, '')
	$stoppr = 0
	$FMmod = GUICreate($JMPlangset[69], 517, 142, -1, -1)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $FMmod)
	GUISetBkColor(0x808080)
	GUISetFont(10, 400, 0, 'Georgia', $FMmod)
	GUICtrlCreateLabel('', 8, 18, 500, 29, 0x09)
	GUICtrlSetState(-1, 128)
	$LBTitleInfo = GUICtrlCreateLabel('', 10, 20, 497, 25, 0x0C)
	GUICtrlSetColor(-1, 0xFFA900)
	GUICtrlCreateLabel('', 8, 54, 500, 29, 0x09)
	GUICtrlSetState(-1, 128)
	$LBinfps = GUICtrlCreateProgress(10, 56, 497, 25)
	DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($LBinfps), 'wstr', '', 'wstr', '')
	GUICtrlSetBkColor($LBinfps, 0x808080)
	GUICtrlSetColor(-1, 0x0000FF)
	$CLmodpr = GUICtrlCreateButton($JMPlangset[70], 424, 104, 75, 25)
	ControlFocus($FMmod, '', $LBTitleInfo)
	Local $hMenuBar = _GUICtrlMenu_GetSystemMenu($FMmod)
	_GUICtrlMenu_EnableMenuItem($hMenuBar, $SC_CLOSE, True, False)
	_GUICtrlMenu_DrawMenuBar($hMenuBar)
	GUISetState(@SW_SHOW, $FMmod)
	GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
	_SETPACK()
EndFunc   ;==>_WINPACK

Func _SETPACK()
	Local $7ZSize, $pr7za, $ReadST, $7zPr, $tmp7zPr, $aGetFilesInMod
	For $i = 1 To UBound($aAllmod) - 1
		If FileExists($aAllmod[$i][1]) Then
			GUICtrlSetData($LBTitleInfo, $aAllmod[$i][1])
			$aGetFilesInMod = _FileListToArrayRec($aAllmod[$i][1], '*', 1, 1, 0, 2)
			If Not @error Then
				For $iListModB = 1 To $aGetFilesInMod[0]
					$aGetFilesInMod[$iListModB] = StringReplace($aGetFilesInMod[$iListModB], $aAllmod[$i][1] & '\', '')
				Next
				$aGetFilesInMod = _ArrayToString($aGetFilesInMod, @LF)
				FileWrite($wkdir & '\' & $aAllmod[$i][0] & '.txt', $aGetFilesInMod)
			EndIf
			$pr7za = Run(@ScriptDir & '\7za.exe a -ssw -mx9 -bsp2 -r0 -aoa -y -pshooting_at_slip "' & $wkdir & '\' & $aAllmod[$i][0] & '.7z' & '" ' & '"' & $aAllmod[$i][1] & '\*"', '', @SW_HIDE, 0x8)
			If @error Then $stoppr = 1
			While Sleep(1)
				If $stoppr Then
					$stoppr = 0
					GUICtrlSetData($LBTitleInfo, $JMPlangset[71])
					ProcessClose($pr7za)
					DirRemove($wkdir, 1)
					GUIDelete($FMmod)
					Return
				EndIf
				$ReadST = StdoutRead($pr7za)
				If @error Then
					$7zPr = 0
					$tmp7zPr = 0
					ExitLoop
				Else
					If $ReadST <> '' Then
						$7zPr = Number(StringRegExpReplace($ReadST, '(.*?)%.*', '\1'))
						If $tmp7zPr < $7zPr Then
							GUICtrlSetData($LBinfps, $7zPr)
						EndIf
					EndIf
				EndIf
			WEnd
			$7ZSize = FileGetSize($wkdir & '\' & $aAllmod[$i][0] & '.7z')
			IniWrite($wkdir & '\page0.jmp3', 'sizezip', $aAllmod[$i][0], $7ZSize)
		EndIf
	Next
	Local $aList = _FileListToArray($wkdir, '*.*')
	If @error Then
		DirRemove($wkdir, 1)
		GUIDelete($FMmod)
		Return
	EndIf
	Local $sISSetups = '[Setup]' & @CRLF
	Local $setconfigiss
	For $i = 0 To 10
		If $i = 0 Then
			If $aSetISS[$i][1] = '' Then
				$sISSetups &= $aSetISS[$i][0] & '=' & 'JmpackISS' & @CRLF
			Else
				$sISSetups &= $aSetISS[$i][0] & '=' & $aSetISS[$i][1] & @CRLF
			EndIf
		ElseIf $i = 1 Then
			If $aSetISS[$i][1] = '' Then
				$sISSetups &= $aSetISS[$i][0] & '=' & $prjpath & @CRLF
				$setconfigiss = $prjpath
			Else
				$sISSetups &= $aSetISS[$i][0] & '=' & $aSetISS[$i][1] & @CRLF
				$setconfigiss = $aSetISS[$i][1]
			EndIf
		Else
			If $aSetISS[$i][1] = '' Then
				$sISSetups &= $aSetISS[$i][0] & "=" & @CRLF
			Else
				$sISSetups &= $aSetISS[$i][0] & '=' & $aSetISS[$i][1] & @CRLF
			EndIf
		EndIf
	Next
	Local $sRet = '', $sRet1 = '', $sList7z = ''
	For $i = 1 To $aList[0]
		If Not (StringRight($aList[$i], 2) = '7z') Then
			$sRet &= "ExtractTemporaryFile('" & $aList[$i] & "');" & @CRLF
		Else
			$sList7z &= $aList[$i] & @CRLF
		EndIf
	Next
	GUIDelete($FMmod)
	Local $agetlanginstall, $sdllgetlang = DllStructGetData($t_Data, 'lang')
	If Not ($sdllgetlang = 'LangDef') Then
		$agetlanginstall = IniReadSection(@ScriptDir & '\language\' & $sdllgetlang & '.txt', 'INSTALL')
		IniWriteSection($wkdir & '\lang.txt', 'INSTALL', $agetlanginstall, 1)
		$sRet &= "ExtractTemporaryFile('lang.txt');" & @CRLF
	EndIf
	$sRet1 &= 'Source: "' & $wkdir & '\*' & '"; DestDir: "{tmp}"; Flags: ignoreversion' & @CRLF
	If Not ($sList7z = '') Then
		$sRet &= "ExtractTemporaryFile('list7z.txt');" & @CRLF
		FileWrite($wkdir & '\list7z.txt', $sList7z)
	EndIf
	$sISSetups &= $SetupISS & $sRet & $WisardISS & "[Files]" & @CRLF & $sRet1
	Local $hfois = FileOpen($setconfigiss & '\setconf.iss', 130)
	FileWrite($hfois, $sISSetups)
	FileClose($hfois)
	GUICtrlSetData($LBTitleInfo, $JMPlangset[72])
	Switch MsgBox(36 + 262144, '', $JMPlangset[229], 10, $WOTP)
		Case -1, 6
			RunWait(@ScriptDir & '\CompilerISS\Compil32.exe /cc "' & $setconfigiss & '\setconf.iss' & '"')
			FileDelete($setconfigiss & '\setconf.iss')
			DirRemove($wkdir, 1)
	EndSwitch
EndFunc   ;==>_SETPACK

Func _COPYRES()
	Local $ercopy, $strer = ''
	_GLPR($WOTP, $JMPlangset[73])
	Local $asf
	Local $curani = $wkdir & '\arrow.ani', $curc = $wkdir & '\arrow.cur', $force_a = $wkdir & '\force.ani', $force_c = $wkdir & '\force.cur'
	If StringRight($aDesignPath[0][1], 3) = 'cur' Then
		FileCopy($aDesignPath[0][1], $curc, 1)
	Else
		FileCopy($aDesignPath[0][1], $curani, 1)
	EndIf
	If StringRight($aDesignPath[1][1], 3) = 'cur' Then
		FileCopy($aDesignPath[1][1], $force_c, 1)
	Else
		FileCopy($aDesignPath[1][1], $force_a, 1)
	EndIf
	FileCopy($aDesignPath[2][1], $wkdir & '\bckau.mp3', 1)
	FileCopy($aDesignPath[3][1], $wkdir & '\flash.png', 1)
	FileCopy(@ScriptDir & '\bass.dll', $wkdir & '\bass.dll', 1)
	FileCopy(@ScriptDir & '\bck0.png', $wkdir & '\bck0.png', 1)
	FileCopy(@ScriptDir & '\chk.ico', $wkdir & '\chk.ico', 1)
	FileCopy(@ScriptDir & '\unchk.ico', $wkdir & '\unchk.ico', 1)
	FileCopy(@ScriptDir & '\rd.ico', $wkdir & '\rd.ico', 1)
	FileCopy(@ScriptDir & '\unrd.ico', $wkdir & '\unrd.ico', 1)
	FileCopy(@ScriptDir & '\7za.exe', $wkdir & '\7za.exe', 1)
	FileCopy(@ScriptDir & '\7za.dll', $wkdir & '\7za.dll', 1)
	FileCopy(@ScriptDir & '\7zxa.dll', $wkdir & '\7zxa.dll', 1)
	FileCopy(@ScriptDir & '\fileprjt.a3x', $wkdir & '\fileprjt.a3x', 1)
	FileCopy(@ScriptDir & '\AutoIt3.exe', $wkdir & '\AutoIt3.exe', 1)
	FileCopy($prjpath & '\rwconf.txt', $wkdir & '\rwconf.txt', 1)
	Local $nAllsizeMod
	For $i = 1 To UBound($aAllmod) - 1
		If FileExists($aAllmod[$i][1]) Then
			$asf = DirGetSize($aAllmod[$i][1], 1)
			If $asf[0] = 0 Then
				$strer &= $aAllmod[$i][1] & ' - ' & $JMPlangset[74] & @CRLF
				$ercopy = 1
			Else
				$nAllsizeMod += $asf[0]
			EndIf
		Else
			If StringInStr($aAllmod[$i][1], '\') Then
				$strer &= $aAllmod[$i][1] & ' - ' & $JMPlangset[75] & @CRLF
				$ercopy = 1
			EndIf
		EndIf
		If FileExists($aAllmod[$i][2]) Then
			FileCopy($aAllmod[$i][2], $wkdir & '\' & $aAllmod[$i][0] & StringRight($aAllmod[$i][2], 4), 1)
		Else
			If Not (String($aAllmod[$i][2]) == '0') Then
				$strer &= $aAllmod[$i][2] & ' - ' & $JMPlangset[76] & @CRLF
				$ercopy = 1
			EndIf
		EndIf
		If FileExists($aAllmod[$i][3]) Then
			FileCopy($aAllmod[$i][3], $wkdir & '\' & $aAllmod[$i][0] & StringRight($aAllmod[$i][3], 4), 1)
		Else
			If Not (String($aAllmod[$i][3]) == '0') Then
				$strer &= $aAllmod[$i][3] & ' - ' & $JMPlangset[76] & @CRLF
				$ercopy = 1
			EndIf
		EndIf
		If FileExists($aAllmod[$i][4]) Then
			FileCopy($aAllmod[$i][4], $wkdir & '\' & $aAllmod[$i][0] & StringRight($aAllmod[$i][4], 4), 1)
		Else
			If Not (String($aAllmod[$i][4]) == '0') Then
				$strer &= $aAllmod[$i][4] & ' - ' & $JMPlangset[76] & @CRLF
				$ercopy = 1
			EndIf
		EndIf
	Next
	For $i = 1 To UBound($reswin) - 1
		If FileExists($reswin[$i]) Then
			FileCopy($reswin[$i], $wkdir & '\' & StringRegExpReplace($reswin[$i], '.*\\', ''), 1)
		Else
			If Not (String($reswin[$i]) == '0') Then
				$strer &= $reswin[$i] & ' - ' & $JMPlangset[77] & @CRLF
				$ercopy = 1
			EndIf
		EndIf
	Next
	If $flsetparam Then
		If Not FileCopy(@ScriptDir & '\unmod.a3x', $wkdir & '\unmod.a3x', 1) Then
			$ercopy = 1
			$strer &= $JMPlangset[78] & @CRLF
		Else
			FileCopy($aDesignPath[4][1], $wkdir & '\unmod.png', 1)
			If FileExists($aDesignPath[5][1]) Then
				FileCopy($aDesignPath[5][1], $wkdir & '\uninst.ico', 1)
			Else
				FileCopy(@ScriptDir & '\uninst.ico', $wkdir & '\uninst.ico', 1)
			EndIf
		EndIf
	EndIf
	If $ercopy Then
		Local $fo = FileOpen($errorlist, 1)
		FileWrite($fo, _NowCalc() & @CRLF & $strer)
		FileClose($fo)
		GUIDelete($hGG)
		Return SetError(1)
	EndIf
	IniWriteSection($wkdir & '\page0.jmp3', 'size', 'size=' & $nAllsizeMod)
	GUIDelete($hGG)
EndFunc   ;==>_COPYRES

Func _GetInfoModTV()
	Local $aInfSetMod, $drgs
	Local $infpg = _GUITreeViewEx_GetItemsTVX()
	For $pg In $infpg
		$aInfSetMod = _GUITreeViewEx_GetItemData($g_GTVEx_aTVData, $pg)
		If @error Then ContinueLoop
		Local $adstrar = ''
		$adstrar &= $aInfSetMod[14] & '|' & $aInfSetMod[18] & '|' & $aInfSetMod[19] & '|' & $aInfSetMod[20] & '|' & $aInfSetMod[21]
		_ArrayAdd($aAllmod, $adstrar)
	Next
EndFunc   ;==>_GetInfoModTV

Func _GetInfoMod()
	Local $itmod, $gtm, $objc1, $drgs, $aGetObj
	Local $infpg = $oSNW.Keys()
	For $pg In $infpg
		$aGetObj = $OSNW.Item($pg)
		$objc1 = $aGetObj[1]
		$gtm = $objc1.Keys()
		If Not IsArray($gtm) Then ContinueLoop
		For $i In $gtm
			$itmod = $objc1.Item($i)
			Switch String($itmod[0])
				Case 'mod'
					Local $adstrar = ''
					$adstrar &= $itmod[14] & '|' & $itmod[18] & '|' & $itmod[19] & '|' & $itmod[20] & '|' & $itmod[21]
					_ArrayAdd($aAllmod, $adstrar)
				Case Else
					If Not (String($itmod[14]) == 'pic') And Not (String($itmod[14]) == 'perc') Then
						_ArrayAdd($reswin, $itmod[12])
					EndIf
			EndSwitch
		Next
	Next

EndFunc   ;==>_GetInfoMod

Func _INFC()
	Local $aPage = _FFSearch($prjpath, 'jmp3', 3, 1, 2)
	If Not @error Then
		If FileExists($wkdir) Then DirRemove($wkdir, 1)
		DirCreate($wkdir)
		For $i = 0 To UBound($aPage) - 1
			_PreComp($aPage[$i], $wkdir & '\page' & $i & '.jmp3', 'Windows')
			_PreComp($aPage[$i], $wkdir & '\page' & $i & '.jmp3', 'Controls')
			If $g_GTVEx_aTVData Then _PreCompTV($aPage[$i], $wkdir & '\page' & $i & '.jmp3')
		Next
	Else
		MsgBox(16, '', $JMPlangset[79], 0, $WOTP)
		Return SetError(1)
	EndIf
EndFunc   ;==>_INFC

Func _PreComp($sSPf, $sPthcg, $sSct)
	Local $agtpm = IniReadSection($sSPf, $sSct)
	If @error Then Return SetError(1)
	Local $aspl
	For $i = 1 To $agtpm[0][0]
		$aspl = StringSplit($agtpm[$i][1], '<>', 3)
		For $exp = 0 To UBound($aspl) - 1
			If FileExists($aspl[$exp]) Then $aspl[$exp] = StringRegExpReplace($aspl[$exp], '.*\\', '')
		Next
		$agtpm[$i][1] = _ArrayToString($aspl, '<>')
	Next
	IniWriteSection($sPthcg, $sSct, $agtpm)
EndFunc   ;==>_PreComp

Func _PreCompTV($sSPf, $sPthcg)
	Local $agtpm = IniRead($sSPf, 'TV', 'TV', '')
	If Not $agtpm Then Return SetError(1)
	Local $aspl = StringSplit($agtpm, '<>', 3)
	For $exp = 0 To UBound($aspl) - 1
		If FileExists($aspl[$exp]) Then $aspl[$exp] = StringRegExpReplace($aspl[$exp], '.*\\', '')
	Next
	$agtpm = _ArrayToString($aspl, '<>')
	IniWrite($sPthcg, 'TV', 'TV', $agtpm)
EndFunc   ;==>_PreCompTV

Func _COMPPR()
	$mmcr = 0
	If FileExists($prjpath) Then
		Local $aGetObj = $OSNW.Item('page0')
		Local $oWot = $aGetObj[0]
		Local $gttpg = $oWot.Item(0)
		If Not StringInStr(String($gttpg[8]), '|') Then Return MsgBox(16, $JMPlangset[80], $JMPlangset[81], 0, $WOTP)
		_SavePJT($prjpath)
		If @error Then Return MsgBox(16, @error, $JMPlangset[55], 0, $WOTP)
		_INFC()
		If @error Then
			DirRemove($wkdir, 1)
			Return SetError(-1)
		EndIf
	Else
		MsgBox(16, '', $JMPlangset[82] & @CRLF & $JMPlangset[83], 0, $WOTP)
		Return SetError(4)
	EndIf
	Dim $aAllmod[1][5]
	Dim $reswin[1]
	Dim $aINFCTRL[26]
	_GetInfoMod()
	If $g_GTVEx_aTVData Then _GetInfoModTV()
	_COPYRES()
	If @error Then
		MsgBox(16, '', $JMPlangset[84] & @CRLF & $JMPlangset[85], 0, $WOTP)
		DirRemove($wkdir, 1)
		Return
	EndIf
	_WINPACK()
EndFunc   ;==>_COMPPR

Func _GLPR($hWndP, $sStrInf = '')
	Local $sFile = @ScriptDir & '\load.gif'
	$hGG = GUICreate("", 150, 150, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST), $hWndP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $hGG)
	GUISetBkColor(345)
	$hgif = _GUICtrlCreateGIF($sFile, "", 0, 0, 150, 150)
	If @error Then
		_GIF_DeleteGIF($hgif)
		GUIDelete($hGG)
		Return SetError(1)
	EndIf
	_WinAPI_SetLayeredWindowAttributes($hGG, 345, 255)
	Local $posF = WinGetPos($hGG)
	Local $LForm = GUICreate('', 250, 35, $posF[0] - 50, $posF[1] + 57, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST), $hGG)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $LForm)
	GUISetBkColor(345)
	$LLoadInfprj = GUICtrlCreateLabel($sStrInf, 0, 0, 250, 35, 0x01)
	GUICtrlSetFont(-1, 16, 800, 0, "Georgia")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	_WinAPI_SetLayeredWindowAttributes($LForm, 345, 255)
	GUISetState(@SW_SHOW, $hGG)
	GUISetState(@SW_SHOW, $LForm)
EndFunc   ;==>_GLPR

Func _Middle($win, $wd, $ht)
	Local $y = (@DesktopHeight / 2) - ($ht / 2)
	Local $x = (@DesktopWidth / 2) - ($wd / 2)
	WinMove($win, '', $x, $y, $wd, $ht)
EndFunc   ;==>_Middle

Func _ResetVariable()
	DllStructSetData($t_Data, 8, '')
	$prjpath = ''
	DllStructSetData($t_Data, 9, '')
	$iPercData = 0
	$iPercId = 0
	$hHBmp_BG = 0
	$WPerc = 0
	$HPerc = 0
	$BgColorGui = 0x000000
	$FgBGColor = 0x808080
	$BGColor = 0x0000FF
	$TextBGColor = 0xFFFFFF
	$sFontProgress = 'Arial'
	$iVisPerc = 1
	$fldesgproc = 0
	$GuiPercD = 0
	$TpBar = 0
	$SelectProgressbar = 'barS'
	Dim $aAllmod[1][5]
	Dim $reswin[1]
	Dim $aINFCTRL[26]
	For $i = 0 To 5
		$aDesignPath[$i][1] = ''
	Next
	For $i = 0 To 10
		$aSetISS[$i][1] = ''
	Next
	$mmcr = 0
	$flsize = 1
	If $g_GTVEx_aTVData Then _GUITreeViewEx_DeleteTVX()
	Local $dlpg = $OSNW.Keys()
	Local $delctrl, $dlobj, $objcd
	For $ks In $dlpg
		$dlobj = $OSNW.Item($ks)
		$objcd = $dlobj[1]
		$delctrl = $objcd.Keys()
		For $k In $delctrl
			GUICtrlDelete($k)
		Next
	Next
	$OSNW.RemoveAll()
	$oMod.RemoveAll()
EndFunc   ;==>_ResetVariable

Func _NEWPR()
	_ResetVariable()
	$CurGui = 0
	_PageCreate($OSNW, 'page0')
	Local $aGetObj = $OSNW.Item('page0')
	$objw = $aGetObj[0]
	$objc = $aGetObj[1]
	_Middle($WOTP, 615, 462)
	Local $posw = WinGetPos($WOTP)
	GUISetBkColor(0x808080, $WOTP)
	Dim $aINFPG[11]
	$aINFPG[0] = $posw[0]
	$aINFPG[1] = $posw[1]
	$aINFPG[2] = 615
	$aINFPG[3] = 462
	$aINFPG[4] = 0x808080
	$aINFPG[5] = 1 ; деинсталятор. 1- да, 0 - нет
	$aINFPG[6] = 0 ; путь к фоновому звуку
	$aINFPG[7] = 0 ;название игры
	$aINFPG[8] = 0 ; номер патча
	$aINFPG[9] = 0 ; подсветка управляющих элементов
	$aINFPG[10] = 0
	$objw.Add(0, $aINFPG)
	_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
EndFunc   ;==>_NEWPR

Func _LOADPJT($ldpjt)
	Local $agta, $gtprc, $erctrl = '', $bckl, $transcolor
	Local $medit, $aGetObj, $rdw, $gtau, $rdc, $gf, $sNewPathF, $getp, $sExtF
	If $ldpjt == @ScriptDir Then
		_GIF_DeleteGIF($hgif)
		GUIDelete($hGG)
		MsgBox(16, '-1', $JMPlangset[86], 0, $WOTP)
		Return SetError(1)
	EndIf
	Local $aPage = _FFSearch($ldpjt, 'jmp3', 3, 1, 2)
	If @error Then
		_GIF_DeleteGIF($hgif)
		GUIDelete($hGG)
		MsgBox(16, '1', $JMPlangset[79], 0, $WOTP)
		Return SetError(1)
	EndIf
	_ResetVariable()
	For $i = 0 To UBound($aPage) - 1
		If Not FileExists($ldpjt & '\page' & $i & '.jmp3') Then
			_GIF_DeleteGIF($hgif)
			GUIDelete($hGG)
			MsgBox(16, '', $JMPlangset[87] & ' page' & $i & '.jmp3 ' & $JMPlangset[88], 0, $WOTP)
			Return SetError(2)
		EndIf
		_PageCreate($OSNW, 'page' & $i)
		$aGetObj = $OSNW.Item('page' & $i)
		$objw = $aGetObj[0]
		$objc = $aGetObj[1]
		$rdw = IniReadSection($ldpjt & '\page' & $i & '.jmp3', 'Windows')
		If Not @error Then
			For $r = 1 To $rdw[0][0]
				$agta = StringSplit($rdw[$r][1], '<>', 3)
				If UBound($agta) <> 11 Then
					$erctrl &= 'page' & $i & '.jmp3' & @CRLF & $JMPlangset[89] & ': ' & $rdw[$r][0] & ' - ' & $JMPlangset[90] & @CRLF
					ContinueLoop
				EndIf
				For $cw = 0 To 4
					$agta[$cw] = Number($agta[$cw])
				Next
				$objw.Add(Number($rdw[$r][0]), $agta)
			Next
		Else
			$erctrl &= 'page' & $i & '.jmp3 - ' & $JMPlangset[91] & @CRLF
		EndIf
		If $i = 0 Then
			$gtau = $objw.Item(0)
			$flsetparam = Number($gtau[5])
			If $flsetparam Then
				ControlCommand(DllStructGetData($t_Data, 6), '', 26, 'Check', '')
			Else
				ControlCommand(DllStructGetData($t_Data, 6), '', 27, 'Check', '')
			EndIf
			$chgame = $gtau[7]
			If $chgame = 'Wargaming' Then
				ControlCommand(DllStructGetData($t_Data, 6), '', 22, 'Check', '')
			ElseIf $chgame = 'Lesta' Then
				ControlCommand(DllStructGetData($t_Data, 6), '', 23, 'Check', '')
			EndIf
			$bckl = Number($gtau[9])
			Switch $bckl
				Case 0
					ControlCommand(DllStructGetData($t_Data, 6), '', 17, 'Check', '')
				Case 1
					ControlCommand(DllStructGetData($t_Data, 6), '', 18, 'Check', '')
				Case 2
					ControlCommand(DllStructGetData($t_Data, 6), '', 19, 'Check', '')
				Case 3
					ControlCommand(DllStructGetData($t_Data, 6), '', 20, 'Check', '')
			EndSwitch
			GUISetBkColor($gtau[4], $WOTP)
		EndIf
		$rdc = IniReadSection($ldpjt & '\page' & $i & '.jmp3', 'Controls')
		If Not @error Then
			For $c = 1 To $rdc[0][0]
				$agta = StringSplit($rdc[$c][1], '<>', 3)
				If UBound($agta) <> 26 Then
					$erctrl &= 'page' & $i & '.jmp3 - ' & $JMPlangset[89] & ' - ' & $rdc[$c][0] & ', ' & $JMPlangset[92] & @CRLF
					ContinueLoop
				EndIf
				$agta[2] = Number($agta[2])
				$agta[3] = Number($agta[3])
				$agta[4] = Number($agta[4])
				$agta[5] = Number($agta[5])
				$agta[6] = Number($agta[6])
				$agta[7] = Number($agta[7])
				$agta[9] = Number($agta[9])
				$agta[10] = Number($agta[10])
				$agta[11] = Number($agta[11])
				If String($agta[12]) == '0' Then
					$agta[12] = 0
				Else
					If Not (String($agta[0]) == 'progress') Then
						If Not FileExists($agta[12]) Then
							$getp = StringInStr($agta[12], '.', 0, -1)
							$sExtF = StringTrimLeft($agta[12], $getp)
							$sNewPathF = FileOpenDialog($JMPlangset[93] & ' - ' & $agta[12], '', '(*.' & $sExtF & ')', 0, '', $hGG)
							If @error Then
								_GIF_DeleteGIF($hgif)
								GUIDelete($hGG)
								Return SetError(2)
							Else
								$agta[12] = $sNewPathF
							EndIf
						EndIf
					EndIf
				EndIf
				$agta[13] = Number($agta[13])
				Switch String($agta[0])
					Case 'mod'
						$agta[14] = Number($agta[14])
					Case Else
						Switch String($agta[14])
							Case '0'
								$agta[14] = 0
							Case 'chpage'
								$agta[15] = Number($agta[15])
						EndSwitch
				EndSwitch
				If $agta[16] == '0' Then $agta[16] = 0
				$agta[17] = Number($agta[17])
				If $agta[18] == '0' Then $agta[18] = 0 ; путь к моду
				If $agta[19] == '0' Then $agta[19] = 0 ; путь к картинке мода
				If $agta[20] == '0' Then $agta[20] = 0 ; путь к звуку мода
				If $agta[21] == '0' Then $agta[21] = 0 ; путь к шрифту мода
				If $agta[22] == '0' Then $agta[22] = 0 ; описание мода
				$agta[23] = Number($agta[23])
				$agta[25] = Number($agta[25])
				Local $funcid
				Switch String($agta[0])
					Case 'treeview'
						$funcid = GUICtrlCreateTreeView($agta[2], $agta[3], $agta[4], $agta[5], $agta[6])
;~ 						DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
						Local $aIco[4] = [@ScriptDir & '\chk.ico', @ScriptDir & '\unchk.ico', @ScriptDir & '\rd.ico', @ScriptDir & '\unrd.ico']
						_GUITreeViewEx_InitTV($funcid)
						_GUITreeViewEx_TvImg($funcid, $aIco)
						_GUITreeViewEx_LoadTV($funcid, $ldpjt & '\page' & $agta[1] & '.jmp3', 'TV', 'TV')
						GUICtrlSetColor($funcid, $agta[10])
						GUICtrlSetBkColor($funcid, $agta[11])
						_WinAPI_RedrawWindow($WOTP)
						_WinAPI_UpdateWindow($WOTP)
					Case 'label'
						$funcid = GUICtrlCreateLabel('', $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
						DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
						$medit = StringReplace($agta[1], '\n', @CRLF)
						$medit = StringReplace($medit, '\h', ' ')
						GUICtrlSetData($funcid, $medit)
						If $agta[14] == 'txt' Then $oMod.Add('txt' & $i, $funcid)
						If $agta[14] == 'info' Then $oMod.Add('info' & $i, $funcid)
						If $agta[14] == 'path' Then $oMod.Add('path', $funcid)
						GUICtrlSetColor($funcid, $agta[10])
						GUICtrlSetBkColor($funcid, $agta[11])
					Case 'mod'
						$agta[15] = Number($agta[15])
						If $agta[15] Then
							Local $gettp = $oMod.Item($agta[15])
							$gettp = $objc.Item($gettp)
							If $gettp[17] Then
								$funcid = GUICtrlCreateRadio($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
								DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
								If StringRight($gettp[16], StringLen($agta[14])) = $agta[14] Then GUIStartGroup()
							Else
								$funcid = GUICtrlCreateCheckbox($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
								DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
								If StringRight($gettp[16], StringLen($agta[14])) = $agta[14] Then GUIStartGroup()
								If $agta[17] Then GUIStartGroup()
							EndIf
						Else
							$funcid = GUICtrlCreateCheckbox($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
							DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
							If $agta[17] Then GUIStartGroup()
						EndIf
						$oMod.Add(Number($agta[14]), $funcid)
						GUICtrlSetState($funcid, $agta[23])
						If $agta[25] Then GUICtrlSetState($funcid, $agta[25])
						$medit = StringReplace($agta[1], '\n', @CRLF)
						$medit = StringReplace($medit, '\h', ' ')
						GUICtrlSetData($funcid, $medit)
						GUICtrlSetColor($funcid, $agta[10])
						GUICtrlSetBkColor($funcid, $agta[11])
					Case 'pic'
						If FileExists($agta[12]) Then
							$funcid = GUICtrlCreatePic('', $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
;~ 							DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
							_SetImage($funcid, $agta[12], $agta[4], $agta[5], -1) ;GUICtrlSetImage($funcid, $agta[12])
							GUICtrlSetPos($funcid, $agta[2], $agta[3], $agta[4], $agta[5])
						EndIf
						If $agta[14] == 'pic' Then $oMod.Add('pic' & $i, $funcid)
					Case 'checkbox'
						$funcid = GUICtrlCreateCheckbox($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
						DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
						If Not ($agta[15] == '0') Then GUICtrlSetState($funcid, Number($agta[15]))
						If $agta[25] Then GUICtrlSetState($funcid, $agta[25])
						$medit = StringReplace($agta[1], '\n', @CRLF)
						$medit = StringReplace($medit, '\h', ' ')
						GUICtrlSetData($funcid, $medit)
						GUICtrlSetColor($funcid, $agta[10])
						GUICtrlSetBkColor($funcid, $agta[11])
					Case 'progress'
						$funcid = GUICtrlCreateProgress($agta[2], $agta[3], $agta[4], $agta[5])
						Switch $agta[24]
							Case 'barSC', 'barA'
								DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
						EndSwitch
						GUICtrlSetData($funcid, 50)
						GUICtrlSetColor($funcid, $agta[11])
						GUICtrlSetBkColor($funcid, $agta[10])
						$WPerc = $agta[4]
						$HPerc = $agta[5]
						$BgColorGui = $agta[10]
						$FgBGColor = $agta[11]
						$BGColor = Number($agta[12])
						$TextBGColor = $agta[7]
						$sFontProgress = $agta[8]
						$iVisPerc = $agta[6]
				EndSwitch
				If Not $funcid Then ContinueLoop
				$gf = StringSplit($agta[8], '!')
				If $gf[0] > 1 Then GUICtrlSetFont($funcid, $gf[1], $gf[2], $gf[3], $gf[4])
				GUICtrlSetResizing($funcid, $agta[13])
				Switch String($agta[14])
					Case 'backauset', 'ausetmod'
						If $oMod.Exists($agta[14]) Then
							$gtprc = $oMod.Item($agta[14])
							_ArrayAdd($gtprc, $funcid)
							$oMod.Item($agta[14]) = $gtprc
						Else
							Local $aperc[1] = [$funcid]
							$oMod.Add($agta[14], $aperc)
						EndIf
					Case 'perc'
						$oMod.Add('perc', $funcid)
				EndSwitch
				If $agta[9] Then GUICtrlSetState($funcid, $agta[9])
				If $i > 0 Then GUICtrlSetState($funcid, $GUI_HIDE)
				$objc.Add($funcid, $agta)
			Next
		EndIf
	Next
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
	_Middle($WOTP, $gtau[2], $gtau[3])
	If $erctrl <> '' Then
		Local $fo = FileOpen($errorlist, 1)
		If $erctrl <> '' Then FileWrite($fo, _NowCalc() & @CRLF & $JMPlangset[94] & @CRLF & $erctrl)
		FileClose($fo)
		_GIF_DeleteGIF($hgif)
		GUIDelete($hGG)
		MsgBox(16, '', $JMPlangset[95] & @CRLF & $JMPlangset[96], 0, $WOTP)
		Return SetError(3)
	EndIf
	DllStructSetData($t_Data, 4, UBound($aPage))
	$CurGui = 0
	$aGetObj = $OSNW.Item('page' & $CurGui)
	$objw = $aGetObj[0]
	$objc = $aGetObj[1]
	$prjpath = $ldpjt
	Local $RresInf = IniReadSection($prjpath & '\DesignPjt.res', 'DesignPjt')
	If Not @error Then
		If UBound($RresInf) = 7 Then
			For $i = 1 To 6
				$aDesignPath[$i - 1][1] = $RresInf[$i][1]
			Next
		EndIf
	EndIf
	Local $GetIssConf = IniReadSection($prjpath & '\fileinf.ini', 'Property')
	If Not @error Then
		If UBound($GetIssConf) = 12 Then
			For $i = 1 To 11
				$aSetISS[$i - 1][1] = $GetIssConf[$i][1]
			Next
		EndIf
	EndIf
	_GIF_DeleteGIF($hgif)
	GUIDelete($hGG)
	_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
EndFunc   ;==>_LOADPJT

Func WM_MOUSEWHEEL($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $lParam
	If $flcoord Then Return $GUI_RUNDEFMSG
	Local $idclk
	Local $GCC = GUIGetCursorInfo($WOTP)
	$cx = $GCC[0]
	$cy = $GCC[1]
	If $GCC[4] Then $idclk = $GCC[4]
	Local $posid
	Local $ispress = _IsPressed('12', $hDLL)
	Local $wh = BitAND($wParam, 0xFFFF)
	Switch BitShift($wParam, 16)
		Case 120
			If $idclk > 0 Then
				$posid = $objc.Item($idclk)
				If $wh = 8 And $ispress = False Then
					GUICtrlSetPos($idclk, $posid[2], $posid[3], $posid[4] + 5, $posid[5])
					$posid[4] = $posid[4] + 5
					$objc.Item($idclk) = $posid
					_INFOCTRL()
				ElseIf $wh = 4 And $ispress = False Then
					GUICtrlSetPos($idclk, $posid[2], $posid[3], $posid[4], $posid[5] + 5)
					$posid[5] = $posid[5] + 5
					$objc.Item($idclk) = $posid
					_INFOCTRL()
				EndIf
			EndIf
			$mmcr = 0
		Case -120
			If $idclk > 0 Then
				$posid = $objc.Item($idclk)
				If $wh = 8 And $ispress = False Then
					If $posid[4] = 5 Then Return $GUI_RUNDEFMSG
					GUICtrlSetPos($idclk, $posid[2], $posid[3], $posid[4] - 5, $posid[5])
					$posid[4] = $posid[4] - 5
					$objc.Item($idclk) = $posid
					_INFOCTRL()
				ElseIf $wh = 4 And $ispress = False Then
					If $posid[5] = 5 Then Return $GUI_RUNDEFMSG
					GUICtrlSetPos($idclk, $posid[2], $posid[3], $posid[4], $posid[5] - 5)
					$posid[5] = $posid[5] - 5
					$objc.Item($idclk) = $posid
					_INFOCTRL()
				EndIf
			EndIf
			$mmcr = 0
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOUSEWHEEL

Func _GETCHNIT(ByRef $idfr, $idcur, $count, $objcsv)
	Local $dltit = $objcsv.Item($idcur)
	If String($dltit[16]) == '0' And String($dltit[15]) == '0' Then
		_ArrayAdd($idfr, $count & '|' & _ArrayToString($dltit, '<>'))
		Return
	ElseIf Not (String($dltit[16]) == '0') And String($dltit[15]) == '0' Then
		_ArrayAdd($idfr, $count & '|' & _ArrayToString($dltit, '<>'))
		_FDNEXT($idfr, $dltit[16], $count, $objcsv)
		Return
	ElseIf Not (String($dltit[15]) == '0') And Not (String($dltit[16]) == '0') Then
		_FDNEXT($idfr, $dltit[16], $count, $objcsv)
		Return
	EndIf
EndFunc   ;==>_GETCHNIT

Func _FDNEXT(ByRef $aIt, $prit, $cnt, $objcsv)
	Local $dlid, $gtdt
	Local $gtchl = StringSplit($prit, '#')
	For $i = 1 To $gtchl[0]
		$dlid = $oMod.Item(Number($gtchl[$i]))
		$gtdt = $objcsv.Item($dlid)
		_ArrayAdd($aIt, $cnt & '|' & _ArrayToString($gtdt, '<>'))
	Next
EndFunc   ;==>_FDNEXT

Func _SETBCK(ByRef $adis)
	If UBound($adis) = 0 Then Return
	Local $gtdis, $ipr, $tmpstr
	Local $ksgt = $objw.Item(0)
	For $i = 0 To UBound($adis) - 1
		StringReplace($adis[$i][1], '<>0<>0<>' & $ksgt[2] & '<>' & $ksgt[3] & '<>', '')
		If @extended = 1 Then
			If $i = 0 Then
				Return
			Else
				$gtdis = $i
				$tmpstr = $adis[$i][1]
				ExitLoop
			EndIf
		EndIf
	Next
	If $gtdis Then
		$ipr = $adis[0][1]
		$adis[0][1] = $tmpstr
		$adis[$gtdis][1] = $ipr
	EndIf
EndFunc   ;==>_SETBCK

Func _SavePJT($sPath)
	$mmcr = 0
	If $sPath == @ScriptDir Then Return SetError(-1)
	Local $aPage = _FFSearch($sPath, 'jmp3', 3, 1, 2)
	For $i = 0 To UBound($aPage) - 1
		FileMove($aPage[$i], $aPage[$i] & 'del', 1)
	Next
	Local $wrs, $wrd, $aGetObj, $objwsv, $objcsv
	Local $itpg = $OSNW.Keys()
	For $p = 0 To UBound($itpg) - 1
		$aGetObj = $OSNW.Item($itpg[$p])
		$objwsv = $aGetObj[0]
		$objcsv = $aGetObj[1]
		Local $gtitm
		Local $ksgt = $objwsv.Keys()
		$wrs = IniWriteSection($sPath & '\' & $itpg[$p] & '.jmp3', 'Windows', '')
		If Not $wrs Then Return SetError(1)
		For $i = 0 To UBound($ksgt) - 1
			$gtitm = $objwsv.Item($ksgt[$i])
			$wrd = IniWrite($sPath & '\' & $itpg[$p] & '.jmp3', 'Windows', $ksgt[$i], _ArrayToString($gtitm, '<>'))
			If Not $wrd Then Return SetError(2)
		Next
		$wrs = IniWriteSection($sPath & '\' & $itpg[$p] & '.jmp3', 'Controls', '')
		If Not $wrs Then Return SetError(3)
		Local $sortmod[0][2], $sortdis[0][2], $sortothers[0][2], $allctrl[0][2], $picdis[0][2]
		Local $ksgtc = $objcsv.Keys()
		For $i = 0 To UBound($ksgtc) - 1
			$gtitm = $objcsv.Item($ksgtc[$i])
			If $gtitm[0] == 'mod' Then
				_GETCHNIT($sortmod, $ksgtc[$i], $i, $objcsv)
			ElseIf $gtitm[0] == 'treeview' Then
				_GUITreeViewEx_SaveTV($ksgtc[$i], $sPath & '\page' & $gtitm[1] & '.jmp3', 'TV', 'TV')
				_ArrayAdd($sortmod, $i & '|' & _ArrayToString($gtitm, '<>'))
			Else
				If $gtitm[9] = 128 Then
					If $gtitm[0] == 'pic' Then
						_ArrayAdd($picdis, $i & '|' & _ArrayToString($gtitm, '<>'))
					Else
						_ArrayAdd($sortdis, $i & '|' & _ArrayToString($gtitm, '<>'))
					EndIf
				Else
					_ArrayAdd($sortothers, $i & '|' & _ArrayToString($gtitm, '<>'))
				EndIf
			EndIf
		Next
		_SETBCK($picdis)
		If UBound($picdis) <> 0 Then _ArrayConcatenate($allctrl, $picdis)
		If UBound($sortdis) <> 0 Then _ArrayConcatenate($allctrl, $sortdis)
		If UBound($sortothers) <> 0 Then _ArrayConcatenate($allctrl, $sortothers)
		If UBound($sortmod) <> 0 Then _ArrayConcatenate($allctrl, $sortmod)
		If UBound($allctrl) <> 0 Then
			For $s = 0 To UBound($allctrl) - 1
				$allctrl[$s][0] = $s
			Next
			$wrd = IniWriteSection($sPath & '\' & $itpg[$p] & '.jmp3', 'Controls', $allctrl, 0)
			If Not $wrd Then Return SetError(4)
		EndIf
	Next
	For $i = 0 To UBound($aPage) - 1
		FileDelete($aPage[$i] & 'del')
	Next
	IniWriteSection($sPath & '\DesignPjt.res', 'DesignPjt', $aDesignPath, 0)
	IniWriteSection($sPath & '\fileinf.ini', 'Property', $aSetISS, 0)
EndFunc   ;==>_SavePJT

Func _CHT()
	GUIRegisterMsg($WM_SETCURSOR, '')
	GUIRegisterMsg($WM_MOUSEWHEEL, '')
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $txtdata
	Local $curwgp = WinGetPos($WOTP)
	$WCHT = GUICreate($JMPlangset[97], $curwgp[2] - 45, 150, @DesktopWidth / 3.05, @DesktopHeight / 4 - 185, $WS_THICKFRAME, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $WCHT)
	GUISetBkColor(0x808080)
	Local $kyid, $getfont
	If $objc.Exists($tID) Then
		$kyid = $objc.Item($tID)
		Local $gtx
		Switch String($kyid[0])
			Case 'checkbox', 'mod'
				$gtx = _GUICtrlButton_GetText
			Case 'label'
				$gtx = GUICtrlRead
		EndSwitch
		$CHT = GUICtrlCreateEdit($gtx($tID), 5, 5, $curwgp[2] - 55, 110, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_AUTOVSCROLL), $WS_EX_CLIENTEDGE)
		$getfont = StringSplit($kyid[8], '!')
	EndIf
	GUICtrlSetFont($CHT, $getfont[1], $getfont[2], $getfont[3], $getfont[4])
	GUICtrlSetResizing($CHT, BitOR($GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKBOTTOM))
	GUISetState(@SW_SHOW, $WCHT)
	Local $Msg, $osp
	While 1
		If Not WinExists(DllStructGetData($t_Data, 6)) Then Exit
		If $flch Then
			GUICtrlSetData($tID, StringReplace(StringRegExpReplace(GUICtrlRead($CHT), '[*~|#><]', ' '), '\', ''))
			$flch = 0
		EndIf
		$Msg = GUIGetMsg()
		Switch $Msg
			Case -3
				If $objc.Exists($tID) Then
					$osp = $objc.Item($tID)
					$txtdata = StringReplace(StringRegExpReplace(GUICtrlRead($CHT), '[*~|#><]', ' '), '\', '')
					$txtdata = StringReplace($txtdata, @CRLF, '\n')
					$txtdata = StringReplace($txtdata, ' ', '\h')
					$osp[1] = $txtdata
					$objc.Item($tID) = $osp
					GUIDelete($WCHT)
					GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
					GUIRegisterMsg($WM_MOUSEWHEEL, 'WM_MOUSEWHEEL')
					Opt("GUIOnEventMode", 1)
					Opt('GUICloseOnESC', 0)
					$WCHT = ''
					$CHT = ''
					_INFOCTRL($tID)
				EndIf
				WinActivate($WOTP)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_CHT

Func _RSZW()
	_CLOSEREG()
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $idwh = $objw.Item(0)
	Local $FSZ = GUICreate('', 215, 145, -1, -1, -1, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $FSZ)
	GUISetBkColor(0x808080)
	GUISetFont(9, 400, 0, 'Georgia', $FSZ)
	Local $LWID = GUICtrlCreateLabel($JMPlangset[63], 16, 8, 180, 17)
	Local $IWID = GUICtrlCreateInput($idwh[2], 16, 40, 121, 21, $ES_NUMBER)
	Local $LHID = GUICtrlCreateLabel($JMPlangset[64], 16, 72, 180, 17)
	Local $IHID = GUICtrlCreateInput($idwh[3], 16, 104, 121, 21, $ES_NUMBER)
	GUISetState(@SW_SHOW, $FSZ)
	While 1
		If Not WinExists(DllStructGetData($t_Data, 6)) Then Exit
		Switch GUIGetMsg()
			Case -3
				Local $RW = Number(GUICtrlRead($IWID))
				Local $RH = Number(GUICtrlRead($IHID))
				GUIDelete($FSZ)
				_REGMSG()
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				If $RW <> 0 Or $RH <> 0 Then
					If $RW Then $idwh[2] = $RW
					If $RH Then $idwh[3] = $RH
					$objw.Item(0) = $idwh
					WinMove($WOTP, '', $idwh[0], $idwh[1], $idwh[2], $idwh[3])
					_Middle($WOTP, $idwh[2], $idwh[3])
				EndIf
				WinActivate($WOTP)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_RSZW

Func _InfForISS($hPHandle)
	Local $InputIss[11]
	Local $InfForISS = GUICreate('InfForISS', 530, 585, -1, -1, -1, $WS_EX_TOOLWINDOW, $hPHandle)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $InfForISS)
	GUISetBkColor(0x808080)
	GUISetFont(10, 400, 0, 'Georgia', $InfForISS)
	Local $Label1 = GUICtrlCreateLabel($JMPlangset[98], 16, 3, 200, 17)
	$InputIss[0] = GUICtrlCreateInput('', 16, 24, 500, 25)
	Local $Label2 = GUICtrlCreateLabel($JMPlangset[99], 16, 68, 300, 17)
	$InputIss[1] = GUICtrlCreateInput('', 16, 92, 500, 25)
	Local $Button1 = GUICtrlCreateButton($JMPlangset[100], 440, 65, 75, 25)
	Local $Label3 = GUICtrlCreateLabel($JMPlangset[101], 16, 133, 200, 17)
	$InputIss[2] = GUICtrlCreateInput('', 16, 160, 500, 25)
	Local $Button2 = GUICtrlCreateButton($JMPlangset[100], 440, 132, 75, 25)
	Local $Label4 = GUICtrlCreateLabel($JMPlangset[102], 16, 203, 200, 17)
	$InputIss[3] = GUICtrlCreateInput('', 16, 232, 500, 25)
	Local $Label5 = GUICtrlCreateLabel($JMPlangset[103], 16, 269, 200, 17)
	$InputIss[4] = GUICtrlCreateInput('', 16, 293, 500, 25)
	Local $Label6 = GUICtrlCreateLabel($JMPlangset[104], 16, 333, 200, 17)
	$InputIss[5] = GUICtrlCreateInput('', 16, 361, 500, 25)
	Local $Label7 = GUICtrlCreateLabel($JMPlangset[105], 16, 401, 200, 17)
	$InputIss[6] = GUICtrlCreateInput('', 16, 425, 500, 25)
	Local $Label8 = GUICtrlCreateLabel($JMPlangset[106], 16, 458, 200, 17)
	$InputIss[7] = GUICtrlCreateInput('', 16, 482, 225, 25)
	Local $Label9 = GUICtrlCreateLabel($JMPlangset[107], 290, 458, 200, 17)
	$InputIss[8] = GUICtrlCreateInput('', 290, 482, 225, 25)
	Local $Label10 = GUICtrlCreateLabel($JMPlangset[108], 16, 520, 200, 17)
	$InputIss[9] = GUICtrlCreateInput('', 16, 544, 225, 25)
	Local $Label11 = GUICtrlCreateLabel($JMPlangset[109], 290, 520, 200, 17)
	$InputIss[10] = GUICtrlCreateInput('', 290, 544, 225, 25)
	GUISetState()
	For $i = 0 To 10
		GUICtrlSetData($InputIss[$i], $aSetISS[$i][1])
	Next
	Local $prjpathtmp = ''
	If FileExists($prjpath) Then
		$prjpathtmp = $prjpath
	Else
		$prjpathtmp = @ScriptDir
	EndIf
	Local $srdinfiss
	While 1
		Switch GUIGetMsg()
			Case -3
				For $i = 0 To 10
					$srdinfiss = StringStripWS(GUICtrlRead($InputIss[$i]), 3)
					If $i = 0 Then
						If ($srdinfiss = '') Then
							$aSetISS[$i][1] = 'JmpackISS'
						Else
							$aSetISS[$i][1] = $srdinfiss
						EndIf
					ElseIf $i = 1 Then
						If ($srdinfiss = '') Then
							$aSetISS[$i][1] = $prjpathtmp
						Else
							$aSetISS[$i][1] = $srdinfiss
						EndIf
					Else
						$aSetISS[$i][1] = $srdinfiss
					EndIf
				Next
				GUIDelete($InfForISS)
				WinActivate($hPHandle)
				ExitLoop
			Case $Button1
				Local $setpathinfiss = FileSelectFolder($JMPlangset[110], $prjpathtmp, 7, $prjpathtmp, $hPHandle)
				If Not @error Then GUICtrlSetData($InputIss[1], $setpathinfiss)
			Case $Button2
				Local $setpathicoiss = FileOpenDialog($JMPlangset[111], $prjpathtmp, '(*.ico)', 0, '', $hPHandle)
				If Not @error Then GUICtrlSetData($InputIss[2], $setpathicoiss)
		EndSwitch
	WEnd
EndFunc   ;==>_InfForISS

Func _DesignPjt()
	_CLOSEREG()
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $DSGPjt = GUICreate($JMPlangset[112], 620, 375, -1, -1, -1, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $DSGPjt)
	GUISetBkColor(0x808080)
	GUISetFont(10, 400, 0, 'Georgia', $DSGPjt)
	Local $Label1 = GUICtrlCreateLabel($JMPlangset[113], 16, 8, 200, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $GenCur = GUICtrlCreateInput('', 16, 32, 497, 25)
	Local $GenCurB = GUICtrlCreateButton($JMPlangset[114], 528, 32, 75, 25)
	Local $Label2 = GUICtrlCreateLabel($JMPlangset[115], 16, 63, 200, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $LtCur = GUICtrlCreateInput('', 16, 87, 497, 25)
	Local $LtCurB = GUICtrlCreateButton($JMPlangset[114], 528, 87, 75, 25)
	Local $Label3 = GUICtrlCreateLabel($JMPlangset[116], 16, 116, 200, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $BackGdAu = GUICtrlCreateInput('', 16, 140, 497, 25)
	Local $BackGdAuB = GUICtrlCreateButton($JMPlangset[114], 528, 140, 75, 25)
	Local $Label4 = GUICtrlCreateLabel($JMPlangset[117], 16, 170, 200, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $FlashST = GUICtrlCreateInput('', 16, 194, 497, 25)
	Local $FlashSTB = GUICtrlCreateButton($JMPlangset[114], 528, 194, 75, 25)
	Local $Label5 = GUICtrlCreateLabel($JMPlangset[118], 16, 226, 200, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $FlashDel = GUICtrlCreateInput('', 16, 250, 497, 25)
	Local $FlashDelB = GUICtrlCreateButton($JMPlangset[114], 528, 250, 75, 25)
	Local $Label7 = GUICtrlCreateLabel($JMPlangset[119], 16, 281, 200, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $IconDel = GUICtrlCreateInput('', 16, 305, 497, 25)
	Local $IconDelB = GUICtrlCreateButton($JMPlangset[114], 528, 305, 75, 25)
	Local $InfISSet = GUICtrlCreateButton($JMPlangset[120], 16, 340, 150, 25)
	GUISetState(@SW_SHOW, $DSGPjt)
	Local $aDesPath[6] = [$GenCur, $LtCur, $BackGdAu, $FlashST, $FlashDel, $IconDel]
	For $i = 0 To 5
		If FileExists($aDesignPath[$i][1]) Then GUICtrlSetData($aDesPath[$i], $aDesignPath[$i][1])
	Next
	Local $RDesPath, $nmsg, $GetResD
	While 1
		$nmsg = GUIGetMsg()
		Switch $nmsg
			Case -3
				For $i = 0 To 5
					$aDesignPath[$i][1] = GUICtrlRead($aDesPath[$i])
				Next
				GUIDelete($DSGPjt)
				_REGMSG()
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				WinActivate($WOTP)
				ExitLoop
			Case $GenCurB, $LtCurB
				$GetResD = FileOpenDialog($JMPlangset[121], '', '(*.cur;*.ani)', 0, '', $DSGPjt)
				If Not @error Then
					If $nmsg = $GenCurB Then
						GUICtrlSetData($GenCur, $GetResD)
					ElseIf $nmsg = $LtCurB Then
						GUICtrlSetData($LtCur, $GetResD)
					EndIf
				EndIf
			Case $BackGdAuB
				$GetResD = FileOpenDialog($JMPlangset[122], '', '(*.mp3)', 0, '', $DSGPjt)
				If Not @error Then GUICtrlSetData($BackGdAu, $GetResD)
			Case $FlashSTB, $FlashDelB
				$GetResD = FileOpenDialog($JMPlangset[123], '', '(*.png)', 0, '', $DSGPjt)
				If Not @error Then
					If $nmsg = $FlashSTB Then
						GUICtrlSetData($FlashST, $GetResD)
					ElseIf $nmsg = $FlashDelB Then
						GUICtrlSetData($FlashDel, $GetResD)
					EndIf
				EndIf
			Case $IconDelB
				$GetResD = FileOpenDialog($JMPlangset[124], '', '(*.ico)', 0, '', $DSGPjt)
				If Not @error Then GUICtrlSetData($IconDel, $GetResD)
			Case $InfISSet
				GUISetState(@SW_DISABLE, $DSGPjt)
				_InfForISS($DSGPjt)
				GUISetState(@SW_ENABLE, $DSGPjt)
		EndSwitch
	WEnd
EndFunc   ;==>_DesignPjt

Func _RSZ($ID)
	_CLOSEREG()
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $idwh
	If $objc.Exists($tID) Then $idwh = $objc.Item($ID)
	Local $FSZ = GUICreate('', 200, 205, -1, -1, -1, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $FSZ)
	GUISetBkColor(0x808080)
	GUISetFont(9, 400, 0, 'Georgia', $FSZ)
	Local $LWID = GUICtrlCreateLabel($JMPlangset[63], 16, 8, 180, 17)
	Local $IWID = GUICtrlCreateInput($idwh[4], 16, 30, 121, 21, $ES_NUMBER)
	Local $LHID = GUICtrlCreateLabel($JMPlangset[64], 16, 56, 180, 17)
	Local $IHID = GUICtrlCreateInput($idwh[5], 16, 78, 121, 21, $ES_NUMBER)
	Local $LWIDX = GUICtrlCreateLabel($JMPlangset[125], 16, 104, 180, 17)
	Local $IWIDX = GUICtrlCreateInput($idwh[2], 16, 126, 121, 21, $ES_NUMBER)
	Local $LHIDY = GUICtrlCreateLabel($JMPlangset[126], 16, 152, 180, 17)
	Local $IHIDY = GUICtrlCreateInput($idwh[3], 16, 174, 121, 21, $ES_NUMBER)
	GUISetState(@SW_SHOW, $FSZ)
	While 1
		If Not WinExists(DllStructGetData($t_Data, 6)) Then Exit
		Switch GUIGetMsg()
			Case -3
				Local $RW = Number(GUICtrlRead($IWID))
				Local $RH = Number(GUICtrlRead($IHID))
				Local $RWX = Number(GUICtrlRead($IWIDX))
				Local $RHY = Number(GUICtrlRead($IHIDY))
				GUIDelete($FSZ)
				_REGMSG()
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				$idwh[4] = $RW
				$idwh[5] = $RH
				$idwh[2] = $RWX
				$idwh[3] = $RHY
				$objc.Item($ID) = $idwh
				_INFOCTRL($ID)
				Switch String($idwh[0])
					Case 'pic'
						_SetImage($ID, $idwh[12], $idwh[4], $idwh[5], -1)
						GUICtrlSetPos($ID, $idwh[2], $idwh[3], $idwh[4], $idwh[5])
						_WinAPI_RedrawWindow($WOTP)
						_WinAPI_UpdateWindow($WOTP)
					Case Else
						GUICtrlSetPos($ID, $idwh[2], $idwh[3], $idwh[4], $idwh[5])
				EndSwitch
				WinActivate($WOTP)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_RSZ

Func _ENID()
	Local $seten
	Local $aID = $objc.Keys()
	For $i In $aID
		$seten = $objc.Item($i)
		If $seten[9] = 128 Then
			$seten[9] = $GUI_ENABLE
			$seten[13] = BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT)
			GUICtrlSetState($i, $GUI_ENABLE)
			GUICtrlSetResizing($i, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
			$objc.Item($i) = $seten
			$cidch = 1
		EndIf
	Next
	If $cidch Then
		Local $wcs = $objw.Item(0)
		$wcs[5] = 0
		$objw.Item(0) = $wcs
	EndIf
EndFunc   ;==>_ENID

Func _PAGECH($cpg)
	If $OSNW.Exists('page' & $cpg) Then
		If $CurGui <> $cpg Then
			Local $aKeys
			$aKeys = $objc.Keys()
			For $i In $aKeys
				GUICtrlSetState($i, $GUI_HIDE)
			Next
			$objw = $OSNW.Item('page' & $cpg)[0]
			$objc = $OSNW.Item('page' & $cpg)[1]
			Local $win = $objw.Item(0)
			GUISetBkColor($win[4], $WOTP)
			Local $wpos = WinGetPos($WOTP)
			WinMove($WOTP, '', $wpos[0], $wpos[1], $win[2], $win[3])
			$aKeys = $objc.Keys()
			Local $ctrlstate
			For $i In $aKeys
				$ctrlstate = $objc.Item($i)
				If $ctrlstate[0] == 'treeview' Then _GUITreeViewEx_InitTV($i)
				GUICtrlSetState($i, Number($ctrlstate[25]))
			Next
			$CurGui = $cpg
		EndIf
		DllStructSetData($t_Data, 8, '')
		_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
	EndIf
EndFunc   ;==>_PAGECH

Func _PAGEBN($FL = 0)
	DllStructSetData($t_Data, 8, '')
	Local $aKeys
	If $FL = 0 Then
		$CurGui -= 1
	ElseIf $FL = 1 Then
		$CurGui += 1
	EndIf
	If $FL < 2 Then
		$aKeys = $objc.Keys()
		For $i In $aKeys
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
	Local $aGetObj = $OSNW.Item('page' & $CurGui)
	$objw = $aGetObj[0]
	$objc = $aGetObj[1]
	Local $win = $objw.Item(0)
	GUISetBkColor($win[4], $WOTP)
	$aKeys = $objc.Keys()
	Local $ctrlstate
	For $i In $aKeys
		$ctrlstate = $objc.Item($i)
		If $ctrlstate[0] == 'treeview' Then _GUITreeViewEx_InitTV($i)
		GUICtrlSetState($i, Number($ctrlstate[25]))
	Next
	_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
EndFunc   ;==>_PAGEBN

Func _REMOVEPAGE()
	DllStructSetData($t_Data, 8, '')
	$mmcr = 0
	Local $tmpCurGui = $CurGui
	Local $rkey, $aKeys, $dltks, $idperc, $gtprc
	$aKeys = $objc.Keys()
	For $i In $aKeys
		$dltks = $objc.Item($i)
		Switch String($dltks[0])
			Case 'mod'
				$oMod.Remove($dltks[14])
		EndSwitch
		Switch String($dltks[14])
			Case 'pic', 'txt'
				$oMod.Remove($dltks[14] & $tmpCurGui)
			Case 'backauset', 'ausetmod'
				$gtprc = $oMod.Item($dltks[14])
				$idperc = _ArraySearch($gtprc, $tID)
				If $idperc <> -1 And UBound($idperc) > 1 Then
					_ArrayDelete($gtprc, $tID)
					$oMod.Item($dltks[14]) = $gtprc
				ElseIf $idperc <> -1 And UBound($idperc) = 1 Then
					$oMod.Remove($dltks[14])
				EndIf
			Case 'perc'
				$oMod.Remove('perc')
			Case 'treeview'
				_GUITreeViewEx_Delete($i, False)
		EndSwitch
		GUICtrlDelete($i)
	Next
	$OSNW.Remove('page' & $tmpCurGui)
	$rkey = $OSNW.Keys()
	For $i = 0 To UBound($rkey) - 1
		$OSNW.Key($rkey[$i]) = 'page' & $i
	Next
EndFunc   ;==>_REMOVEPAGE

Func _COPYW()
	DllStructSetData($t_Data, 8, '')
	$mmcr = 0
	Local $aKeys = $objc.Keys()
	For $i = 0 To UBound($aKeys) - 1
		GUICtrlSetState($aKeys[$i], $GUI_HIDE)
	Next
	Local $lostpage = $OSNW.Keys()
	$lostpage = UBound($lostpage)
	Local $lostpagen = 'page' & $lostpage
	Local $getctrl = $OSNW.Item('page' & $CurGui)[1]
	Local $gkeyc = $getctrl.Keys()
	Local $ocopypage = $OSNW.Item('page' & $CurGui)[0]
	Local $ocopy = $ocopypage.Keys()
	_PageCreate($OSNW, $lostpagen)
	Local $aGetObj = $OSNW.Item($lostpagen)
	$objw = $aGetObj[0]
	Local $getp
	For $i In $ocopy
		$getp = $ocopypage.Item($i)
		$getp[5] = 0
		$getp[7] = 0
		$getp[8] = 0
		$getp[9] = 0
		$getp[10] = 0
		$objw.Add($i, $getp)
	Next
	$objc = $aGetObj[1]
	For $i = 0 To UBound($gkeyc) - 1
		$tmpcopyc = $getctrl.Item($gkeyc[$i])
		_PASTECTRL(1)
	Next
	$tmpcopyc = 0
	$CurGui = $lostpage
EndFunc   ;==>_COPYW

Func _NEWPAGE()
	DllStructSetData($t_Data, 8, '')
	$mmcr = 0
	Local $aKeys = $objc.Keys()
	For $i In $aKeys
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	$CurGui = $OSNW.Count()
	_PageCreate($OSNW, 'page' & $CurGui)
	GUISetBkColor(0x808080, $WOTP)
	Local $aGetObj = $OSNW.Item('page' & $CurGui)
	$objw = $aGetObj[0]
	$objc = $aGetObj[1]
	Dim $aINFPG[11]
	Local $posw = WinGetPos($WOTP)
	$aINFPG[0] = $posw[0]
	$aINFPG[1] = $posw[1]
	$aINFPG[2] = $posw[2]
	$aINFPG[3] = $posw[3]
	$aINFPG[4] = 0x808080
	$aINFPG[5] = 0 ; деинсталятор. 1- да, 0 - нет
	$aINFPG[6] = 0 ; путь к фоновому звуку
	$aINFPG[7] = 0 ;название игры
	$aINFPG[8] = 0 ; номер патча
	$aINFPG[9] = 0 ; подсветка управляющих элементов
	$aINFPG[10] = 0
	$objw.Add(0, $aINFPG)
	_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
EndFunc   ;==>_NEWPAGE

Func _CoordSet()
	If $flcoord Then
		While 1
			Switch $crdid
				Case $notcoord
					$flcoord = 0
					Local $getst
					For $i = 0 To UBound($HVXY) - 1
						If $objc.Exists(Number($HVXY[$i][0])) Then
							$getst = $objc.Item(Number($HVXY[$i][0]))
							GUICtrlSetBkColor(Number($HVXY[$i][0]), $getst[11])
						EndIf
					Next
					Dim $HVXY[0][3]
					DllStructSetData($t_Data, 'tip', 0)
					WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
					$crdid = 0
					ExitLoop
				Case $coordset
					$flcoord = 0
					If UBound($HVXY) Then
						_SETCOORD()
						Local $getst
						For $i = 0 To UBound($HVXY) - 1
							If $objc.Exists(Number($HVXY[$i][0])) Then
								$getst = $objc.Item(Number($HVXY[$i][0]))
								GUICtrlSetBkColor(Number($HVXY[$i][0]), $getst[11])
							EndIf
						Next
					EndIf
					Dim $HVXY[0][3]
					DllStructSetData($t_Data, 'tip', 0)
					WinSetState(DllStructGetData($t_Data, 6), '', @SW_ENABLE)
					$crdid = 0
					ExitLoop
				Case Else
					If $objc.Exists($crdid) Then
						Local $getst = $objc.Item($crdid)
						If Not (Number($getst[9]) = 128 Or Number($getst[7]) = $GUI_WS_EX_PARENTDRAG) Then
							Local $nIndSid = _ArraySearch($HVXY, $crdid, 0, 0, 0, 0, 0, 0)
							If @error Then
								_ArrayAdd($HVXY, $crdid & '|' & $getst[2] & '|' & $getst[3])
								Switch String($getst[0])
									Case 'checkbox', 'label'
										GUICtrlSetBkColor($crdid, 0x0000FF)
									Case 'mod'
										GUICtrlSetBkColor($crdid, 0x0000FF)
										_CHKPARENT($crdid)
								EndSwitch
							Else
								GUICtrlSetBkColor($crdid, $getst[11])
								_ArrayDelete($HVXY, $nIndSid)
							EndIf
						EndIf
					EndIf
					$crdid = 0
			EndSwitch
			Sleep(10)
		WEnd
	EndIf
EndFunc   ;==>_CoordSet

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If $flcoord Then
		$crdid = _WinAPI_LoWord($iwParam)
		Return $GUI_RUNDEFMSG
	EndIf
	Local $FSID
	$FSID = _WinAPI_LoWord($iwParam)
	Switch _WinAPI_HiWord($iwParam)
		Case $EN_CHANGE
			Switch $FSID
				Case $CHT
					$flch = 1
			EndSwitch
	EndSwitch
	Local $hNwItemCr, $nParamItemTV, $sRandomName
	Switch $FSID
		Case $svpt
			DllStructSetData($t_Data, 2, $JMPlangset[1])
		Case $ldpt
			DllStructSetData($t_Data, 2, $JMPlangset[2])
		Case $reload
			DllStructSetData($t_Data, 2, $JMPlangset[3])
		Case $ntp
			If $OSNW.Exists('page' & ($CurGui + 1)) Then DllStructSetData($t_Data, 1, $CurGui + 1)
		Case $bckp
			If $OSNW.Exists('page' & ($CurGui - 1)) Then DllStructSetData($t_Data, 1, $CurGui - 1)
		Case $iDummyS
			If $g_GTVEx_aTVData Then
				_TextEndTV($g_GTVEx_aTVData)
				Local $aInfTVItem = _GUITreeViewEx_GetItemData($g_GTVEx_aTVData)
				$aInfTVItem[0] = $sNewTxtItemTV
				_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $aInfTVItem)
			EndIf
		Case $iDummyE
			If $g_GTVEx_aTVData Then _EditTextTV($g_GTVEx_aTVData)
		Case $iDummyD
			If $g_GTVEx_aTVData Then
				_GUITreeViewEx_DeleteItem($g_GTVEx_aTVData)
				DllStructSetData($t_Data, 8, '')
			EndIf
		Case $dtitem
			Local $sRandomName = Random(10, 1000000, 1)
			Dim $aINFCTRL[26]
			$aINFCTRL[0] = $JMPlangset[127] & ' - ' & $sRandomName
			$aINFCTRL[18] = 0 ; путь к моду
			$aINFCTRL[19] = 0 ; путь к картинке мода
			$aINFCTRL[20] = 0 ; путь к звуку мода
			$aINFCTRL[21] = 0 ; путь к шрифту мода
			$aINFCTRL[22] = 0 ; описание мода
			$hNwItemCr = _GUITreeViewEx_CreateItem($g_GTVEx_aTVData, $JMPlangset[127] & ' - ' & $sRandomName, 2)
			$nParamItemTV = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hNwItemCr)
			$aINFCTRL[14] = $nParamItemTV
			_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $aINFCTRL, $nParamItemTV)
		Case $wdtitem
			Local $sRandomName = Random(10, 1000000, 1)
			Dim $aINFCTRL[26]
			$aINFCTRL[0] = $JMPlangset[127] & ' - ' & $sRandomName
			$aINFCTRL[18] = 0 ; путь к моду
			$aINFCTRL[19] = 0 ; путь к картинке мода
			$aINFCTRL[20] = 0 ; путь к звуку мода
			$aINFCTRL[21] = 0 ; путь к шрифту мода
			$aINFCTRL[22] = 0 ; описание мода
			$hNwItemCr = _GUITreeViewEx_CreateItem($g_GTVEx_aTVData, $JMPlangset[127] & ' - ' & $sRandomName, 3)
			$nParamItemTV = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hNwItemCr)
			$aINFCTRL[14] = $nParamItemTV
			_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $aINFCTRL, $nParamItemTV)
		Case $ntitem
			Local $sRandomName = Random(10, 1000000, 1)
			Dim $aINFCTRL[26]
			$aINFCTRL[0] = $JMPlangset[128] & ' - ' & $sRandomName
			$aINFCTRL[18] = 0 ; путь к моду
			$aINFCTRL[19] = 0 ; путь к картинке мода
			$aINFCTRL[20] = 0 ; путь к звуку мода
			$aINFCTRL[21] = 0 ; путь к шрифту мода
			$aINFCTRL[22] = 0 ; описание мода
			$hNwItemCr = _GUITreeViewEx_CreateItem($g_GTVEx_aTVData, $JMPlangset[128] & ' - ' & $sRandomName, 4)
			$nParamItemTV = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hNwItemCr)
			$aINFCTRL[14] = $nParamItemTV
			_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $aINFCTRL, $nParamItemTV)
		Case $ditem
			_GUITreeViewEx_DeleteItem($g_GTVEx_aTVData)
		Case $nitem
			Local $sRandomName = Random(10, 1000000, 1)
			Dim $aINFCTRL[26]
			$aINFCTRL[0] = $JMPlangset[129] & ' - ' & $sRandomName
			$aINFCTRL[18] = 0 ; путь к моду
			$aINFCTRL[19] = 0 ; путь к картинке мода
			$aINFCTRL[20] = 0 ; путь к звуку мода
			$aINFCTRL[21] = 0 ; путь к шрифту мода
			$aINFCTRL[22] = 0 ; описание мода
			$hNwItemCr = _GUITreeViewEx_CreateItem($g_GTVEx_aTVData, $JMPlangset[129] & ' - ' & $sRandomName)
			$nParamItemTV = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hNwItemCr)
			$aINFCTRL[14] = $nParamItemTV
			_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $aINFCTRL, $nParamItemTV)
		Case $witem
			Local $sRandomName = Random(10, 1000000, 1)
			Dim $aINFCTRL[26]
			$aINFCTRL[0] = $JMPlangset[129] & ' - ' & $sRandomName
			$aINFCTRL[14] = $sRandomName
			$aINFCTRL[18] = 0 ; путь к моду
			$aINFCTRL[19] = 0 ; путь к картинке мода
			$aINFCTRL[20] = 0 ; путь к звуку мода
			$aINFCTRL[21] = 0 ; путь к шрифту мода
			$aINFCTRL[22] = 0 ; описание мода
			$hNwItemCr = _GUITreeViewEx_CreateItem($g_GTVEx_aTVData, $JMPlangset[129] & ' - ' & $sRandomName, 1)
			$nParamItemTV = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hNwItemCr)
			$aINFCTRL[14] = $nParamItemTV
			_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $aINFCTRL, $nParamItemTV)
		Case $dittv
			_GUITreeViewEx_Delete($g_GTVEx_aTVData)
		Case $dtv
			_GUITreeViewEx_Delete($g_GTVEx_aTVData, False)
			$objc.Remove($tID)
			DllStructSetData($t_Data, 8, '')
		Case $onlyTV
			_GUITreeViewEx_ChooseOnlyOne($g_GTVEx_aTVData)
		Case $uncheckall
			_GUITreeViewEx_UnCheckAll($g_GTVEx_aTVData)
		Case $31
			If Not $flcoord Then
				WinSetState(DllStructGetData($t_Data, 6), '', @SW_DISABLE)
				$flcoord = 1
				DllStructSetData($t_Data, 'tip', 1)
			EndIf
		Case $chgif
			$flgif = 1
		Case $infstinst
			If $oMod.Exists('info' & $CurGui) Then
				$nFuncError = 1
			Else
				Local $gcs = $objc.Item($tID)
				$gcs[14] = 'info'
				$objc.Item($tID) = $gcs
				$oMod.Add('info' & $CurGui, $tID)
			EndIf
		Case $CLmodpr
			If Not $stoppr Then $stoppr = 1
		Case $setinst
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'inst'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $itch
			$mmcr = 10
			$flitch = 1
		Case $only
			Local $gcs = $objc.Item($tID)
			If $gcs[17] Then
				$gcs[17] = 0
			Else
				$gcs[17] = 1
			EndIf
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $ctrlmw
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'mini'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $chpathgm
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'chpath'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $nausetmod
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'ausetmod'
			$objc.Item($tID) = $gcs
			If $oMod.Exists('ausetmod') Then
				Local $gtprc = $oMod.Item('ausetmod')
				_ArrayAdd($gtprc, $tID)
				$oMod.Item('ausetmod') = $gtprc
			Else
				Local $aperc[1] = [$tID]
				$oMod.Add('ausetmod', $aperc)
			EndIf
			_INFOCTRL($tID)
		Case $nbackauset
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'backauset'
			$objc.Item($tID) = $gcs
			If $oMod.Exists('backauset') Then
				Local $gtprc = $oMod.Item('backauset')
				_ArrayAdd($gtprc, $tID)
				$oMod.Item('backauset') = $gtprc
			Else
				Local $aperc[1] = [$tID]
				$oMod.Add('backauset', $aperc)
			EndIf
			_INFOCTRL($tID)
		Case $pathgame
			If $oMod.Exists('path') Then
				$nFuncError = 1
			Else
				Local $gcs = $objc.Item($tID)
				$gcs[14] = 'path'
				$objc.Item($tID) = $gcs
				$oMod.Add('path', $tID)
			EndIf
			_INFOCTRL($tID)
		Case $cash
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'cash'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $clmrm
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'clmrm'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $backup
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'backup'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $clresmods
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'clresmods'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $clmods
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'clmods'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $picmod
			If $oMod.Exists('pic' & $CurGui) Then
				$nFuncError = 1
			Else
				Local $gcs = $objc.Item($tID)
				$gcs[14] = 'pic'
				$objc.Item($tID) = $gcs
				$oMod.Add('pic' & $CurGui, $tID)
			EndIf
			_INFOCTRL($tID)
		Case $txtmod
			If $oMod.Exists('txt' & $CurGui) Then
				$nFuncError = 1
			Else
				Local $gcs = $objc.Item($tID)
				$gcs[14] = 'txt'
				$objc.Item($tID) = $gcs
				$oMod.Add('txt' & $CurGui, $tID)
			EndIf
			_INFOCTRL($tID)
		Case $fnxt
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'next'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $fbck
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'back'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $fcnl
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'stop'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $fcls
			Local $gcs = $objc.Item($tID)
			$gcs[14] = 'close'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $furl
			$flfurl = 1
		Case $reload
			If Not ($prjpath == '') Then $loadpjt = 2
		Case $ctrlprnt
			Local $gcs = $objc.Item($tID)
			GUICtrlSetStyle($tID, -1, $GUI_WS_EX_PARENTDRAG)
			$gcs[7] = $GUI_WS_EX_PARENTDRAG
			$gcs[14] = 'ctrlprnt'
			$objc.Item($tID) = $gcs
			_INFOCTRL($tID)
		Case $defl
			Local $gcs = $objc.Item($tID)
			GUICtrlSetStyle($tID, 0, $gcs[7])
			$gcs[6] = -1
			$objc.Item($tID) = $gcs
		Case $wlcnr
			Local $gcs = $objc.Item($tID)
			GUICtrlSetStyle($tID, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			$gcs[6] = BitOR($SS_CENTER, $SS_CENTERIMAGE)
			$objc.Item($tID) = $gcs
		Case $glcnr
			Local $gcs = $objc.Item($tID)
			GUICtrlSetStyle($tID, $SS_CENTER)
			$gcs[6] = $SS_CENTER
			$objc.Item($tID) = $gcs
		Case $gllft
			Local $gcs = $objc.Item($tID)
			GUICtrlSetStyle($tID, $SS_CENTERIMAGE)
			$gcs[6] = $SS_CENTERIMAGE
			$objc.Item($tID) = $gcs
		Case $dsl
			Local $idds = $objc.Item($tID)
			Local $getstate = Number($idds[9])
			If $getstate = 128 Then
				$getstate = 64
			ElseIf $getstate = 64 Or $getstate = 0 Then
				$getstate = 128
			EndIf
			$idds[9] = $getstate
			$objc.Item($tID) = $idds
			GUICtrlSetState($tID, $getstate)
		Case $hidectrl
			Local $idds = $objc.Item($tID)
			$idds[25] = 32
			$objc.Item($tID) = $idds
			GUICtrlSetState($tID, 32)
			DllStructSetData($t_Data, 8, '')
		Case $chpage
			$flchpage = 1
		Case $desgproc
			$fldesgproc = 1
		Case $typebar
			$TpBar = 1
		Case $setbck
			Local $gwp = WinGetPos($WOTP)
			GUICtrlSetPos($tID, 0, 0, $gwp[2], $gwp[3])
			Local $curbck = $objc.Item($tID)
			$curbck[2] = 0
			$curbck[3] = 0
			$curbck[4] = $gwp[2]
			$curbck[5] = $gwp[3]
			$objc.Item($tID) = $curbck
			_SetImage($tID, $curbck[12], $gwp[2], $gwp[3], -1)
			GUICtrlSetPos($tID, 0, 0, $gwp[2], $gwp[3])
			_INFOCTRL($tID)
		Case $bbmp
			$flbmp = 1
		Case $trans
			If $tID > 0 Then
				Local $settr = $objc.Item($tID)
				$settr[11] = $GUI_BKCOLOR_TRANSPARENT
				$objc.Item($tID) = $settr
				GUICtrlSetBkColor($tID, $GUI_BKCOLOR_TRANSPARENT)
			EndIf
		Case $pcw
			$flwpic = 1
		Case $ltxt
			$retxt = 1
		Case $fch
			$flfont = 1
		Case $fcl
			$flcl = 1
		Case $tcl
			$flbck = 1
		Case $inst
			$flinst = 1
		Case $rsz
			$chkrsz = 1
		Case $delc
			Local $objgt = $objc.Item($tID)
			Switch String($objgt[0])
				Case 'mod'
					_DELMODIT($tID)
					DllStructSetData($t_Data, 8, '')
				Case Else
					Switch String($objgt[14])
						Case 'pic', 'txt'
							$oMod.Remove($objgt[14] & $CurGui)
						Case 'path'
							$oMod.Remove($objgt[14])
						Case 'backauset', 'ausetmod'
							Local $gtprc = $oMod.Item($objgt[14])
							Local $idperc = _ArraySearch($gtprc, $tID)
							If $idperc <> -1 And UBound($idperc) > 1 Then
								_ArrayDelete($gtprc, $tID)
								$oMod.Item($objgt[14]) = $gtprc
							ElseIf $idperc <> -1 And UBound($idperc) = 1 Then
								$oMod.Remove($objgt[14])
							EndIf
						Case 'perc'
							$oMod.Remove('perc')
					EndSwitch
					$objc.Remove($tID)
					GUICtrlDelete($tID)
					DllStructSetData($t_Data, 8, '')
			EndSwitch
			$tID = 0
		Case $nofunc
			Local $stnf = $objc.Item($tID)
			Switch String($stnf[14])
				Case 'pic', 'txt', 'info'
					$oMod.Remove($stnf[14] & $CurGui)
				Case 'path'
					$oMod.Remove($stnf[14])
				Case 'ausetmod', 'backauset'
					Local $gtprc = $oMod.Item($stnf[14])
					Local $idperc = _ArraySearch($gtprc, $tID)
					If $idperc <> -1 And UBound($idperc) > 1 Then
						_ArrayDelete($gtprc, $tID)
						$oMod.Item($stnf[14]) = $gtprc
					ElseIf $idperc <> -1 And UBound($idperc) = 1 Then
						$oMod.Remove($stnf[14])
					EndIf
				Case 'ctrlprnt'
					GUICtrlSetStyle($tID, $stnf[6], 0)
				Case 'chpage'
					$stnf[15] = -1
				Case 'url'
					$stnf[15] = 0
			EndSwitch
			$stnf[7] = -1
			$stnf[14] = 0
			$objc.Item($tID) = $stnf
			_INFOCTRL($tID)
		Case $callp
			_CFW()
		Case Else
			If $objc.Exists($FSID) Then
				Local $getst = $objc.Item($FSID)
				Switch String($getst[0])
					Case 'checkbox'
						Switch $getst[14]
							Case 'backauset', 'ausetmod'
								$getst[15] = 0
							Case Else
								$getst[15] = GUICtrlRead($FSID)
						EndSwitch
						$objc.Item($FSID) = $getst
						_INFOCTRL($FSID)
					Case 'mod'
						_CHKPARENT($FSID)
						_INFOCTRL($FSID)
					Case 'label'
						_INFOCTRL($FSID)
				EndSwitch
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func _CHKPARENT($idchk)
	Local $ainfid = $objc.Item($idchk)
	If GUICtrlRead($idchk) = 4 Then
		$ainfid[23] = 4
		$objc.Item($idchk) = $ainfid
		If Not (String($ainfid[16]) == '0') Then _CHKDNDEL($ainfid[16])
	Else
		$ainfid[23] = 1
		$objc.Item($idchk) = $ainfid
		If $ainfid[15] Then
			_CHKUP($ainfid[15])
			_ONLY($ainfid[15], $ainfid[14])
		EndIf
		If Not (String($ainfid[16]) == '0') Then _CHKDN($ainfid[16])
	EndIf
EndFunc   ;==>_CHKPARENT

Func _ONLY($nmp, $nmit)
	Local $gtfol = $oMod.Item($nmp)
	Local $only = $objc.Item($gtfol)
	If $only[17] Then
		Local $recount = StringReplace($only[16], '#' & $nmit, '')
		If Not @extended Then
			$recount = StringReplace($only[16], $nmit & '#', '')
			If Not @extended Then
				$recount = StringReplace($only[16], $nmit, '')
				If Not @extended Then $recount = ''
			EndIf
		EndIf
		If Not ($recount == '') Then _CHKDNDEL($recount)
		If $only[15] Then
			_ONLY($only[15], $only[14])
		EndIf
	Else
		If $only[15] Then
			_ONLY($only[15], $only[14])
		EndIf
	EndIf
EndFunc   ;==>_ONLY

Func _CHKUP($idprt)
	Local $getchk, $getid = $idprt, $gtfol
	While 1
		$gtfol = $oMod.Item($getid)
		$getchk = $objc.Item($gtfol)
		If GUICtrlRead($getchk) = 1 Then
			ExitLoop
		Else
			GUICtrlSetState($gtfol, 1)
			$getchk[23] = 1
			$objc.Item($gtfol) = $getchk
			If Not Number($getchk[15]) Then ExitLoop
			$getid = Number($getchk[15])
		EndIf
	WEnd
EndFunc   ;==>_CHKUP

Func _CHKDN($idprt)
	Local $getchk, $getid = $idprt
	Local $splfid, $gettmpid
	While 1
		$splfid = StringSplit($getid, '#')
		$gettmpid = $oMod.Item(Number($splfid[1]))
		$getchk = $objc.Item($gettmpid)
		GUICtrlSetState($gettmpid, 1)
		$getchk[23] = 1
		$objc.Item($gettmpid) = $getchk
		If String($getchk[16]) == '0' Then ExitLoop
		$getid = $getchk[16]
	WEnd
EndFunc   ;==>_CHKDN

Func _CHKDNDEL($idprt)
	Local $getchk
	Local $splfid, $gettmpid
	$splfid = StringSplit($idprt, '#')
	For $i = 1 To $splfid[0]
		$gettmpid = $oMod.Item(Number($splfid[$i]))
		$getchk = $objc.Item($gettmpid)
		GUICtrlSetState($gettmpid, 4)
		$getchk[23] = 4
		$objc.Item($gettmpid) = $getchk
		If String($getchk[16]) == '0' Then ContinueLoop
		_CHKDNDEL($getchk[16])
	Next
EndFunc   ;==>_CHKDNDEL

Func _CFW()
	If $oSNW.Exists('page' & $CurGui + 1) Then
		$tmpcopyc = $objc.Item($tID)
		_PAGEBN(1)
		_PASTECTRL(1)
		$tmpcopyc = 0
	EndIf
EndFunc   ;==>_CFW

Func _PASTECTRL($FL = 0)
	Local $funcid, $medit
	If $FL Then
		$cx = $tmpcopyc[2]
		$cy = $tmpcopyc[3]
	EndIf
	If $tmpcopyc[7] = $GUI_WS_EX_PARENTDRAG Then $tmpcopyc[7] = -1
	Switch String($tmpcopyc[0])
		Case 'label'
			$funcid = GUICtrlCreateLabel('', $cx, $cy, $tmpcopyc[4], $tmpcopyc[5], $tmpcopyc[6], $tmpcopyc[7])
			DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
			$medit = StringReplace($tmpcopyc[1], '\n', @CRLF)
			$medit = StringReplace($medit, '\h', ' ')
			GUICtrlSetData($funcid, $medit)
		Case 'pic'
			$funcid = GUICtrlCreatePic('', $cx, $cy, $tmpcopyc[4], $tmpcopyc[5], $tmpcopyc[6], $tmpcopyc[7])
			If FileExists($tmpcopyc[12]) Then
				_SetImage($funcid, $tmpcopyc[12], $tmpcopyc[4], $tmpcopyc[5], -1)
				GUICtrlSetPos($funcid, $cx, $cy, $tmpcopyc[4], $tmpcopyc[5])
				_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
			EndIf
		Case 'checkbox'
			$funcid = GUICtrlCreateCheckbox('', $cx, $cy, $tmpcopyc[4], $tmpcopyc[5], $tmpcopyc[6], $tmpcopyc[7])
			DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
			$medit = StringReplace($tmpcopyc[1], '\n', @CRLF)
			$medit = StringReplace($medit, '\h', ' ')
			GUICtrlSetData($funcid, $medit)
	EndSwitch
	If Not $funcid Then Return
	Local $setpos = ControlGetPos($WOTP, '', $funcid)
	$tmpcopyc[2] = $setpos[0]
	$tmpcopyc[3] = $setpos[1]
	Local $gf = StringSplit($tmpcopyc[8], '!')
	If $gf[0] > 1 Then GUICtrlSetFont($funcid, $gf[1], $gf[2], $gf[3], $gf[4])
	GUICtrlSetColor($funcid, Number($tmpcopyc[10]))
	GUICtrlSetBkColor($funcid, Number($tmpcopyc[11]))
	GUICtrlSetResizing($funcid, $tmpcopyc[13])
	GUICtrlSetState($funcid, $tmpcopyc[9])
	Switch String($tmpcopyc[14])
		Case 'url'
			$tmpcopyc[15] = 0
		Case 'chpage'
			$tmpcopyc[15] = -1
	EndSwitch
	$tmpcopyc[14] = 0
	$tmpcopyc[25] = 16
	$objc.Add($funcid, $tmpcopyc)
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
EndFunc   ;==>_PASTECTRL

Func _INFOCTRL($IDCTRL = 0)
	Local $gcrp, $elsf = '', $gtcrtv
	If Not $IDCTRL Then
		Local $GCC = GUIGetCursorInfo($WOTP)
		$cx = $GCC[0]
		$cy = $GCC[1]
		If $GCC[4] Then $gtcrtv = $GCC[4]
	Else
		$gtcrtv = $IDCTRL
	EndIf
	If $objc.Exists($gtcrtv) Then
		$gcrp = $objc.Item($gtcrtv)
		If Not (String($gcrp[14]) == '0') Then
			Switch String($gcrp[14])
				Case 'next'
					$elsf = @CRLF & $JMPlangset[130]
				Case 'back'
					$elsf = @CRLF & $JMPlangset[131]
				Case 'stop'
					$elsf = @CRLF & $JMPlangset[132]
				Case 'close'
					$elsf = @CRLF & $JMPlangset[133]
				Case 'url'
					$elsf = @CRLF & $JMPlangset[134] & @CRLF & $gcrp[15]
				Case 'perc'
					$elsf = @CRLF & $JMPlangset[135]
				Case 'pic'
					$elsf = @CRLF & $JMPlangset[136]
				Case 'txt'
					$elsf = @CRLF & $JMPlangset[137]
				Case 'clmods'
					$elsf = @CRLF & $JMPlangset[138]
				Case 'clresmods'
					$elsf = @CRLF & $JMPlangset[139]
				Case 'clmrm'
					$elsf = @CRLF & $JMPlangset[140]
				Case 'backup'
					$elsf = @CRLF & $JMPlangset[141]
				Case 'path'
					$elsf = @CRLF & $JMPlangset[142]
				Case 'chpath'
					$elsf = @CRLF & $JMPlangset[143]
				Case 'chpage'
					$elsf = @CRLF & $JMPlangset[144] & @CRLF & $JMPlangset[145] & ' - ' & $gcrp[15]
				Case 'inst'
					$elsf = @CRLF & $JMPlangset[146]
				Case 'info'
					$elsf = @CRLF & $JMPlangset[147]
				Case 'cash'
					$elsf = @CRLF & $JMPlangset[148]
				Case 'ctrlprnt'
					$elsf = @CRLF & $JMPlangset[149]
				Case 'mini'
					$elsf = @CRLF & $JMPlangset[150]
				Case 'backauset'
					$elsf = @CRLF & $JMPlangset[151]
				Case 'ausetmod'
					$elsf = @CRLF & $JMPlangset[152]
				Case Else
					$elsf &= ''
			EndSwitch
		EndIf
		If $gcrp[0] == 'mod' Then
			Local $prp
			If $oMod.Exists(Number($gcrp[15])) Then $prp = $oMod.Item(Number($gcrp[15]))
			If $prp Then
				$elsf &= @CRLF & $JMPlangset[153] & ': id -' & $prp
				If $objc.Item($prp)[17] Then $elsf &= @CRLF & $JMPlangset[154]
			EndIf
			If $gcrp[16] Then
				Local $idchl
				Local $getidch = StringSplit($gcrp[16], '#')
				For $i = 1 To $getidch[0]
					$idchl &= 'id - ' & $oMod.Item(Number($getidch[$i])) & ','
				Next
				$elsf &= @CRLF & $JMPlangset[155] & ' - ' & $idchl
			EndIf
			If $gcrp[17] Then $elsf &= @CRLF & $JMPlangset[156]
			$elsf &= @CRLF & $JMPlangset[157] & ' - ' & $gcrp[18]
			$elsf &= @CRLF & $JMPlangset[158] & ' - ' & $gcrp[19]
			$elsf &= @CRLF & $JMPlangset[159] & ' - ' & $gcrp[20]
			$elsf &= @CRLF & $JMPlangset[160] & ' - ' & $gcrp[21]
			$elsf &= @CRLF & $JMPlangset[161] & ' - ' & StringReplace(StringReplace($gcrp[22], '\n', @CRLF), '\h', ' ')
			$elsf &= @CRLF & $JMPlangset[162] & ' - ' & IniRead($prjpath & '\rwconf.txt', 'Path', $gcrp[14], '')
		Else
			If FileExists($gcrp[12]) Then $elsf &= @CRLF & $JMPlangset[30] & ' - ' & $gcrp[12]
		EndIf
		If Not (String($gcrp[8]) == '0') Then $elsf &= @CRLF & $JMPlangset[163] & ' - ' & $gcrp[8]
		DllStructSetData($t_Data, 8, $gcrp[0] & ', id - ' & $gtcrtv & $elsf & @CRLF & $JMPlangset[0] & ' - ' & $CurGui & @CRLF & 'x - ' & $gcrp[2] & @CRLF & 'y - ' & $gcrp[3] & @CRLF & $JMPlangset[63] & ' - ' & $gcrp[4] & @CRLF & $JMPlangset[64] & ' - ' & $gcrp[5])
	EndIf
EndFunc   ;==>_INFOCTRL

Func _SetInfItem()
	Local $amodinfo = _GUITreeViewEx_GetItemData($g_GTVEx_aTVData)
	If Not @error Then
		Local $smodinfo
		$smodinfo &= 'id param - ' & $amodinfo[14] & @CRLF
		$smodinfo &= $JMPlangset[157] & ' - ' & $amodinfo[18] & @CRLF
		$smodinfo &= $JMPlangset[158] & ' - ' & $amodinfo[19] & @CRLF
		$smodinfo &= $JMPlangset[159] & ' - ' & $amodinfo[20] & @CRLF
		$smodinfo &= $JMPlangset[160] & ' - ' & $amodinfo[21] & @CRLF
		Local $medit
		$medit = StringReplace($amodinfo[22], '\n', @CRLF)
		$medit = StringReplace($medit, '\h', ' ')
		$smodinfo &= $JMPlangset[161] & ' - ' & $medit & @CRLF
		$smodinfo &= $JMPlangset[162] & ' - ' & IniRead($prjpath & '\rwconf.txt', 'Path', $amodinfo[14], '')
		DllStructSetData($t_Data, 8, $smodinfo)
	EndIf
EndFunc   ;==>_SetInfItem

Func WM_SETCURSOR($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $lParam
	If $flcoord Then Return $GUI_RUNDEFMSG
	$curtv = _WinAPI_GetDlgCtrlID($wParam)
	Switch _WinAPI_HiWord($lParam)
		Case 513
			If _IsPressed('12', $hDLL) Then
				If Not UBound($aModMove) Then
					$startcrlb = 1
				Else
					$startcrlb = 2
				EndIf
				Return $GUI_RUNDEFMSG
			EndIf
			If $wParam = $WOTP Then
				$mvwin = 1
				Local $aInfo = GUIGetCursorInfo($WOTP)
				$winw = $aInfo[0]
				$winh = $aInfo[1]
			EndIf
			If _IsPressed('11', $hDLL) Then $flmove = 1
		Case 514
			_INFOCTRL()
			If $objc.Exists($curtv) Then
				Local $getst = $objc.Item($curtv)
				Switch String($getst[0])
					Case 'treeview'
						Local $tPoint = _WinAPI_GetMousePos(1, $g_GTVEx_aTVData)
						Local $tTVHTI = _GUICtrlTreeView_HitTestEx($g_GTVEx_aTVData, DllStructGetData($tPoint, 1, 1), DllStructGetData($tPoint, 2))
						Local $hItemTV = DllStructGetData($tTVHTI, 'Item')
						If $hItemTV Then
							Switch DllStructGetData($tTVHTI, 'Flags')
								Case 4, 64
									_SetInfItem()
							EndSwitch
						EndIf
				EndSwitch
			EndIf
			$flmove = 0
			$mvwin = 0
			Switch $wParam
				Case $WOTP
					If $mmcr Then $flmmcr = 1
				Case Else
					$mmcr = 0
			EndSwitch
		Case 517
			$flmove = 0
			$mmcr = 0
			$flmmcr = 0
			$flitch = 0
			Switch $wParam
				Case $WOTP
					Local $GCC = GUIGetCursorInfo($WOTP)
					$cx = $GCC[0]
					$cy = $GCC[1]
					If $GCC[4] > 0 Then
						$szID = $GCC[4]
						$tID = $GCC[4]
						_MenuCTRL($hWnd, $GCC[4])
					EndIf
				Case Else
					$tID = _WinAPI_GetDlgCtrlID($wParam)
					$szID = $tID
					_MenuCTRL($hWnd, $tID)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SETCURSOR

Func _CRCTRL()
	Switch $mmcr
		Case 3
			_CRCHK()
		Case 5
			_CRPR()
		Case 6
			_CRSTR()
		Case 7
			_CRTV()
		Case 8
			_CRPIC()
		Case 10
			_CRMOD($flitch)
			If $flitch Then $mmcr = 0
			$flitch = 0
	EndSwitch
	$mmcr = 0
EndFunc   ;==>_CRCTRL

Func _CFG($hw, $gid)
	GUISetState(@SW_DISABLE, $hw)
	Local $drw = 0
	Local $CFG = GUICreate($JMPlangset[164], 525, 465, -1, -1, $WS_THICKFRAME, $WS_EX_TOOLWINDOW, $hw)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $CFG)
	GUISetFont(9, 400, 0, 'Georgia', $CFG)
	Local $rddef = GUICtrlCreateRadio($JMPlangset[165], 24, 10, 476, 20)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	GUICtrlSetState(-1, 1)
	Local $rdrw = GUICtrlCreateRadio($JMPlangset[166], 24, 35, 476, 20)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $Lpath = GUICtrlCreateLabel($JMPlangset[167], 24, 60, 476, 20)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $Ipath = GUICtrlCreateInput('', 24, 85, 476, 25)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $Lnum = GUICtrlCreateLabel($JMPlangset[168], 24, 115, 476, 20)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $iNum = GUICtrlCreateCombo('', 24, 140, 120, 25)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $setnum = GUICtrlCreateButton($JMPlangset[169], 150, 140, 100, 25)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $delone = GUICtrlCreateButton($JMPlangset[8], 260, 140, 100, 25)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $Lnt = GUICtrlCreateLabel($JMPlangset[170], 24, 170, 200, 20)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKWIDTH, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $scfg = GUICtrlCreateButton($JMPlangset[1], 400, 165, 100, 25)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $Ent = GUICtrlCreateEdit('', 24, 195, 476, 233)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKBOTTOM))
	GUISetState(@SW_SHOW, $CFG)
	Local $rwconf = $prjpath & '\rwconf.txt'
	Local $spls, $arts = ''
	Local $getcfg = IniReadSection($rwconf, $gid)
	If Not @error Then
		_ArrayDelete($getcfg, 0)
		$spls = StringTrimRight($getcfg[0][1], 6)
		$spls = StringReplace($spls, '&jmp&', @CRLF)
		GUICtrlSetData($Ent, $spls)
		$drw = Number(StringRight($getcfg[0][1], 1))
		If $drw Then
			GUICtrlSetState($rdrw, 1)
		Else
			GUICtrlSetState($rddef, 1)
		EndIf
		For $i = 0 To UBound($getcfg) - 1
			$arts &= $getcfg[$i][0] & '|'
		Next
		$arts = StringTrimRight($arts, 1)
		GUICtrlSetData($iNum, $arts, $getcfg[0][0])
		GUICtrlSetData($Ipath, IniRead($rwconf, 'path', $gid, ''))
	Else
		Local $getcfg[0][2]
	EndIf
	While 1
		If Not WinExists(DllStructGetData($t_Data, 6)) Then Exit
		Switch GUIGetMsg()
			Case -3
				GUIDelete($CFG)
				GUISetState(@SW_ENABLE, $hw)
				WinActivate($hw)
				ExitLoop
			Case $setnum
				GUICtrlSetData($iNum, '')
				$arts = ''
				For $i = 0 To UBound($getcfg) - 1
					$arts &= $getcfg[$i][0] & '|'
				Next
				GUICtrlSetData($iNum, $arts, ' ')
				GUICtrlSetData($Ent, '')
				GUICtrlSetState($rddef, 1)
				$drw = 0
			Case $delone
				Local $rnm = Number(GUICtrlRead($iNum))
				If $rnm Then
					Local $spf = _ArraySearch($getcfg, $rnm, 0, 0, 0, 0, 1, 0)
					If Not @error Then
						_ArrayDelete($getcfg, $spf)
						If UBound($getcfg) > 0 Then
							$spls = StringTrimRight($getcfg[0][1], 6)
							$spls = StringReplace($spls, '&jmp&', @CRLF)
							GUICtrlSetData($Ent, $spls)
							$drw = Number(StringRight($getcfg[0][1], 1))
							If $drw Then
								GUICtrlSetState($rdrw, 1)
							Else
								GUICtrlSetState($rddef, 1)
							EndIf
							For $i = 0 To UBound($getcfg) - 1
								$arts &= $getcfg[$i][0] & '|'
							Next
							$arts = StringTrimRight($arts, 1)
							GUICtrlSetData($iNum, $arts, $getcfg[0][0])
						Else
							GUICtrlSetData($iNum, '')
							GUICtrlSetState($rddef, 1)
							GUICtrlSetData($Ent, '')
							GUICtrlSetData($Ipath, '')
							$drw = 0
						EndIf
						IniDelete($rwconf, $gid, $rnm)
						IniReadSection($rwconf, $gid)
						If @error Then
							IniDelete($rwconf, $gid)
							IniDelete($rwconf, 'path', $gid)
							IniReadSection($rwconf, 'path')
							If @error Then FileDelete($rwconf)
						EndIf
					EndIf
				EndIf
			Case $scfg
				Local $rent = GUICtrlRead($Ent)
				Local $rnm = Number(GUICtrlRead($iNum))
				Local $spt = GUICtrlRead($Ipath)
				If StringLeft($spt, 1) == '\' Then $spt = StringTrimLeft($spt, 1)
				If $rent <> '' And $rnm > 0 And $spt <> '' Then
					Local $strlf = StringReplace($rent, @CRLF, '&jmp&') & '&jmp&' & $drw
					Local $spf = _ArraySearch($getcfg, $rnm, 0, 0, 0, 0, 1, 0)
					If Not @error Then
						$getcfg[$spf][0] = $rnm
						$getcfg[$spf][1] = $strlf
						GUICtrlSetData($iNum, $rnm & '|')
						IniWrite($rwconf, $gid, $rnm, $strlf)
						IniWrite($rwconf, 'path', $gid, $spt)
					Else
						_ArrayAdd($getcfg, $rnm & '|' & $strlf)
						GUICtrlSetData($iNum, $rnm & '|')
						IniWrite($rwconf, $gid, $rnm, $strlf)
						IniWrite($rwconf, 'path', $gid, $spt)
					EndIf
				Else
					MsgBox(16, '', $JMPlangset[171], 0, $CFG)
				EndIf
			Case $iNum
				Local $rdnum = Number(GUICtrlRead($iNum))
				If $rdnum Then
					Local $spf = _ArraySearch($getcfg, $rdnum, 0, 0, 0, 0, 1, 0)
					If Not @error Then
						$spls = StringTrimRight($getcfg[$spf][1], 6)
						$spls = StringReplace($spls, '&jmp&', @CRLF)
						GUICtrlSetData($Ent, $spls)
						$drw = Number(StringRight($getcfg[$spf][1], 1))
						If $drw Then
							GUICtrlSetState($rdrw, 1)
						Else
							GUICtrlSetState($rddef, 1)
						EndIf
					EndIf
				EndIf
			Case $rddef
				$drw = 0
			Case $rdrw
				$drw = 1
		EndSwitch
	WEnd
EndFunc   ;==>_CFG

Func _SETMOD()
	_CLOSEREG()
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $gid = $tID, $nParamItemTV, $setmod
	If $g_GTVEx_aTVData Then
		$setmod = _GUITreeViewEx_GetItemData($g_GTVEx_aTVData)
	Else
		$setmod = $objc.Item($gid)
	EndIf
	Local $wMod = GUICreate($JMPlangset[172], 600, 520, -1, -1, $WS_THICKFRAME, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $wMod)
	GUISetFont(9, 400, 0, 'Georgia', $wMod)
	Local $ml = GUICtrlCreateLabel($JMPlangset[173], 8, 10, 400, 17)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $mlp = GUICtrlCreateInput('', 8, 35, 537, 21)
	If Not ($setmod[18] == '0') Then GUICtrlSetData(-1, $setmod[18])
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $sctm = GUICtrlCreateButton('...', 550, 35, 43, 21)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $pl = GUICtrlCreateLabel($JMPlangset[158], 8, 71, 250, 17)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $plp = GUICtrlCreateInput('', 8, 95, 537, 21)
	If Not ($setmod[19] == '0') Then GUICtrlSetData(-1, $setmod[19])
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $sctp = GUICtrlCreateButton('...', 550, 95, 43, 21)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $aul = GUICtrlCreateLabel($JMPlangset[159], 8, 130, 250, 17)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $aup = GUICtrlCreateInput('', 8, 154, 537, 21)
	If Not ($setmod[20] == '0') Then GUICtrlSetData(-1, $setmod[20])
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $sctau = GUICtrlCreateButton('...', 550, 154, 43, 21)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $FL = GUICtrlCreateLabel($JMPlangset[160], 8, 188, 250, 17)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $flp = GUICtrlCreateInput('', 8, 212, 537, 21)
	If Not ($setmod[21] == '0') Then GUICtrlSetData(-1, $setmod[21])
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $sctf = GUICtrlCreateButton('...', 550, 212, 43, 21)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $txtl = GUICtrlCreateLabel($JMPlangset[161], 8, 247, 250, 17)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	Local $txtmod = GUICtrlCreateEdit('', 8, 271, 585, 180)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKBOTTOM))
	Local $setcfg = GUICtrlCreateButton($JMPlangset[162], 8, 460, 180, 21)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKBOTTOM, $GUI_DOCKHEIGHT))
	Local $dlall = GUICtrlCreateButton($JMPlangset[174], 380, 460, 180, 21)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKRIGHT, $GUI_DOCKBOTTOM, $GUI_DOCKHEIGHT))
	If Not ($setmod[22] == '0') Then
		Local $medit
		$medit = StringReplace($setmod[22], '\n', @CRLF)
		$medit = StringReplace($medit, '\h', ' ')
		GUICtrlSetData($txtmod, $medit)
	EndIf
	GUISetState(@SW_SHOW, $wMod)
	Local $gpm
	While 1
		If Not WinExists(DllStructGetData($t_Data, 6)) Then Exit
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Local $rpath
				$rpath = GUICtrlRead($mlp)
				If $rpath Then
					$setmod[18] = $rpath
				Else
					$setmod[18] = 0
				EndIf
				$rpath = GUICtrlRead($plp)
				If $rpath Then
					$setmod[19] = $rpath
				Else
					$setmod[19] = 0
				EndIf
				$rpath = GUICtrlRead($aup)
				If $rpath Then
					$setmod[20] = $rpath
				Else
					$setmod[20] = 0
				EndIf
				$rpath = GUICtrlRead($flp)
				If $rpath Then
					$setmod[21] = $rpath
				Else
					$setmod[21] = 0
				EndIf
				$rpath = StringReplace(StringRegExpReplace(GUICtrlRead($txtmod), '[*~|#><]', ' '), '\', '') ;StringRegExpReplace(GUICtrlRead($txtmod), '[<>]', ' ')
				If $rpath Then
					$rpath = StringReplace($rpath, @CRLF, '\n')
					$rpath = StringReplace($rpath, ' ', '\h')
					$setmod[22] = $rpath
				Else
					$setmod[22] = 0
				EndIf
				If $g_GTVEx_aTVData Then
					_GUITreeViewEx_SetItemData($g_GTVEx_aTVData, $setmod)
				Else
					$objc.Item($gid) = $setmod
				EndIf
				GUIDelete($wMod)
				_REGMSG()
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				WinActivate($WOTP)
				ExitLoop
			Case $setcfg
				If FileExists($prjpath) Then
					If $g_GTVEx_aTVData Then
						_CFG($wMod, _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hModificationItemTV))
					Else
						_CFG($wMod, $setmod[14])
					EndIf
				Else
					MsgBox(16, '', $JMPlangset[175], 0, $wMod)
				EndIf
			Case $sctm
				$gpm = FileSelectFolder($JMPlangset[176], $pathwpic, 7, '', $wMod)
				If Not @error Then
					GUICtrlSetData($mlp, $gpm)
					$pathwpic = $gpm
				EndIf
			Case $sctp
				$gpm = FileOpenDialog($JMPlangset[177], $pathwpic, '(*.png;*.jpg;*.bmp)', 2, '', $wMod)
				If Not @error Then
					GUICtrlSetData($plp, $gpm)
					$pathwpic = $gpm
				EndIf
			Case $sctau
				$gpm = FileOpenDialog($JMPlangset[178], $pathwpic, '(*.mp3)', 2, '', $wMod)
				If Not @error Then
					GUICtrlSetData($aup, $gpm)
					$pathwpic = $gpm
				EndIf
			Case $sctf
				$gpm = FileOpenDialog($JMPlangset[179], $pathwpic, '(*.ttf;*.otf)', 2, '', $wMod)
				If Not @error Then
					GUICtrlSetData($flp, $gpm)
					$pathwpic = $gpm
				EndIf
			Case $dlall
				IniDelete($prjpath & '\rwconf.txt', 'path', $setmod[14])
				IniDelete($prjpath & '\rwconf.txt', $setmod[14])
				IniReadSection($prjpath & '\rwconf.txt', 'path')
				If @error Then FileDelete($prjpath & '\rwconf.txt')
				Local $arel[5] = [$mlp, $plp, $aup, $flp, $txtmod]
				For $i = 0 To 4
					GUICtrlSetData($arel[$i], '')
				Next

		EndSwitch
	WEnd
EndFunc   ;==>_SETMOD

Func _DELMODIT($idfr)
	Local $dltit = $objc.Item($idfr)
	If String($dltit[16]) == '0' Then
		$oMod.Remove(Number($dltit[14]))
		$objc.Remove(Number($idfr))
		GUICtrlDelete($idfr)
	Else
		Local $aprm[1][2]
		_DELNEXT($aprm, $dltit[16])
		For $i = 1 To UBound($aprm) - 1
			$objc.Remove(Number($aprm[$i][0]))
			$oMod.Remove(Number($aprm[$i][1]))
			GUICtrlDelete($aprm[$i][0])
		Next
		$oMod.Remove(Number($dltit[14]))
		$objc.Remove(Number($idfr))
		GUICtrlDelete($idfr)
	EndIf
	If $dltit[15] Then
		Local $idp = $oMod.Item(Number($dltit[15]))
		Local $reset = $objc.Item($idp)
		Local $recount = StringReplace($reset[16], '#' & $dltit[14], '')
		If Not @extended Then
			$recount = StringReplace($reset[16], $dltit[14] & '#', '')
			If Not @extended Then $recount = StringReplace($reset[16], $dltit[14], '')
		EndIf
		If Not $recount Then $recount = 0
		$reset[16] = $recount
		$objc.Item($idp) = $reset
	EndIf
EndFunc   ;==>_DELMODIT

Func _DELNEXT(ByRef $aIt, $prit)
	Local $dlid, $gtdt
	Local $gtchl = StringSplit($prit, '#')
	For $i = 1 To $gtchl[0]
		$dlid = $oMod.Item(Number($gtchl[$i]))
		_ArrayAdd($aIt, $dlid & '|' & $gtchl[$i])
		$gtdt = $objc.Item($dlid)
		If String($gtdt[16]) == '0' Then ContinueLoop ;ExitLoop
		_DELNEXT($aIt, $gtdt[16])
	Next
EndFunc   ;==>_DELNEXT

Func _CRMOD($TypeIt = 0)
	Local $NewName, $nc, $cltp, $schd
	While 1
		$NewName = Random(1, 1000, 1)
		If Not $oMod.Exists($NewName) Then ExitLoop
	WEnd
	Dim $aINFCTRL[26]
	If $TypeIt Then
		If Not $objc.Exists($tID) Then Return SetError(1)
		$schd = $objc.Item($tID)
		If $schd[17] Then
			$nc = GUICtrlCreateRadio('', $cx, $cy, 150, 15)
			$cltp = 'rd'
		Else
			$nc = GUICtrlCreateCheckbox('', $cx, $cy, 150, 15)
			$cltp = 'chk'
		EndIf
	Else
		$nc = GUICtrlCreateCheckbox('', $cx, $cy, 150, 15)
		$cltp = 'chk'
	EndIf
	DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($nc), 'wstr', '', 'wstr', '')
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	GUICtrlSetFont(-1, 9, 800, 2, 'Arial')
	GUICtrlSetColor(-1, 0xFFA900)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$aINFCTRL[0] = 'mod'
	$aINFCTRL[1] = '' ;текст элемента
	$aINFCTRL[2] = $cx ;х координата
	$aINFCTRL[3] = $cy ;у координата
	$aINFCTRL[4] = 100 ;ширина
	$aINFCTRL[5] = 15 ;высота
	$aINFCTRL[6] = -1 ;стиль элемента
	$aINFCTRL[7] = -1 ; EX - стиль элемента
	$aINFCTRL[8] = '9!800!2!Arial' ;шрифт
	$aINFCTRL[9] = 64 ;состояние элемента (GuiCtrlSetState())
	$aINFCTRL[10] = 0xFFA900 ;цвет текста - GuiCtrlSetColor
	$aINFCTRL[11] = $GUI_BKCOLOR_TRANSPARENT ;цвет фона - GuiCtrlSetBkColor
	$aINFCTRL[12] = 0 ;фоновая картинка - GuiCtrlSetImage
	$aINFCTRL[13] = BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT) ;поведение - GUICtrlSetResizing
	$aINFCTRL[14] = $NewName ; ID - пункта $oMod.Item($NewName)
	$aINFCTRL[15] = 0 ; ID родительского пункта $oMod.Item
	$aINFCTRL[16] = 0 ; IDs дочерних пунктов первого уровня $oMod.Item
	$aINFCTRL[17] = 0 ; 1 - одиночный выбор подпунктов(подпункты становятся псевдо радиокнопками)
	$aINFCTRL[18] = 0 ; путь к моду
	$aINFCTRL[19] = 0 ; путь к картинке мода
	$aINFCTRL[20] = 0 ; путь к звуку мода
	$aINFCTRL[21] = 0 ; путь к шрифту мода
	$aINFCTRL[22] = 0 ; описание мода
	$aINFCTRL[23] = 0 ; 1- пункт иммет отметку выбора
	$aINFCTRL[24] = $cltp ; chk - чекбокс rd - радио
	$aINFCTRL[25] = 16
	If $TypeIt Then
		$schd = $objc.Item($tID)
		If Not (String($schd[16]) == '0') Then
			$schd[16] = $schd[16] & '#' & $NewName
		Else
			$schd[16] = $NewName
		EndIf
		$objc.Item($tID) = $schd
		$aINFCTRL[1] = $NewName & $JMPlangset[180] & $schd[14]
		$aINFCTRL[15] = $schd[14]
		GUICtrlSetData($nc, $NewName & $JMPlangset[180] & $schd[14])
	Else
		$aINFCTRL[1] = $NewName & $JMPlangset[181]
		GUICtrlSetData($nc, $NewName & $JMPlangset[181])
	EndIf
	$objc.Add($nc, $aINFCTRL)
	$oMod.Add($NewName, $nc)
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
EndFunc   ;==>_CRMOD

Func _CRPIC()
	If FileExists(@ScriptDir & '\pic.png') Then
		Dim $aINFCTRL[26]
		Local $nc = GUICtrlCreatePic('', $cx, $cy, 150, 150)
		Local $picjpg = @ScriptDir & '\pic.png'
		_SetImage($nc, $picjpg, 150, 150, -1)
		GUICtrlSetPos($nc, $cx, $cy, 150, 150)
;~ 		DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($nc), 'wstr', '', 'wstr', '')
		GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
		$aINFCTRL[0] = 'pic'
		$aINFCTRL[1] = 0 ;текст элемента
		$aINFCTRL[2] = $cx ;х координата
		$aINFCTRL[3] = $cy ;у координата
		$aINFCTRL[4] = 150 ;ширина
		$aINFCTRL[5] = 150 ;высота
		$aINFCTRL[6] = -1 ;стиль элемента
		$aINFCTRL[7] = -1 ; EX - стиль элемента
		$aINFCTRL[8] = 0 ;шрифт
		$aINFCTRL[9] = 64 ;состояние элемента (GuiCtrlSetState())
		$aINFCTRL[10] = 0 ;цвет текста - GuiCtrlSetColor
		$aINFCTRL[11] = 0 ;цвет фона - GuiCtrlSetBkColor
		$aINFCTRL[12] = @ScriptDir & '\pic.png' ;фоновая картинка - GuiCtrlSetImage
		$aINFCTRL[13] = BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT) ;поведение - GUICtrlSetResizing
		$aINFCTRL[14] = 0 ;функция элемента
		$aINFCTRL[25] = 16
		$objc.Add($nc, $aINFCTRL)
		_WinAPI_RedrawWindow($WOTP)
		_WinAPI_UpdateWindow($WOTP)
		_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
	EndIf
EndFunc   ;==>_CRPIC

Func _CRSTR()
	Dim $aINFCTRL[26]
	Local $nc = GUICtrlCreateLabel($JMPlangset[29], $cx, $cy, 150, 25)
	DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($nc), 'wstr', '', 'wstr', '')
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	GUICtrlSetFont(-1, 10, 800, 0, 'MS Sans Serif')
	GUICtrlSetBkColor($nc, 0xF0F0F0)
	GUICtrlSetColor(-1, 0x000000)
	$aINFCTRL[0] = 'label'
	$aINFCTRL[1] = $JMPlangset[29] ;текст элемента
	$aINFCTRL[2] = $cx ;х координата
	$aINFCTRL[3] = $cy ;у координата
	$aINFCTRL[4] = 150 ;ширина
	$aINFCTRL[5] = 25 ;высота
	$aINFCTRL[6] = -1 ;стиль элемента
	$aINFCTRL[7] = -1 ; EX - стиль элемента
	$aINFCTRL[8] = '10!800!0!MS Sans Serif' ;шрифт
	$aINFCTRL[9] = 64 ;состояние элемента (GuiCtrlSetState())
	$aINFCTRL[10] = 0x000000 ;цвет текста - GuiCtrlSetColor
	$aINFCTRL[11] = 0xF0F0F0 ;цвет фона - GuiCtrlSetBkColor
	$aINFCTRL[12] = 0 ;фоновая картинка - GuiCtrlSetImage
	$aINFCTRL[13] = BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT) ;поведение - GUICtrlSetResizing
	$aINFCTRL[14] = 0 ;функция элемента
	$aINFCTRL[25] = 16
	$objc.Add($nc, $aINFCTRL)
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
EndFunc   ;==>_CRSTR

Func _SetProgressDes()
	If Not $objc.Exists($tID) Then Return
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $getpercinf
	$getpercinf = $objc.Item($tID)
	$GuiPercD = GUICreate($JMPlangset[182], 297, 280, -1, -1, -1, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $GuiPercD)
	GUISetFont(9, 400, 0, 'Georgia', $GuiPercD)
	GUISetBkColor(0x88888F, $GuiPercD)
	Local $BCKLabel1 = GUICtrlCreateButton($JMPlangset[9], 8, 8, 156, 25)
	GUICtrlSetBkColor(-1, 0x808080)
	Local $Line1Label3 = GUICtrlCreateButton($JMPlangset[183], 8, 40, 156, 25)
	GUICtrlSetBkColor(-1, 0x808080)
	Local $Line2Button5 = GUICtrlCreateButton($JMPlangset[184], 8, 72, 156, 25)
	GUICtrlSetBkColor(-1, 0x808080)
	If $getpercinf[24] = 'barSC' Then GUICtrlSetState(-1, $GUI_DISABLE)
	Local $TextCButton7 = GUICtrlCreateButton($JMPlangset[185], 8, 104, 156, 25)
	GUICtrlSetBkColor(-1, 0x808080)
	If $getpercinf[24] = 'barSC' Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel('', 182, 6, 104, 29, 0x09)
	GUICtrlSetState(-1, 128)
	Local $Label2BK = GUICtrlCreateLabel('', 184, 8, 100, 25)
	GUICtrlSetBkColor(-1, $getpercinf[10])
	$BgColorGui = $getpercinf[10]
	GUICtrlCreateLabel('', 182, 38, 104, 29, 0x09)
	GUICtrlSetState(-1, 128)
	Local $Label4Line1 = GUICtrlCreateLabel('', 184, 40, 100, 25)
	GUICtrlSetBkColor(-1, $getpercinf[11])
	$FgBGColor = $getpercinf[11]
	GUICtrlCreateLabel('', 182, 70, 104, 29, 0x09)
	GUICtrlSetState(-1, 128)
	Local $Label6Line2 = GUICtrlCreateLabel('', 184, 72, 100, 25)
	GUICtrlSetBkColor(-1, $getpercinf[12])
	$BGColor = $getpercinf[12]
	Local $FontTLabel9 = GUICtrlCreateButton($JMPlangset[186], 8, 136, 156, 25)
	GUICtrlSetBkColor(-1, 0x808080)
	If $getpercinf[24] = 'barSC' Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel('', 182, 118, 104, 29, 0x09)
	GUICtrlSetState(-1, 128)
	Local $Label10 = GUICtrlCreateLabel('45%', 184, 120, 100, 25, 0x0201)
	GUICtrlSetFont(-1, 12, 400, 2, $getpercinf[8])
	$sFontProgress = $getpercinf[8]
	GUICtrlSetBkColor(-1, 0x808080)
	GUICtrlSetColor(-1, $getpercinf[7])
	$TextBGColor = $getpercinf[7]
	Local $Checkbox1 = GUICtrlCreateCheckbox($JMPlangset[187], 8, 168, 250, 25)
	GUICtrlSetState(-1, Number($getpercinf[6]))
	If $getpercinf[24] = 'barSC' Then GUICtrlSetState(-1, $GUI_DISABLE)
	$iVisPerc = $getpercinf[6]
	Local $Label11 = GUICtrlCreateLabel('', 8, 198, 281, 29, 0x09)
	GUICtrlSetState(-1, 128)
	$iPercId = GUICtrlCreatePic('', 10, 200, 278, 25)
	GUICtrlSetState(-1, 128)
	$WPerc = 278
	$HPerc = 25
	Local $Button1 = GUICtrlCreateButton($JMPlangset[188], 8, 240, 163, 25)
	GUICtrlSetBkColor(-1, 0x808080)
	GUICtrlSetColor(-1, 0xFFFFFF)
	If $getpercinf[24] = 'barSC' Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUISetState(@SW_SHOW, $GuiPercD)
	GUIRegisterMsg($WM_TIMER, 'PlayAnim')
	DllCall("user32.dll", "int", "SetTimer", "hwnd", $GuiPercD, "int", 0, "int", 30, "int", 0)
	Local $BKColorProgress = 0, $FontTextProgress
	$iPercData = 0
	While 1
		Switch GUIGetMsg()
			Case -3
				GUIRegisterMsg($WM_TIMER, '')
				_WinAPI_DeleteObject($hHBmp_BG)
				$objc.Item($tID) = $getpercinf
				GUIDelete($GuiPercD)
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				$GuiPercD = 0
				$iPercId = 0
				$iPercData = 0
				WinActivate($WOTP)
				Return
			Case $BCKLabel1
				$BKColorProgress = _clback($GuiPercD)
				If Not @error Then
					$BKColorProgress = Number($BKColorProgress)
					$BgColorGui = $BKColorProgress
					$getpercinf[10] = $BKColorProgress
					GUICtrlSetBkColor($Label2BK, $BKColorProgress)
					GUICtrlSetBkColor($tID, $BKColorProgress)
				EndIf
			Case $Line1Label3
				$BKColorProgress = _clback($GuiPercD)
				If Not @error Then
					$BKColorProgress = Number($BKColorProgress)
					$FgBGColor = $BKColorProgress
					$getpercinf[11] = $BKColorProgress
					GUICtrlSetBkColor($Label4Line1, $BKColorProgress)
					GUICtrlSetColor($tID, $FgBGColor)
				EndIf
			Case $Line2Button5
				$BKColorProgress = _clback($GuiPercD)
				If Not @error Then
					$BKColorProgress = Number($BKColorProgress)
					$BGColor = $BKColorProgress
					$getpercinf[12] = $BKColorProgress
					GUICtrlSetBkColor($Label6Line2, $BKColorProgress)
				EndIf
			Case $TextCButton7
				$BKColorProgress = _clback($GuiPercD)
				If Not @error Then
					$BKColorProgress = Number($BKColorProgress)
					$TextBGColor = $BKColorProgress
					$getpercinf[7] = $BKColorProgress
					GUICtrlSetColor($Label10, $BKColorProgress)
				EndIf
			Case $FontTLabel9
				$FontTextProgress = _font($GuiPercD, 0, $getpercinf[8])
				If Not @error Then
					$sFontProgress = $FontTextProgress[2]
					$getpercinf[8] = $FontTextProgress[2]
					GUICtrlSetFont($Label10, 12, Default, $FontTextProgress[1], $FontTextProgress[2])
				EndIf
			Case $Checkbox1
				If GUICtrlRead($Checkbox1) = 1 Then
					$getpercinf[6] = 1
					$iVisPerc = 1
				Else
					$getpercinf[6] = 0
					$iVisPerc = 0
				EndIf
			Case $Button1
				If $iPercData > 0 Then
					$iPercData = 0
				ElseIf $iPercData = 0 Then
					$iPercData = 1
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>_SetProgressDes

Func _SelectProgressbar()
	If Not $objc.Exists($tID) Then Return
	Opt("GUIOnEventMode", 0)
	Opt('GUICloseOnESC', 1)
	Local $getpercinf
	$getpercinf = $objc.Item($tID)
	Local $hchProgressBar = GUICreate($JMPlangset[234], 240, 100, -1, -1, -1, $WS_EX_TOOLWINDOW, $WOTP)
	GUISetIcon(@ScriptDir & '\jmpack.ico', '', $hchProgressBar)
	GUISetFont(9, 400, 0, 'Georgia', $hchProgressBar)
	GUISetBkColor(0x88888F, $hchProgressBar)
	Local $iStandartColor = GUICtrlCreateRadio($JMPlangset[232], 20, 30, 160, 20)
	If $getpercinf[24] = 'barSC' Then GUICtrlSetState(-1, 1)
	Local $iAnimated = GUICtrlCreateRadio($JMPlangset[233], 20, 60, 145, 20)
	If $getpercinf[24] = 'barA' Then GUICtrlSetState(-1, 1)
	GUISetState(@SW_SHOW, $hchProgressBar)
	Local $nmsg
	While 1
		$nmsg = GUIGetMsg()
		Switch $nmsg
			Case -3
				GUIDelete($hchProgressBar)
				WinActivate($WOTP)
				Opt("GUIOnEventMode", 1)
				Opt('GUICloseOnESC', 0)
				$getpercinf[24] = $SelectProgressbar
				$objc.Item($tID) = $getpercinf
				Return
			Case $iStandartColor
				$SelectProgressbar = 'barSC'
				DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($tID), 'wstr', '', 'wstr', '')
				GUICtrlSetData($tID, 50)
			Case $iAnimated
				$SelectProgressbar = 'barA'
				DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($tID), 'wstr', '', 'wstr', '')
				GUICtrlSetData($tID, 50)
		EndSwitch
	WEnd
EndFunc   ;==>_SelectProgressbar

Func PlayAnim()
	$hHBmp_BG = _GDIPlus_StripProgressbar($iPercData, $WPerc, $HPerc, $iVisPerc, $BgColorGui, $FgBGColor, $BGColor, $TextBGColor, $sFontProgress)
	Local $hB = GUICtrlSendMsg($iPercId, 0x0172, 0, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
	If $iPercData Then
		$iPercData += 1
		If $iPercData >= 100 Then $iPercData = 1
	EndIf
EndFunc   ;==>PlayAnim

Func _CRPR()
	Dim $aINFCTRL[26]
	Local $iNewProgressID = GUICtrlCreateProgress($cx, $cy, 300, 25)
	GUICtrlSetResizing($iNewProgressID, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	GUICtrlSetData($iNewProgressID, 50)
	GUICtrlSetBkColor($iNewProgressID, $BgColorGui)
	GUICtrlSetColor($iNewProgressID, $FgBGColor)
	$aINFCTRL[0] = 'progress'
	$aINFCTRL[1] = 0 ;текст элемента
	$aINFCTRL[2] = $cx ;х координата
	$aINFCTRL[3] = $cy ;у координата
	$aINFCTRL[4] = 300 ;ширина
	$aINFCTRL[5] = 25 ;высота
	$aINFCTRL[6] = $iVisPerc ;отображать\не отображать цифры процента прогресса
	$aINFCTRL[7] = $TextBGColor ;цвет текста
	$aINFCTRL[8] = $sFontProgress ;шрифт _font() индекс [2]
	$aINFCTRL[9] = 64 ;состояние элемента (GuiCtrlSetState())
	$aINFCTRL[10] = $BgColorGui ;цвет фона
	$aINFCTRL[11] = $FgBGColor ; цвет полосы 1
	$aINFCTRL[12] = $BGColor ;цвет полосы 2
	$aINFCTRL[13] = BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT) ;поведение - GUICtrlSetResizing
	$aINFCTRL[14] = 'perc'
	$aINFCTRL[24] = 'barS'
	$aINFCTRL[25] = 16
	$objc.Add($iNewProgressID, $aINFCTRL)
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
	$oMod.Add('perc', $iNewProgressID)
EndFunc   ;==>_CRPR

Func _CRCHK()
	Dim $aINFCTRL[26]
	Local $nc = GUICtrlCreateCheckbox($JMPlangset[27], $cx, $cy, 115, 15)
	DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($nc), 'wstr', '', 'wstr', '')
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	GUICtrlSetFont(-1, 10, 800, 0, 'MS Sans Serif')
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x000000)
	$aINFCTRL[0] = 'checkbox'
	$aINFCTRL[1] = $JMPlangset[27] ;текст элемента
	$aINFCTRL[2] = $cx ;х координата
	$aINFCTRL[3] = $cy ;у координата
	$aINFCTRL[4] = 115 ;ширина
	$aINFCTRL[5] = 15 ;высота
	$aINFCTRL[6] = -1 ;стиль элемента
	$aINFCTRL[7] = -1 ; EX - стиль элемента
	$aINFCTRL[8] = '10!800!0!MS Sans Serif' ;шрифт
	$aINFCTRL[9] = 64 ;состояние элемента (GuiCtrlSetState())
	$aINFCTRL[10] = 0x000000 ;цвет текста - GuiCtrlSetColor
	$aINFCTRL[11] = $GUI_BKCOLOR_TRANSPARENT ;цвет фона - GuiCtrlSetBkColor
	$aINFCTRL[12] = 0 ;фоновая картинка - GuiCtrlSetImage
	$aINFCTRL[13] = BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT) ;поведение - GUICtrlSetResizing
	$aINFCTRL[14] = 0 ;функция элемента
	$aINFCTRL[15] = 4 ;визуальная отметка 1- есть, 4 - нет.
	$aINFCTRL[25] = 16
	$objc.Add($nc, $aINFCTRL)
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
EndFunc   ;==>_CRCHK

Func _CRTV()
	Dim $aINFCTRL[26]
	Local $nc = GUICtrlCreateTreeView($cx, $cy, 300, 300, BitOR($TVS_DISABLEDRAGDROP, $TVS_TRACKSELECT, $TVS_NOTOOLTIPS, $TVS_EDITLABELS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_HASBUTTONS))
;~ 	DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($nc), 'wstr', '', 'wstr', '')
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
	GUICtrlSetFont(-1, 10, 800, 0, 'MS Sans Serif')
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xFFFFFF)
	$aINFCTRL[0] = 'treeview'
	$aINFCTRL[1] = $CurGui ;номер страницы проекта
	$aINFCTRL[2] = $cx ;х координата
	$aINFCTRL[3] = $cy ;у координата
	$aINFCTRL[4] = 300 ;ширина
	$aINFCTRL[5] = 300 ;высота
	$aINFCTRL[6] = BitOR($TVS_DISABLEDRAGDROP, $TVS_NOTOOLTIPS, $TVS_EDITLABELS, $TVS_TRACKSELECT, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_HASBUTTONS) ;стиль элемента
	$aINFCTRL[7] = -1 ; EX - стиль элемента
	$aINFCTRL[8] = '10!800!0!MS Sans Serif' ;шрифт
	$aINFCTRL[9] = 64 ;состояние элемента (GuiCtrlSetState())
	$aINFCTRL[10] = 0xFFFFFF ;цвет текста - GuiCtrlSetColor
	$aINFCTRL[11] = 0x000000 ;цвет фона - GuiCtrlSetBkColor
	$aINFCTRL[12] = 0 ;фоновая картинка - GuiCtrlSetImage
	$aINFCTRL[13] = BitOR($GUI_DOCKWIDTH, $GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT) ;поведение - GUICtrlSetResizing
	$aINFCTRL[14] = 0 ;функция элемента
	$aINFCTRL[25] = 16
	$objc.Add($nc, $aINFCTRL)
	Local $aIco[4] = [@ScriptDir & '\chk.ico', @ScriptDir & '\unchk.ico', @ScriptDir & '\rd.ico', @ScriptDir & '\unrd.ico']
	_GUITreeViewEx_InitTV($nc)
	_GUITreeViewEx_TvImg($nc, $aIco)
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
EndFunc   ;==>_CRTV
