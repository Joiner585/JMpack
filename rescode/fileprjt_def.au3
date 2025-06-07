#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=fileprjt.a3x
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <UDF\MNOBJST.au3>
Opt('GUICloseOnESC', 0)
Opt('TrayMenuMode', 1)
Opt('MustDeclareVars', 1)
;---------------------------------------------------------

Global $SelectProgressbar

_EXF()

_CurGui()

Func _WinExFF()
	_GDIPlus_Startup()
	Local $hImage = _GDIPlus_ImageLoadFromFile($wkdir & '\flash.png')
	If @error Then
		_GDIPlus_Shutdown()
		Return SetError(1)
	EndIf
	Local $XW = _GDIPlus_ImageGetWidth($hImage)
	Local $YH = _GDIPlus_ImageGetHeight($hImage)
	$FlashGui = GUICreate('', $XW, $YH, -1, -1, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_LAYERED, $WS_EX_TOPMOST))
	GUISetState()
	Local $hScrDC = _WinAPI_GetDC($FlashGui)
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
		_WinAPI_UpdateLayeredWindow($FlashGui, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
		Sleep(30)
	Next
	Sleep(2000)
	For $i = 255 To 0 Step -5
		DllStructSetData($tBlend, 'Alpha', $i)
		_WinAPI_UpdateLayeredWindow($FlashGui, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
		Sleep(30)
	Next
	GUIDelete($FlashGui)
	_GDIPlus_ImageDispose($hImage)
	_WinAPI_ReleaseDC($FlashGui, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
	_GDIPlus_Shutdown()
EndFunc   ;==>_WinExFF

Func _EXF()
	_BASS_STARTUP($wkdir & '\bass.dll')
	_BASS_Init(0, -1, 44100, 0, '')
	If FileExists($playbck) Then
		$MusicHandleBck = _BASS_StreamCreateFile(False, $playbck, 0, 0, $BASS_SAMPLE_LOOP)
		_BASS_ChannelPlay($MusicHandleBck, 1)
	EndIf
	If FileExists($wkdir & '\flash.png') Then _WinExFF()
	Local $sIniReadVer = IniRead($wkdir & '\page0.jmp3', 'Windows', '0', '')
	Local $aSPLinfo = StringSplit($sIniReadVer, '<>', 3)
	If UBound($aSPLinfo) <> 11 Then
		Exit MsgBox(16, 'Start', $Instjmplang[29])
	Else
		$sNameG = $aSPLinfo[7]
	EndIf
	Switch $sNameG
		Case 'Wargaming'
			$GetPathExe = 'WorldofTanks.exe'
		Case 'Lesta'
			$GetPathExe = 'Tanki.exe'
	EndSwitch
	Local $SplitGamePV = StringSplit($aSPLinfo[8], '|', 3)
	$setpathgame = _CGW($GetPathExe, $SplitGamePV[1])
	If $setpathgame = '' Then MsgBox(64, 'Path', $Instjmplang[0])
	_LOADPJT($wkdir)
EndFunc   ;==>_EXF

Func _CurGui()
	Local $getg = $objw.Item(0)
	$backlight = Number($getg[9])
	If $backlight = 3 Then $backlightcolor = Number($getg[10])
	Local $sIniReadVer = IniRead($wkdir & '\page0.jmp3', 'Windows', '0', '')
	Local $aSPLinfo = StringSplit($sIniReadVer, '<>', 3)
	If UBound($aSPLinfo) <> 11 Then
		Exit MsgBox(16, 'Start', $Instjmplang[29])
	Else
		$sNameG = $aSPLinfo[7]
	EndIf
	Switch $sNameG
		Case 'Wargaming'
			$GetPathExe = 'WorldofTanks.exe'
		Case 'Lesta'
			$GetPathExe = 'Tanki.exe'
	EndSwitch
	Local $SplitGamePV = StringSplit($aSPLinfo[8], '|', 3)
	$setpathgame = _CGW($GetPathExe, $SplitGamePV[1])
	If $setpathgame = '' Then MsgBox(64, 'Path', $Instjmplang[0])
	If $oMod.Exists('path') Then
		Local $stpath = $oMod.Item('path')
		GUICtrlSetData($stpath, $setpathgame)
	EndIf
	If FileExists($curani) Then
		$setcur = $curani
	ElseIf FileExists($curc) Then
		$setcur = $curc
	EndIf
	If $setcur Then
		$g_hCursor = _WinAPI_LoadCursorFromFile($setcur)
		_WinAPI_SetCursor($g_hCursor)
	EndIf
	If FileExists($force_a) Then
		$actcur = $force_a
	ElseIf FileExists($force_c) Then
		$actcur = $force_c
	EndIf
	If $actcur Then $g_hCursorLight = _WinAPI_LoadCursorFromFile($actcur)
	If $nExistsTV > -1 Then
		_CreateTVLoad()
	Else
		$flpg = 1
	EndIf
	_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
	GUISetIcon($PathSFX, '', $WOTP)
	GUISetState(@SW_SHOW, $WOTP)
	GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
	GUIRegisterMsg($WM_SETCURSOR, 'WM_SETCURSOR')
	GUIRegisterMsg($WM_MOUSEWHEEL, 'WM_MOUSEWHEEL')
	GUIRegisterMsg(0x0006, "WM_ACTIVATE")
	WinActivate($WOTP)
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
	While 1
		If $nflagsetimgtv Then
			$nflagsetimgtv = 0
			_GUITreeViewEx_GetHItem()
		EndIf
		If $flfunc <> '' Then
			Switch String($flfunc)
				Case 'chpath'
					If Not $flinstset Then _CHPATH()
				Case 'inst'
					If Not $flinstset Then
						If $iPercId Then
							If Not $SelectProgressbar Then AdlibRegister('PlayAnim', 100)
						EndIf
						_INST()
					EndIf
				Case 'close'
					If Not $flinstset Then
						AdlibUnRegister('PlayAnim')
						GUIDelete($WOTP)
						_StopSound()
						_DirRemove(1)
						Exit
					EndIf
			EndSwitch
			$flfunc = ''
		EndIf
		Sleep(10)
	WEnd
EndFunc   ;==>_CurGui

Func PlayAnim()
	$hHBmp_BG = _GDIPlus_StripProgressbar($iPercData, $WPerc, $HPerc, $iVisPerc, $BgColorGui, $FgBGColor, $BGColor, $TextBGColor, $sFontProgress)
	Local $hB = GUICtrlSendMsg($iPercId, 0x0172, 0, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
EndFunc   ;==>PlayAnim

Func _CLC()
	Local $sPathCaches = ''
	Switch $GetPathExe
		Case 'WorldofTanks.exe'
			$sPathCaches = @AppDataDir & '\Wargaming.net\WorldOfTanks'
		Case 'Tanki.exe'
			$sPathCaches = @AppDataDir & '\Lesta\MirTankov'
	EndSwitch
	If Not FileExists($sPathCaches) Then Return
	Local $flcash
	If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[0])
	Local $aResCash = _FFSearch($sPathCaches, '', 4)
	If Not @error Then
		For $i = 1 To UBound($aResCash) - 1
			If StringInStr($aResCash[$i], 'account_caches') Then ContinueLoop
			$flcash = _FFSearch($aResCash[$i], '', 1)
			If Not @error Then
				For $d = 1 To UBound($flcash) - 1
					FileDelete($flcash[$d])
				Next
			EndIf
			DirRemove($aResCash[$i], 1)
		Next
	EndIf
EndFunc   ;==>_CLC

Func _CHPATH()
	Local $odg = FileSelectFolder($Instjmplang[2], @HomeDrive, 0, '', $WOTP)
	If Not @error Then
		$setpathgame = $odg
		If $oMod.Exists('path') Then
			Local $stpath = $oMod.Item('path')
			GUICtrlSetData($stpath, $setpathgame)
		EndIf
	Else
		Return SetError(1)
	EndIf
EndFunc   ;==>_CHPATH

Func _GetInfoMod()
	$sListModsF = ''
	Local $getst, $gtm, $objc1
	Local $infpg = $oSNW.Keys()
	For $pg In $infpg
		$objc1 = $OSNW.Item($pg)[1]
		$gtm = $objc1.Keys()
		If Not IsArray($gtm) Then ContinueLoop
		For $i In $gtm
			$getst = $objc1.Item($i)
			Switch String($getst[0])
				Case 'mod'
					If $getst[23] = 1 Or GUICtrlRead($i) = 1 Then
						$clip &= $getst[14] & @CRLF
						If Not (String($getst[18]) == '0') Then
							_ArrayAdd($exmods, $getst[14] & '.7z')
							If FileExists($wkdir & '\' & $getst[14] & '.txt') Then $sListModsF &= FileRead($wkdir & '\' & $getst[14] & '.txt') & @LF
							_ArrayAdd($sNameMod, StringReplace(StringReplace($getst[1], '\n', @CRLF), '\h', ' '))
						EndIf
						If Not (String($getst[21]) == '0') Then
							If FileExists($wkdir & '\' & $getst[14] & '.ttf') Then
								_ArrayAdd($ALLTTF, $wkdir & '\' & $getst[14] & '.ttf')
							ElseIf FileExists($wkdir & '\' & $getst[14] & '.otf') Then
								_ArrayAdd($ALLTTF, $wkdir & '\' & $getst[14] & '.otf')
							EndIf
						EndIf
					EndIf
			EndSwitch
		Next
	Next
EndFunc   ;==>_GetInfoMod

Func _BACKUP()
	If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[3])
	Local $nmbp, $allsz
	While 1
		$nmbp = Random(10, 1000, 1)
		If Not FileExists($setpathgame & '\backup_' & $nmbp) Then ExitLoop
	WEnd
	$nmbp = $setpathgame & '\backup_' & $nmbp
	If FileExists($setpathgame & '\mods') Then $allsz += (DirGetSize($setpathgame & '\mods', 1))[1]
	If FileExists($setpathgame & '\res_mods') Then $allsz += (DirGetSize($setpathgame & '\res_mods', 1))[1]
	Local $repld, $cpcount
	Local $gtmods = _FFSearch($setpathgame & '\mods', '', 1)
	If Not @error Then
		For $i = 1 To $gtmods[0]
			$repld = StringReplace($gtmods[$i], $setpathgame, $nmbp)
			FileCopy($gtmods[$i], $repld, 9)
			$cpcount += 1
			$iPercData = Floor($cpcount / $allsz * 100)
			GUICtrlSetData($iPercId, $iPercData)
		Next
	EndIf
	Local $gtrmods = _FFSearch($setpathgame & '\res_mods', '', 1)
	If Not @error Then
		For $i = 1 To $gtrmods[0]
			$repld = StringReplace($gtrmods[$i], $setpathgame, $nmbp)
			FileCopy($gtrmods[$i], $repld, 9)
			$cpcount += 1
			$iPercData = Floor($cpcount / $allsz * 100)
			GUICtrlSetData($iPercId, $iPercData)
		Next
	EndIf
EndFunc   ;==>_BACKUP

Func _INST()
	If Not FileExists($setpathgame) Then
		Return MsgBox(64, '', $Instjmplang[0], 0, $WOTP)
	EndIf
	$flinstset = 1
	If $nExistsTV = -1 Then
		_GetInfoMod()
	Else
		_GetInfoModTV()
	EndIf
	If UBound($exmods) = 0 Then
		$flinstset = 0
		$clip = ''
		Dim $ALLTTF[0]
		Dim $sNameMod[0]
		Return MsgBox(64, '', $Instjmplang[4], 0, $WOTP)
	EndIf
	If $curidpos Then
		Local $setoldid = $objc.Item($curidpos)
		If UBound($setoldid) = 26 Then
			If $backlight = 2 Then
				Local $gp1 = ControlGetPos($WOTP, '', $curidpos)
				Switch String($setoldid[0])
					Case 'label', 'checkbox'
						Local $setnewid = StringSplit($setoldid[8], '!')
						GUICtrlSetFont($curidpos, $setnewid[1], $setnewid[2], $setnewid[3], $setnewid[4])
				EndSwitch
				GUICtrlSetPos($curidpos, $gp1[0] + 2, $gp1[1] + 2, $gp1[2] - 4, $gp1[3] - 4)
			ElseIf $backlight = 3 Then
				Switch String($setoldid[0])
					Case 'label', 'checkbox'
						GUICtrlSetBkColor($curidpos, Number($setoldid[11]))
				EndSwitch
			EndIf
		EndIf
		$curidpos = 0
	EndIf
	If $oSNW.Exists('page' & $CurGui + 1) Then _PAGEBN(1)
	If $flbackup Then _BACKUP()
	;------------------------------------
	If $flclcash Then _CLC()
	_DirRemove()
	_EXMOD()
	If @error Then
		Local $splw, $oneP, $delcurfule
		If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[5])
		Local $error = @error
		If $aWrex <> '' Then
;~ 			$aWrex = _OEM2ANSI($aWrex)
			$splw = StringSplit($aWrex, @LF, 3)
			$delcurfule = UBound($splw)
			For $i = 0 To $delcurfule - 1
				$oneP += $i
				FileDelete($splw[$i])
				$iPercData = Floor($oneP / $delcurfule * 100)
				GUICtrlSetData($iPercId, $iPercData)
			Next
		EndIf
		If $sBackupFiles <> '' Then
;~ 			$sBackupFiles = _OEM2ANSI($sBackupFiles)
			$splw = StringSplit($sBackupFiles, @LF, 3)
			$delcurfule = UBound($splw)
			For $i = 0 To $delcurfule - 1
				$oneP += $i
				FileMove($splw[$i], StringTrimRight($splw[$i], 4), 1)
				$iPercData = Floor($oneP / $delcurfule * 100)
				GUICtrlSetData($iPercId, $iPercData)
			Next
		EndIf
		If $oSNW.Exists('page' & $CurGui + 1) Then _PAGEBN(1)
		$iPercData = 0
		GUICtrlSetData($iPercId, $iPercData)
		AdlibUnRegister('PlayAnim')
		Switch $error
			Case -1, -2
				If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[6])
				$iPercData = 0
				GUICtrlSetData($iPercId, $iPercData)
				$flinstset = 0
				$clip = ''
				Dim $ALLTTF[0]
				Dim $exmods[0]
				Dim $sNameMod[0]
				Return MsgBox(16, '', $Instjmplang[7] & @CRLF & $Instjmplang[8] & ' - ' & $error, 0, $WOTP)
			Case 1
				If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[6])
				$iPercData = 0
				GUICtrlSetData($iPercId, $iPercData)
				$flinstset = 0
				$clip = ''
				Dim $ALLTTF[0]
				Dim $exmods[0]
				Dim $sNameMod[0]
				Return
		EndSwitch
	EndIf
	;----------------------------------------
	_COPYMODS()
	If @error Then
		Local $splw, $error = @error, $oneP, $delcurfule
		If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[5])
		If $aWrex <> '' Then
;~ 			$aWrex = _OEM2ANSI($aWrex)
			$splw = StringSplit($aWrex, @LF, 3)
			$delcurfule = UBound($splw)
			For $i = 0 To $delcurfule - 1
				$oneP += $i
				FileDelete($splw[$i])
				$iPercData = Floor($oneP / $delcurfule * 100)
				GUICtrlSetData($iPercId, $iPercData)
			Next
		EndIf
		If $sBackupFiles <> '' Then
;~ 			$sBackupFiles = _OEM2ANSI($sBackupFiles)
			$splw = StringSplit($sBackupFiles, @LF, 3)
			$delcurfule = UBound($splw)
			For $i = 0 To $delcurfule - 1
				$oneP += $i
				FileMove($splw[$i], StringTrimRight($splw[$i], 4), 1)
				$iPercData = Floor($oneP / $delcurfule * 100)
				GUICtrlSetData($iPercId, $iPercData)
			Next
		EndIf
		$iPercData = 0
		GUICtrlSetData($iPercId, $iPercData)
		If $oSNW.Exists('page' & $CurGui + 1) Then _PAGEBN(1)
		If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[6])
		AdlibUnRegister('PlayAnim')
		Switch $error
			Case -1, -2
				MsgBox(16, '', $Instjmplang[9] & @CRLF & $Instjmplang[8] & ' - ' & $error, 0, $WOTP)
		EndSwitch
	Else
;~ 		If $setunmod Then
		If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[10])
		Local $gtprname = StringStripWS(FileGetVersion($PathSFX, 'ProductName'), 3)
		Local $unmod, $unico
		If $gtprname = '' Then
			$unmod = $setpathgame & '\ModPack ' & $sNameG & ' ver.' & $VerGameInst
			If FileExists($unmod) Then DirRemove($unmod, 1)
			$gtprname = 'ModPack ' & $sNameG & ' ver.' & $VerGameInst
		Else
			$unmod = $setpathgame & '\' & $gtprname
			If FileExists($unmod) Then DirRemove($unmod, 1)
		EndIf
		DirCreate($unmod)
		FileCopy($wkdir & '\AutoIt3.exe', $unmod & '\AutoIt3.exe', 1)
		FileCopy($wkdir & '\unmod.a3x', $unmod & '\unmod.a3x', 1)
		FileCopy($wkdir & '\unmod.png', $unmod & '\unmod.png', 1)
		FileCopy($wkdir & '\lang.txt', $unmod & '\lang.txt', 1)
		Local $aver[3][2] = [['1', $setpathgame], ['2', $gtprname], ['3', $VerGameInst]]
		IniWriteSection($unmod & '\unmod.ini', 'pathgm', $aver, 0)
		If $aWrex <> '' Then
;~ 			$aWrex = _OEM2ANSI($aWrex)
			FileWrite($unmod & '\Dfile.ini', $aWrex)
		EndIf
		If $sBackupFiles <> '' Then
;~ 			$sBackupFiles = _OEM2ANSI($sBackupFiles)
			FileWrite($unmod & '\Bfile.ini', $sBackupFiles)
		EndIf
		If FileExists($wkdir & '\uninst.ico') Then
			FileCopy($wkdir & '\uninst.ico', $unmod & '\uninst.ico', 1)
			$unico = $unmod & '\uninst.ico'
		Else
			$unico = $unmod & '\AutoIt3.exe'
		EndIf
		FileCreateShortcut($unmod & '\AutoIt3.exe', @DesktopDir & '\' & $gtprname & '.lnk', $unmod, '"unmod.a3x"', $Instjmplang[11] & ' ' & $gtprname, $unico)
	EndIf
	AdlibUnRegister('PlayAnim')
	If $oSNW.Exists('page' & $CurGui + 1) Then _PAGEBN(1)
	If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[12])
;~ 	EndIf
	$iPercData = 0
	GUICtrlSetData($iPercId, $iPercData)
	$flinstset = 0
	$clip = ''
	Dim $ALLTTF[0]
	Dim $exmods[0]
	Dim $sNameMod[0]
EndFunc   ;==>_INST

Func _EXMOD()
	If UBound($exmods) = 0 Then Return
	If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[13])
;~ извлечение InnoSetup
;~ ------------------------------------------------------------------------------------------------------------------
	_FileWriteFromArray($wkdir & '\path.txt', $exmods)
	Local $flMutex = _WinAPI_CreateMutex('jmunpack7z')
	Local $alist7z
	If FileExists($wkdir & '\list7z') Then $alist7z = FileReadToArray($wkdir & '\list7z')
	Local $iAllC7z = UBound($alist7z)
	Local $sCurSet7z = '', $iCount7z = 1, $i7z = 0
	While 1
		If $iAllC7z Then
			If FileExists($wkdir & '\' & $alist7z[$i7z]) Then
				If Not ($sCurSet7z = $alist7z[$i7z]) Then
					$iPercData = Floor($iCount7z / $iAllC7z * 100)
					GUICtrlSetData($iPercId, $iPercData)
					$i7z += 1
					$iCount7z += 1
					$sCurSet7z = $alist7z[$i7z]
				EndIf
			EndIf
		EndIf
		Sleep(10)
		If _WinAPI_OpenMutex('jmpack_end_unzip') Then ExitLoop
	WEnd
	$iPercData = 100
	GUICtrlSetData($iPercId, $iPercData)
;~ ------------------------------------------------------------------------------------------------------------------
	If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[14])
	Local $arch, $osz, $szFileName, $7zRead
	If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[15])
	$sListModsF = StringTrimRight($sListModsF, 1)
	Local $SplLf = StringSplit($sListModsF, @LF), $aszFileName, $GetCountPath, $sStringPathTanki
	For $i = 1 To $SplLf[0]
		$sStringPathTanki &= $setpathgame & '\' & $SplLf[$i] & @LF
		$iPercData = Floor($i / $SplLf[0] * 100)
		GUICtrlSetData($iPercId, $iPercData)
	Next
	$sStringPathTanki = StringTrimRight($sStringPathTanki, 1)
	$aszFileName = StringSplit($sStringPathTanki, @LF, 3)
	If $aszFileName[0] = '' Then Return SetError(-5)
	Local $nCountMvF = UBound($aszFileName) - 1
	For $i = 0 To $nCountMvF
		If $stoppr Then
			$stoppr = 0
			Return SetError(1)
		EndIf
		If FileExists($aszFileName[$i]) Then
			FileMove($aszFileName[$i], $aszFileName[$i] & 'jmp3', 1)
			$sBackupFiles &= $aszFileName[$i] & 'jmp3' & @LF
		Else
			$aWrex &= $aszFileName[$i] & @LF
		EndIf
		$iPercData = Floor($i / $nCountMvF * 100)
		GUICtrlSetData($iPercId, $iPercData)
	Next
	$iPercData = 100
	GUICtrlSetData($iPercId, $iPercData)
	Sleep(500)
EndFunc   ;==>_EXMOD

Func _COPYMODS()
	Local $aProgperc[UBound($exmods)], $allsizearc, $curmods
	For $i = 0 To UBound($exmods) - 1
		$allsizearc += FileGetSize(StringReplace($exmods[$i], '"', ''))
	Next
	Local $OneAllPerc = $allsizearc / 100
	For $i = 0 To UBound($exmods) - 1
		$curmods = FileGetSize(StringReplace($exmods[$i], '"', ''))
		$aProgperc[$i] = $curmods / $OneAllPerc
	Next
	Local $curentPerc = 0, $percpart
	$iPercData = 0
	GUICtrlSetData($iPercId, $iPercData)
	Local $pr7za, $7zRead, $7zproc
	For $i = 0 To UBound($exmods) - 1
		$percpart = 100 / $aProgperc[$i]
		If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $sNameMod[$i])
		$7zRead = ''
		$pr7za = Run($7zaPath & ' x -bsp2 -pshooting_at_slip "' & $wkdir & '\' & $exmods[$i] & '" -o"' & $setpathgame & '"' & ' -y -r0 -aoa', '', @SW_HIDE, 0x8)
		If @error Then Return SetError(-1)
		While Sleep(1)
			If $stoppr Then
				$stoppr = 0
				ProcessClose($pr7za)
				Return SetError(1)
			EndIf
			$7zRead = StdoutRead($pr7za)
			If @error Then
				ProcessClose($pr7za)
				ExitLoop 1
			EndIf
			If $7zRead <> '' Then
				If StringInStr($7zRead, 'System ERROR') Then
					FileWrite(@ScriptDir & '\Error7z.txt', 'copymod' & @LF & $7zRead & @LF & $7zaPath & @LF & $exmods[$i] & @LF & $setpathgame & @LF)
					Return SetError(-2)
				EndIf
				$7zproc = Number(StringRegExpReplace($7zRead, '(.*?)%.*', '\1'))
				If $7zproc > 0 Then
					$iPercData = $7zproc / $percpart + $curentPerc
					GUICtrlSetData($iPercId, $iPercData)
				EndIf
			EndIf
		WEnd
		$curentPerc += $aProgperc[$i]
	Next
	$iPercData = 100
	GUICtrlSetData($iPercId, $iPercData)
	Sleep(500)
	If UBound($ALLTTF) > 0 Then
		If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[16])
		For $i = 0 To UBound($ALLTTF) - 1
			_FontInstall($ALLTTF[$i])
			$iPercData = Floor($i / (UBound($ALLTTF) - 1) * 100)
			GUICtrlSetData($iPercId, $iPercData)
		Next
		$iPercData = 100
		GUICtrlSetData($iPercId, $iPercData)
		Sleep(500)
	EndIf
	If FileExists($wkdir & '\rwconf.txt') Then
		If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[17])
		_RWCONF($clip)
		If @error Then Return SetError(@error)
	EndIf
EndFunc   ;==>_COPYMODS

Func _RWCONF($sCHK)
	$sCHK = StringTrimRight($sCHK, 2)
	If $sCHK == '' Then
		Return SetError(-1)
	EndIf
	Local $setconf = $wkdir & '\rwconf.txt'
	Local $aArrays[0][3], $rdcel, $rdpt, $flenc, $fo
	Local $flarsh, $rd, $d = 0
	Local $spls = StringSplit($sCHK, @CRLF, 3)
	For $i = 0 To UBound($spls) - 1
		$rdpt = IniRead($setconf, 'path', $spls[$i], '')
		If $rdpt <> '' Then
			If FileExists($setpathgame & '\' & $rdpt) Then
				For $s = 0 To UBound($aArrays) - 1
					If Not StringCompare($rdpt, $aArrays[$s][0]) Then $flarsh = 1
				Next
				If Not $flarsh Then
					$flenc = FileGetEncoding($setpathgame & '\' & $rdpt)
					$fo = FileOpen($setpathgame & '\' & $rdpt, $flenc)
					$rdcel = FileReadToArray($fo)
					FileClose($fo)
					If Not IsArray($rdcel) Then
						MsgBox(16, '1', $Instjmplang[18] & @CRLF & $setpathgame & '\' & $rdpt, 0, $WOTP)
						Return SetError(1)
					EndIf
					ReDim $aArrays[$rd + 1][3]
					$aArrays[$d][0] = $rdpt
					$aArrays[$d][1] = $flenc
					$aArrays[$d][2] = $rdcel
					$rd += 1
					$d += 1
				Else
					$flarsh = 0
				EndIf
			Else
				MsgBox(16, '2', $Instjmplang[19] & @CRLF & $setpathgame & '\' & $rdpt, 0, $WOTP)
				Return SetError(2)
			EndIf
		EndIf
	Next
	Local $rsfr, $arf, $cstr, $ind
	For $i = 0 To UBound($spls) - 1
		$rdpt = IniRead($setconf, 'path', $spls[$i], '')
		If $rdpt <> '' Then
			For $s = 0 To UBound($aArrays) - 1
				If Not StringCompare($rdpt, $aArrays[$s][0]) Then
					$ind = $s
					$arf = $aArrays[$s][2]
				EndIf
			Next
			$rsfr = IniReadSection($setconf, $spls[$i])
			If Not @error Then
				For $r = 1 To $rsfr[0][0]
					$cstr = StringTrimRight($rsfr[$r][1], 6)
					Switch StringRight($rsfr[$r][1], 1)
						Case '0'
							$arf[Number($rsfr[$r][0]) - 1] = $arf[Number($rsfr[$r][0]) - 1] & @CRLF & StringReplace($cstr, '&jmp&', @CRLF)
							$aArrays[$ind][2] = $arf
						Case '1'
							$arf[Number($rsfr[$r][0]) - 1] = StringReplace($cstr, '&jmp&', @CRLF)
							$aArrays[$ind][2] = $arf
					EndSwitch
				Next
			EndIf
		EndIf
	Next
	Local $newtxt
	For $i = 0 To UBound($aArrays) - 1
		$newtxt = _ArrayToString($aArrays[$i][2], @CRLF)
		$fo = FileOpen($setpathgame & '\' & $aArrays[$i][0], $aArrays[$i][1] + 2)
		If $fo = -1 Then
			MsgBox(16, '3', 'Ошибка записи файла ' & @CRLF & $setpathgame & '\' & $aArrays[$i][0], 0, $WOTP)
			Return SetError(3)
		EndIf
		FileWrite($fo, $newtxt)
		FileClose($fo)
	Next
EndFunc   ;==>_RWCONF

Func _DirRemove($FLR = 0)
	Local $szrmv, $adelf[0], $allfr, $curdel
	If Not $FLR Then
		If $flclmods Then
			If FileExists($setpathgame & '\mods') Then
				$szrmv += (DirGetSize($setpathgame & '\mods', 1))[1]
				_ArrayAdd($adelf, $setpathgame & '\mods')
			EndIf
		EndIf
		If $flclresmods Then
			If FileExists($setpathgame & '\res_mods') Then
				$szrmv += (DirGetSize($setpathgame & '\res_mods', 1))[1]
				_ArrayAdd($adelf, $setpathgame & '\res_mods')
			EndIf
		EndIf
		If $flclmrm Then
			If FileExists($setpathgame & '\mods') Then
				$szrmv += (DirGetSize($setpathgame & '\mods', 1))[1]
				_ArrayAdd($adelf, $setpathgame & '\mods')
			EndIf
			If FileExists($setpathgame & '\res_mods') Then
				$szrmv += (DirGetSize($setpathgame & '\res_mods', 1))[1]
				_ArrayAdd($adelf, $setpathgame & '\res_mods')
			EndIf
		EndIf
		If UBound($adelf) = 0 Then
			Return
		Else
			If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[21])
		EndIf
	Else
		If FileExists($wkdir) Then
			If $oMod.Exists('info' & $CurGui) Then GUICtrlSetData($oMod.Item('info' & $CurGui), $Instjmplang[22])
			$szrmv += (DirGetSize($wkdir, 1))[1]
			_ArrayAdd($adelf, $wkdir)
		EndIf
	EndIf
	For $i = 0 To UBound($adelf) - 1
		$allfr = _FFSearch($adelf[$i], '', 1)
		If Not @error Then
			For $d = 1 To $allfr[0]
				FileDelete($allfr[$d])
				$curdel += 1
				$iPercData = Floor($curdel / $szrmv * 100)
				GUICtrlSetData($iPercId, $iPercData)
			Next
		EndIf
	Next
	If $FLR Then Return
	If $flclmods Then
		DirRemove($setpathgame & '\mods', 1)
		DirCreate($setpathgame & '\mods\' & $VerGameInst)
	EndIf
	If $flclresmods Then
		DirRemove($setpathgame & '\res_mods', 1)
		DirCreate($setpathgame & '\res_mods\' & $VerGameInst)
	EndIf
	If $flclmrm Then
		DirRemove($setpathgame & '\res_mods', 1)
		DirCreate($setpathgame & '\res_mods\' & $VerGameInst)
		DirRemove($setpathgame & '\mods', 1)
		DirCreate($setpathgame & '\mods\' & $VerGameInst)
	EndIf
EndFunc   ;==>_DirRemove

Func _FontInstall($sFile)
	Local $Font, $sName, $Path
	$sName = _WinAPI_GetFontResourceInfo($sFile, 1)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	$sName &= ' (TrueType)'
	$Font = StringRegExpReplace($sFile, '^.*\\', '')
	If Not RegWrite('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', $sName, 'REG_SZ', $Font) Then
		Return SetError(2, 0, 0)
	EndIf
	$Path = _WinAPI_ShellGetSpecialFolderPath($CSIDL_FONTS)
	If Not FileCopy($sFile, $Path, 1) Then
		RegDelete('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', $sName)
		Return SetError(3, 0, 0)
	EndIf
	If Not _WinAPI_AddFontResourceEx($Path & '\' & $Font, 0, 1) Then
		Return SetError(4, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_FontInstall

Func _GUITreeViewEx_Scroll($nParam)
	Local $dvis, $Hit, $vc, $gt, $prch, $visf, $getparam, $sGV = ''
	Local $CursorInfoW = GUIGetCursorInfo($WOTP)
	If Not @error Then
		If $objc.Exists($CursorInfoW[4]) Then
			$getparam = $objc.Item($CursorInfoW[4])
			If IsArray($getparam) Then $sGV = String($getparam[1])
		EndIf
		If GUICtrlGetHandle($CursorInfoW[4]) = $g_GTVEx_aTVData Or $sGV == 'bck0' Then
			$visf = _GUICtrlTreeView_GetFirstVisible($g_GTVEx_aTVData)
			Switch $nParam
				Case 120
					$prch = _GUICtrlTreeView_GetPrev($g_GTVEx_aTVData, $visf)
					_GUICtrlTreeView_EnsureVisible($g_GTVEx_aTVData, $prch)
				Case -120
					$Hit = _GUICtrlTreeView_GetHeight($g_GTVEx_aTVData)
					$vc = _GUICtrlTreeView_GetVisibleCount($g_GTVEx_aTVData) * $Hit - 1
					$gt = _GUICtrlTreeView_HitTestItem($g_GTVEx_aTVData, 0, $vc)
					$dvis = _GUICtrlTreeView_GetNext($g_GTVEx_aTVData, $gt)
					If Not $dvis Then Return
					_GUICtrlTreeView_EnsureVisible($g_GTVEx_aTVData, $dvis)
			EndSwitch
		EndIf
	EndIf
EndFunc   ;==>_GUITreeViewEx_Scroll

Func WM_MOUSEWHEEL($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $lParam
	Local $nParam = BitShift($wParam, 16)
	_GUITreeViewEx_Scroll($nParam)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOUSEWHEEL

Func _GetInfoModTV()
	$sListModsF = ''
	Local $aInfSetMod, $agettvx, $infpg
	$agettvx = _GUITreeViewEx_GetTVX()
	For $i = (UBound($agettvx) - 1) To 0 Step -1
		$infpg = _GUITreeViewEx_SaveTV(HWnd($agettvx[$i]))
		If @error Then ContinueLoop
		For $pg = 0 To UBound($infpg) - 1
			$aInfSetMod = _GUITreeViewEx_GetItemData(HWnd($agettvx[$i]), $infpg[$pg][1])
			If @error Then ContinueLoop
			Switch Number($infpg[$pg][2])
				Case 1
					$clip &= $infpg[$pg][1] & @CRLF
					If Not (String($aInfSetMod[18]) == '0') Then
						_ArrayAdd($exmods, $infpg[$pg][1] & '.7z')
						If FileExists($wkdir & '\' & $infpg[$pg][1] & '.txt') Then $sListModsF &= FileRead($wkdir & '\' & $infpg[$pg][1] & '.txt') & @LF
						_ArrayAdd($sNameMod, $infpg[$pg][0])
					EndIf
					If Not (String($aInfSetMod[21]) == '0') Then
						If FileExists($wkdir & '\' & $infpg[$pg][1] & '.ttf') Then
							_ArrayAdd($ALLTTF, $wkdir & '\' & $infpg[$pg][1] & '.ttf')
						ElseIf FileExists($wkdir & '\' & $infpg[$pg][1] & '.otf') Then
							_ArrayAdd($ALLTTF, $wkdir & '\' & $infpg[$pg][1] & '.otf')
						EndIf
					EndIf
			EndSwitch
		Next
	Next
EndFunc   ;==>_GetInfoModTV

Func _CreateTVLoad()
	Local $backwinpic, $aINFCTRL, $WoTchild, $hLoadTV, $aGetObj, $objcfp, $gf, $nATV = UBound($aLoadTV) - 1
	For $i = $nATV To 0 Step -1
		$aINFCTRL = $aLoadTV[$i][0]
		$backwinpic = GUICtrlCreatePic('', $aINFCTRL[2], $aINFCTRL[3], $aINFCTRL[4], $aINFCTRL[5])
		DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($backwinpic), 'wstr', '', 'wstr', '')
		_SetImage($backwinpic, $imgbackw, $aINFCTRL[4], $aINFCTRL[5], -1)
		GUICtrlSetPos($backwinpic, $aINFCTRL[2], $aINFCTRL[3], $aINFCTRL[4], $aINFCTRL[5])
		$aGetObj = $OSNW.Item('page' & $aLoadTV[$i][1])
		$objcfp = $aGetObj[1]
		$aINFCTRL[0] = 'pic'
		$aINFCTRL[1] = 'bck0'
		$aINFCTRL[9] = 64
		$objcfp.Add($backwinpic, $aINFCTRL)
		GUICtrlSetState($backwinpic, 64)
		If $aLoadTV[$i][1] > 0 Then GUICtrlSetState($backwinpic, $GUI_HIDE)
	Next
	For $i = $nATV To 0 Step -1
		$aINFCTRL = $aLoadTV[$i][0]
		$WoTchild = GUICreate("", $aINFCTRL[4], $aINFCTRL[5], $aINFCTRL[2], $aINFCTRL[3], $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $WOTP)
		GUISetBkColor(0x000000, $WoTchild)
		$hLoadTV = GUICtrlCreateTreeView(0, 0, $aINFCTRL[4] + 18, $aINFCTRL[5], BitOR($TVS_DISABLEDRAGDROP, $TVS_NOHSCROLL, $TVS_NOTOOLTIPS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_HASBUTTONS))
;~ 		DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($hLoadTV), 'wstr', '', 'wstr', '')
		$gf = StringSplit($aINFCTRL[8], '!')
		GUICtrlSetFont($hLoadTV, $gf[1], $gf[2], $gf[3], $gf[4])
		GUICtrlSetColor($hLoadTV, $aINFCTRL[10])
		GUICtrlSetBkColor($hLoadTV, 0x000000)
		$aGetObj = $OSNW.Item('page' & $aLoadTV[$i][1])
		$objcfp = $aGetObj[1]
		$aINFCTRL[0] = 'treeview'
		$aINFCTRL[1] = $WoTchild
		$aINFCTRL[2] = 0
		$aINFCTRL[3] = 0
		$aINFCTRL[9] = 64
		$objcfp.Add($hLoadTV, $aINFCTRL)
		_GUITreeViewEx_InitTV($hLoadTV)
		_GUITreeViewEx_TvImg($hLoadTV, $aIco)
		_GUITreeViewEx_LoadTV($hLoadTV, $wkdir & '\page' & $aLoadTV[$i][1] & '.jmp3', 'TV', 'TV')
		If $aLoadTV[$i][1] > 0 Then
			GUISetState(@SW_HIDE, $WoTchild)
		Else
			$flpgtv = 1
			GUISetState(@SW_SHOW, $WoTchild)
		EndIf
		_WinAPI_SetLayeredWindowAttributes($WoTchild, 0x000000, 255)
	Next
EndFunc   ;==>_CreateTVLoad

Func _LOADPJT($ldpjt)
	Local $agta, $win
	Local $medit, $aGetObj, $gtprc, $rdw, $rdc, $gf
	Local $aPage = _FFSearch($ldpjt, 'jmp3', 3, 1, 2)
	If @error Then
		MsgBox(16, @error, $Instjmplang[23], 0, $FlashGui)
		_DirRemove(1)
		Exit
	EndIf
	For $i = 0 To UBound($aPage) - 1
		_PageCreate($OSNW, 'page' & $i)
		$aGetObj = $OSNW.Item('page' & $i)
		$objw = $aGetObj[0]
		$objc = $aGetObj[1]
		$rdw = IniReadSection($ldpjt & '\page' & $i & '.jmp3', 'Windows')
		If Not @error Then
			For $r = 1 To $rdw[0][0]
				$agta = StringSplit($rdw[$r][1], '<>', 3)
				For $cw = 0 To 4
					$agta[$cw] = Number($agta[$cw])
				Next
				$objw.Add(Number($rdw[$r][0]), $agta)
			Next
		Else
			MsgBox(16, '10', $Instjmplang[23], 0, $FlashGui)
			GUIDelete($WOTP)
			_StopSound()
			_DirRemove(1)
			Exit
		EndIf
		If $i = 0 Then
			$win = $objw.Item(0)
			$WOTP = GUICreate('', $win[2], $win[3], -1, -1, $WS_POPUP, $WS_EX_LAYERED)
			GUISetBkColor($win[4], $WOTP)
			_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
		EndIf
		$rdc = IniReadSection($ldpjt & '\page' & $i & '.jmp3', 'Controls')
		If Not @error Then
			For $c = 1 To $rdc[0][0]
				$agta = StringSplit($rdc[$c][1], '<>', 3)
				$agta[2] = Number($agta[2])
				$agta[3] = Number($agta[3])
				$agta[4] = Number($agta[4])
				$agta[5] = Number($agta[5])
				$agta[6] = Number($agta[6])
				$agta[7] = Number($agta[7])
				$agta[9] = Number($agta[9])
				$agta[10] = Number($agta[10])
				$agta[11] = Number($agta[11])
				If String($agta[12]) == '0' Then $agta[12] = 0
				$agta[13] = Number($agta[13])
				Switch String($agta[0])
					Case 'mod'
						$agta[14] = Number($agta[14])
					Case Else
						Switch String($agta[14])
							Case 'clmods'
								If Number($agta[15]) = 1 Then $flclmods = 1
							Case 'clresmods'
								If Number($agta[15]) = 1 Then $flclresmods = 1
							Case 'backup'
								If Number($agta[15]) = 1 Then $flbackup = 1
							Case 'clmrm'
								If Number($agta[15]) = 1 Then $flclmrm = 1
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
				Local $funcid = 0
				Switch String($agta[0])
					Case 'treeview'
						_ArrayAdd($aLoadTV, '')
						$aLoadTV[UBound($aLoadTV) - 1][0] = $agta
						$aLoadTV[UBound($aLoadTV) - 1][1] = $i
						$nExistsTV = $i
					Case 'label'
						$medit = StringReplace($agta[1], '\n', @CRLF)
						$medit = StringReplace($medit, '\h', ' ')
						$funcid = GUICtrlCreateLabel($medit, $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
						DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
						If $agta[14] == 'txt' Then $oMod.Add('txt' & $i, $funcid)
						If $agta[14] == 'info' Then $oMod.Add('info' & $i, $funcid)
						If $agta[14] == 'path' Then $oMod.Add('path', $funcid)
						$gf = StringSplit($agta[8], '!')
						If $gf[0] > 1 Then GUICtrlSetFont($funcid, $gf[1], $gf[2], $gf[3], $gf[4])
						GUICtrlSetColor($funcid, $agta[10])
						GUICtrlSetBkColor($funcid, $agta[11])
					Case 'mod'
						$agta[15] = Number($agta[15])
						If $agta[15] Then
							Local $gettp = $oMod.Item($agta[15])
							$gettp = $objc.Item($gettp)
							If $gettp[17] Then
								$funcid = GUICtrlCreateRadio($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
								If StringRight($gettp[16], StringLen($agta[14])) = $agta[14] Then GUIStartGroup()
;~ 								If $agta[17] Then GUIStartGroup()
							Else
								$funcid = GUICtrlCreateCheckbox($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
								If StringRight($gettp[16], StringLen($agta[14])) = $agta[14] Then GUIStartGroup()
								If $agta[17] Then GUIStartGroup()
							EndIf
						Else
							$funcid = GUICtrlCreateCheckbox($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
							If $agta[17] Then GUIStartGroup()
						EndIf
						DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
						$oMod.Add(Number($agta[14]), $funcid)
						GUICtrlSetState($funcid, $agta[23])
						GUICtrlSetState($funcid, $agta[25])
						$medit = StringReplace($agta[1], '\n', @CRLF)
						$medit = StringReplace($medit, '\h', ' ')
						$gf = StringSplit($agta[8], '!')
						If $gf[0] > 1 Then GUICtrlSetFont($funcid, $gf[1], $gf[2], $gf[3], $gf[4])
						GUICtrlSetData($funcid, $medit)
						GUICtrlSetColor($funcid, $agta[10])
						GUICtrlSetBkColor($funcid, $agta[11])
					Case 'checkbox'
						$funcid = GUICtrlCreateCheckbox($agta[1], $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
						DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
						If Not ($agta[15] == '0') Then GUICtrlSetState($funcid, Number($agta[15]))
						GUICtrlSetState($funcid, $agta[25])
						$medit = StringReplace($agta[1], '\n', @CRLF)
						$medit = StringReplace($medit, '\h', ' ')
						GUICtrlSetData($funcid, $medit)
						$gf = StringSplit($agta[8], '!')
						If $gf[0] > 1 Then GUICtrlSetFont($funcid, $gf[1], $gf[2], $gf[3], $gf[4])
						GUICtrlSetColor($funcid, $agta[10])
						GUICtrlSetBkColor($funcid, $agta[11])
					Case 'progress'
						Switch $agta[24]
							Case 'barA'
								$funcid = GUICtrlCreatePic('', $agta[2], $agta[3], $agta[4], $agta[5])
								GUICtrlSetColor($funcid, $agta[11])
								GUICtrlSetBkColor($funcid, $agta[10])
							Case 'barSC'
								$SelectProgressbar = 1
								$funcid = GUICtrlCreateProgress($agta[2], $agta[3], $agta[4], $agta[5])
								DllCall('UxTheme.dll', 'uint', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle($funcid), 'wstr', '', 'wstr', '')
								GUICtrlSetColor($funcid, $agta[11])
								GUICtrlSetBkColor($funcid, $agta[10])
							Case 'barS'
								$SelectProgressbar = 1
								$funcid = GUICtrlCreateProgress($agta[2], $agta[3], $agta[4], $agta[5])
						EndSwitch
						$WPerc = $agta[4]
						$HPerc = $agta[5]
						$BgColorGui = $agta[10]
						$FgBGColor = $agta[11]
						$BGColor = Number($agta[12])
						$TextBGColor = $agta[7]
						$sFontProgress = $agta[8]
						$iVisPerc = $agta[6]
						$oMod.Add('perc', $funcid)
						$iPercId = $funcid
					Case 'pic'
						If $agta[14] == 'pic' Then
							$funcid = GUICtrlCreatePic('', $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
							$oMod.Add('pic' & $i, $funcid)
						Else
							Local $imsetp = $wkdir & '\' & $agta[12]
							If FileExists($wkdir & '\' & $agta[12]) Then
								$funcid = GUICtrlCreatePic('', $agta[2], $agta[3], $agta[4], $agta[5], $agta[6], $agta[7])
								_SetImage($funcid, $imsetp, $agta[4], $agta[5], -1)
								GUICtrlSetPos($funcid, $agta[2], $agta[3], $agta[4], $agta[5])
							EndIf
						EndIf
				EndSwitch
				If Not $funcid Then ContinueLoop
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
				EndSwitch
				If $agta[9] Then GUICtrlSetState($funcid, $agta[9])
				If $i > 0 Then GUICtrlSetState($funcid, $GUI_HIDE)
				$objc.Add($funcid, $agta)
			Next
		Else
			AdlibUnRegister('PlayAnim')
			MsgBox(16, 'error', $Instjmplang[24], 0, $FlashGui)
			GUIDelete($WOTP)
			_StopSound()
			_DirRemove(1)
			Exit
		EndIf
		_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
	Next
	_WinAPI_RedrawWindow($WOTP)
	_WinAPI_UpdateWindow($WOTP)
	_Middle($WOTP, $win[2], $win[3])
	$CurGui = 0
	$objw = $OSNW.Item('page' & $CurGui)[0]
	$objc = $OSNW.Item('page' & $CurGui)[1]
EndFunc   ;==>_LOADPJT

Func _Middle($win, $wd, $ht)
	Local $y = (@DesktopHeight / 2) - ($ht / 2)
	Local $x = (@DesktopWidth / 2) - ($wd / 2)
	WinMove($win, '', $x, $y, $wd, $ht)
EndFunc   ;==>_Middle

Func _PAGEBN($FL = 0)
	Local $nPageC = $CurGui
	If $curidpos Then
		Local $setoldid = $objc.Item($curidpos)
		If $backlight = 2 Then
			Local $gp1 = ControlGetPos($WOTP, '', $curidpos)
			Switch String($setoldid[0])
				Case 'label', 'checkbox'
					Local $setnewid = StringSplit($setoldid[8], '!')
					GUICtrlSetFont($curidpos, $setnewid[1], $setnewid[2], $setnewid[3], $setnewid[4])
			EndSwitch
			GUICtrlSetPos($curidpos, $gp1[0] + 2, $gp1[1] + 2, $gp1[2] - 4, $gp1[3] - 4)
		ElseIf $backlight = 3 Then
			If IsArray($setoldid) Then
				Switch String($setoldid[0])
					Case 'label', 'checkbox'
						GUICtrlSetBkColor($curidpos, Number($setoldid[11]))
				EndSwitch
			EndIf
		EndIf
		$curidpos = 0
	EndIf
	Local $aKeys
	If $FL = 0 Then
		$CurGui -= 1
	ElseIf $FL = 1 Then
		$CurGui += 1
	EndIf
	Local $ctrlstate
	If $FL < 2 Then
		$aKeys = $objc.Keys()
		For $i In $aKeys
			$flpg = 0
			$ctrlstate = $objc.Item($i)
			If UBound($ctrlstate) = 26 Then
				If $ctrlstate[0] == 'treeview' Then
					$flpgtv = 0
					GUISetState(@SW_HIDE, $ctrlstate[1])
					ContinueLoop
				EndIf
				GUICtrlSetState($i, $GUI_HIDE)
			EndIf
		Next
	EndIf
	$objw = $OSNW.Item('page' & $CurGui)[0]
	$objc = $OSNW.Item('page' & $CurGui)[1]
	Local $win = $objw.Item(0)
	GUISetBkColor($win[4], $WOTP)
	Local $wpos = WinGetPos($WOTP)
	WinMove($WOTP, '', $wpos[0], $wpos[1], $win[2], $win[3])
	$aKeys = $objc.Keys()
	For $i In $aKeys
		$flpg = 1
		$ctrlstate = $objc.Item($i)
		If UBound($ctrlstate) = 26 Then
			If $ctrlstate[0] == 'treeview' Then
				_GUITreeViewEx_InitTV($i)
				$flpgtv = 1
				GUISetState(@SW_SHOW, $ctrlstate[1])
				ContinueLoop
			EndIf
			GUICtrlSetState($i, Number($ctrlstate[25]))
		EndIf
	Next
;~ 	_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
EndFunc   ;==>_PAGEBN

Func _PAGECH($cpg)
	Local $setoldid
	If $OSNW.Exists('page' & $cpg) Then
		If $CurGui <> $cpg Then
			If $curidpos Then
				$setoldid = $objc.Item($curidpos)
				If UBound($setoldid) = 26 Then
					If $backlight = 2 Then
						Local $gp1 = ControlGetPos($WOTP, '', $curidpos)
						Switch String($setoldid[0])
							Case 'label', 'checkbox'
								Local $setnewid = StringSplit($setoldid[8], '!')
								GUICtrlSetFont($curidpos, $setnewid[1], $setnewid[2], $setnewid[3], $setnewid[4])
						EndSwitch
						GUICtrlSetPos($curidpos, $gp1[0] + 2, $gp1[1] + 2, $gp1[2] - 4, $gp1[3] - 4)
					ElseIf $backlight = 3 Then
						Switch String($setoldid[0])
							Case 'label', 'checkbox'
								GUICtrlSetBkColor($curidpos, Number($setoldid[11]))
						EndSwitch
					EndIf
				EndIf
				$curidpos = 0
			EndIf
			Local $aKeys, $ctrlstate
			$aKeys = $objc.Keys()
			For $i In $aKeys
				$flpg = 0
				$ctrlstate = $objc.Item($i)
				If UBound($ctrlstate) = 26 Then
					If $ctrlstate[0] == 'treeview' Then
						$flpgtv = 0
						GUISetState(@SW_HIDE, $ctrlstate[1])
						ContinueLoop
					EndIf
					GUICtrlSetState($i, $GUI_HIDE)
				EndIf
			Next
			$objw = $OSNW.Item('page' & $cpg)[0]
			$objc = $OSNW.Item('page' & $cpg)[1]
			Local $win = $objw.Item(0)
			GUISetBkColor($win[4], $WOTP)
			Local $wpos = WinGetPos($WOTP)
			WinMove($WOTP, '', $wpos[0], $wpos[1], $win[2], $win[3])
			$aKeys = $objc.Keys()
			For $i In $aKeys
				$flpg = 1
				$ctrlstate = $objc.Item($i)
				If UBound($ctrlstate) = 26 Then
					If $ctrlstate[0] == 'treeview' Then
						_GUITreeViewEx_InitTV($i)
						$flpgtv = 1
						GUISetState(@SW_SHOW, $ctrlstate[1])
						ContinueLoop
					EndIf
					GUICtrlSetState($i, Number($ctrlstate[25]))
				EndIf
			Next
			$CurGui = $cpg
;~ 			_WinAPI_SetLayeredWindowAttributes($WOTP, 50, 255)
		EndIf
	EndIf
EndFunc   ;==>_PAGECH

Func WM_ACTIVATE($hWnd, $Msg, $wParam, $lParam)
	Switch BitAND($wParam, 0xFFFF) ; _WinAPI_LoWord
		Case 1 ;, 2
			_WinAPI_RedrawWindow($WOTP)
			_WinAPI_UpdateWindow($WOTP)
	EndSwitch
EndFunc   ;==>WM_ACTIVATE

Func WM_SETCURSOR($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $lParam
	Local $nID = _WinAPI_GetDlgCtrlID($wParam)
	Local $getparam = 0, $sgettype
	Switch _WinAPI_HiWord($lParam)
		Case 513
			Switch $wParam
				Case $WOTP
					If $backlight = 2 Then
						If $g_hCursor Then Return _WinAPI_SetCursor($g_hCursor)
					EndIf
				Case Else
					If $nID > 0 Then
						$getparam = $objc.Item($nID)
						If UBound($getparam) = 26 Then
							$UpIdC = $nID
							Switch String($getparam[14])
								Case 'cash', 'clmods', 'clresmods', 'backup', 'clmrm', 'stop', 'next', 'inst', 'back', 'chpath', 'close', 'chpage', 'mini', 'url', 'backauset', 'ausetmod'
									If $backlight = 1 Then
										If $g_hCursorLight Then Return _WinAPI_SetCursor($g_hCursorLight)
									ElseIf $backlight = 2 Then
										If $g_hCursor Then Return _WinAPI_SetCursor($g_hCursor)
									EndIf
							EndSwitch
						EndIf
					EndIf
			EndSwitch
		Case 514
			Switch $wParam
				Case $WOTP
				Case Else
					If $nID > 0 Then
						$getparam = $objc.Item($nID)
						If UBound($getparam) = 26 Then
							If $wParam = $g_GTVEx_aTVData Or $getparam[1] = 'bck0' Then $nflagsetimgtv = 1
							Switch String($getparam[0])
								Case 'pic', 'label'
									If $nID = $UpIdC Then
										Switch String($getparam[14])
											Case 'url'
												ShellExecute($getparam[15])
											Case 'stop'
												$stoppr = 1
											Case 'chpath'
												$flfunc = 'chpath'
											Case 'inst'
												$flfunc = 'inst'
											Case 'mini'
												GUISetState(@SW_MINIMIZE, $WOTP)
											Case 'close'
												$flfunc = 'close'
											Case 'next'
												If Not $flinstset Then
													If $oSNW.Exists('page' & $CurGui + 1) Then _PAGEBN(1)
												EndIf
											Case 'back'
												If Not $flinstset Then
													If $CurGui > 0 Then _PAGEBN()
												EndIf
											Case 'chpage'
												If Not $flinstset Then _PAGECH($getparam[15])
										EndSwitch
									EndIf
							EndSwitch
						EndIf
						$UpIdC = 0
					EndIf
			EndSwitch
		Case 512
			If $nExistsTV = -1 Then
				If $flpg Then _PICTXT($nID)
			Else
				If $flpgtv Then _PICTXTTV()
			EndIf
			If $backlight Then
				Local $setnewid, $setoldid
				Switch $wParam
					Case $WOTP
						If $backlight = 2 Then
							If $curidpos Then
								$setoldid = $objc.Item($curidpos)
								If UBound($setoldid) = 26 Then
									Local $gp1 = ControlGetPos($WOTP, '', $curidpos)
									Switch String($setoldid[0])
										Case 'label', 'checkbox'
											$setnewid = StringSplit($setoldid[8], '!')
											GUICtrlSetFont($curidpos, $setnewid[1], $setnewid[2], $setnewid[3], $setnewid[4])
									EndSwitch
									GUICtrlSetPos($curidpos, $gp1[0] + 2, $gp1[1] + 2, $gp1[2] - 4, $gp1[3] - 4)
								EndIf
								$curidpos = 0
							EndIf
						EndIf
						If $backlight = 3 Then
							If $curidpos Then
								$setoldid = $objc.Item($curidpos)
								If UBound($setoldid) = 26 Then
									Switch String($setoldid[0])
										Case 'label', 'checkbox'
											GUICtrlSetBkColor($curidpos, Number($setoldid[11]))
									EndSwitch
								EndIf
								$curidpos = 0
							EndIf
						EndIf
						If $g_hCursor Then Return _WinAPI_SetCursor($g_hCursor)
					Case Else
						If $nID > 0 Then
							$getparam = $objc.Item($nID)
							If UBound($getparam) = 26 Then
								Switch String($getparam[14])
									Case 'cash', 'clmods', 'clresmods', 'backup', 'clmrm', 'stop', 'next', 'inst', 'back', 'chpath', 'close', 'chpage', 'mini', 'url', 'backauset', 'ausetmod'
										If $backlight = 2 Then
											Local $gp = ControlGetPos($WOTP, '', $nID)
											Local $gp1 = ControlGetPos($WOTP, '', $curidpos)
											If $curidpos <> $nID Then
												GUICtrlSetPos($nID, $gp[0] - 2, $gp[1] - 2, $gp[2] + 4, $gp[3] + 4)
												Switch String($getparam[0])
													Case 'label', 'checkbox'
														$setnewid = StringSplit($getparam[8], '!')
														GUICtrlSetFont($nID, $setnewid[1] + 2, $setnewid[2], $setnewid[3], $setnewid[4])
												EndSwitch
												If $curidpos Then
													$setoldid = $objc.Item($curidpos)
													If IsArray($setoldid) Then
														Switch String($setoldid[0])
															Case 'label', 'checkbox'
																$setnewid = StringSplit($setoldid[8], '!')
																GUICtrlSetFont($curidpos, $setnewid[1], $setnewid[2], $setnewid[3], $setnewid[4])
														EndSwitch
														GUICtrlSetPos($curidpos, $gp1[0] + 2, $gp1[1] + 2, $gp1[2] - 4, $gp1[3] - 4)
													EndIf
												EndIf
												$curidpos = $nID
											EndIf
										EndIf
										If $backlight = 3 Then
											If $curidpos <> $nID Then
												Switch String($getparam[0])
													Case 'label', 'checkbox'
														GUICtrlSetBkColor($nID, $backlightcolor)
												EndSwitch
												If $curidpos Then
													$setoldid = $objc.Item($curidpos)
													If UBound($setoldid) = 26 Then
														Switch String($setoldid[0])
															Case 'label', 'checkbox'
																GUICtrlSetBkColor($curidpos, Number($setoldid[11]))
														EndSwitch
													EndIf
												EndIf
												$curidpos = $nID
											EndIf
										EndIf
										If $backlight = 1 Then
											If $g_hCursorLight Then Return _WinAPI_SetCursor($g_hCursorLight)
										EndIf
									Case Else
										If $backlight = 2 Then
											If $curidpos Then
												$setoldid = $objc.Item($curidpos)
												If UBound($setoldid) = 26 Then
													Local $gp1 = ControlGetPos($WOTP, '', $curidpos)
													Switch String($setoldid[0])
														Case 'label', 'checkbox'
															$setnewid = StringSplit($setoldid[8], '!')
															GUICtrlSetFont($curidpos, $setnewid[1], $setnewid[2], $setnewid[3], $setnewid[4])
													EndSwitch
													GUICtrlSetPos($curidpos, $gp1[0] + 2, $gp1[1] + 2, $gp1[2] - 4, $gp1[3] - 4)
												EndIf
												$curidpos = 0
											EndIf
										EndIf
										If $backlight = 3 Then
											If $curidpos Then
												$setoldid = $objc.Item($curidpos)
												If UBound($setoldid) = 26 Then
													Switch String($setoldid[0])
														Case 'label', 'checkbox'
															GUICtrlSetBkColor($curidpos, Number($setoldid[11]))
													EndSwitch
												EndIf
												$curidpos = 0
											EndIf
										EndIf
										If $g_hCursor Then Return _WinAPI_SetCursor($g_hCursor)
								EndSwitch
							EndIf
						EndIf
				EndSwitch
			EndIf
	EndSwitch
	If $g_hCursor Then
		Return _WinAPI_SetCursor($g_hCursor)
	Else
		Return $GUI_RUNDEFMSG
	EndIf
EndFunc   ;==>WM_SETCURSOR

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $FSID
	$FSID = _WinAPI_LoWord($iwParam)
	Switch $FSID
		Case $FSID > 0
			Local $getparam = $objc.Item($FSID)
			If IsArray($getparam) Then
				Switch String($getparam[0])
					Case 'mod'
						_CHKPARENT($FSID)
					Case 'checkbox'
						Local $RFsid = GUICtrlRead($FSID)
						Switch String($getparam[14])
							Case 'cash'
								If $RFsid = 1 Then
									$flclcash = 1
								Else
									$flclcash = 0
								EndIf
							Case 'clmods'
								If $RFsid = 1 Then
									$flclmods = 1
									$flclmrm = 0
								Else
									$flclmods = 0
								EndIf
							Case 'clresmods'
								If $RFsid = 1 Then
									$flclresmods = 1
									$flclmrm = 0
								Else
									$flclresmods = 0
								EndIf
							Case 'clmrm'
								If $RFsid = 1 Then
									$flclmrm = 1
									$flclresmods = 0
									$flclmods = 0
								Else
									$flclmrm = 0
								EndIf
							Case 'backup'
								If $RFsid = 1 Then
									$flbackup = 1
								Else
									$flbackup = 0
								EndIf
							Case 'backauset'
								Switch $RFsid
									Case 1
										_BASS_ChannelPause($MusicHandleBck)
									Case 4
										_BASS_ChannelPlay($MusicHandleBck, 0)
								EndSwitch
								$nbackauset = $RFsid
								If $oMod.Exists('backauset') Then
									Local $gtprc = $oMod.Item('backauset')
									For $i = 0 To UBound($gtprc) - 1
										GUICtrlSetState($gtprc[$i], $nbackauset)
									Next
								EndIf
							Case 'ausetmod'
								$nausetmod = $RFsid
								If $oMod.Exists('ausetmod') Then
									Local $gtprc = $oMod.Item('ausetmod')
									For $i = 0 To UBound($gtprc) - 1
										GUICtrlSetState($gtprc[$i], $nausetmod)
									Next
								EndIf
						EndSwitch
						$getparam[15] = $RFsid
						$objc.Item($FSID) = $getparam
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
	Local $getchk, $getid = $idprt, $splfid, $gettmpid
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

Func _PICTXTTV()
	Local $gtpic, $curpic
	Local $tPoint = _WinAPI_GetMousePos(1, $g_GTVEx_aTVData)
	Local $tTVHTI = _GUICtrlTreeView_HitTestEx($g_GTVEx_aTVData, DllStructGetData($tPoint, 1, 1), DllStructGetData($tPoint, 2))
	Local $hItemTV = DllStructGetData($tTVHTI, 'Item')
	If $hItemTV Then
		If $tmpcurtv = $hItemTV Then Return
		Switch DllStructGetData($tTVHTI, 'Flags')
			Case 4, 64
				$gtpic = _GUITreeViewEx_GetItemData($g_GTVEx_aTVData, _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hItemTV))
				If Not IsArray($gtpic) Then
					_UpDateVTV()
					Return
				EndIf
				If FileExists($wkdir & '\' & $gtpic[14] & StringRight($gtpic[19], 4)) Then
					$idpic = $oMod.Item('pic' & $CurGui)
					If $idpic Then
						Local $gppic = $objc.Item($idpic)
						$curpic = $wkdir & '\' & $gtpic[14] & StringRight($gtpic[19], 4)
						_SetImage($idpic, $curpic, $gppic[4], $gppic[5], -1)
						GUICtrlSetPos($idpic, $gppic[2], $gppic[3], $gppic[4], $gppic[5])
					EndIf
				Else
					If $idpic Then
						GUICtrlSetImage($idpic, '')
						$idpic = 0
					EndIf
				EndIf
				If FileExists($wkdir & '\' & $gtpic[14] & '.mp3') Then
					If $nausetmod = 4 Then
						_SetNewSong($wkdir & '\' & $gtpic[14] & '.mp3')
					EndIf
				Else
					_ResetStopS()
				EndIf
				If Not (String($gtpic[22]) == '0') Then
					$idtxt = $oMod.Item('txt' & $CurGui)
					If $idtxt Then
						Local $medit = StringReplace($gtpic[22], '\n', @CRLF)
						$medit = StringReplace($medit, '\h', ' ')
						GUICtrlSetData($idtxt, $medit)
					EndIf
				Else
					If $idtxt Then
						GUICtrlSetData($idtxt, '')
						$idtxt = 0
					EndIf
				EndIf
				$tmpcurtv = $hItemTV
			Case Else
				_UpDateVTV()
				Return
		EndSwitch
	Else
		_UpDateVTV()
		Return
	EndIf
EndFunc   ;==>_PICTXTTV

Func _PICTXT($getcurid)
	Local $curpic
	If $getcurid > 0 Then
		Local $gtpic = $objc.Item($getcurid)
		If Not IsArray($gtpic) Then
			If $flhide Then
				_UpDateVTV()
				$flhide = 0
			EndIf
			Return
		EndIf
		If String($gtpic[0]) == 'mod' Then
			If $tmpcurtv = $getcurid Then Return
			If FileExists($wkdir & '\' & $gtpic[14] & StringRight($gtpic[19], 4)) Then
				$idpic = $oMod.Item('pic' & $CurGui)
				If $idpic Then
					Local $gppic = $objc.Item($idpic)
					$curpic = $wkdir & '\' & $gtpic[14] & StringRight($gtpic[19], 4)
					_SetImage($idpic, $curpic, $gppic[4], $gppic[5], -1)
					GUICtrlSetPos($idpic, $gppic[2], $gppic[3], $gppic[4], $gppic[5])
					$flhide = 1
				EndIf
			Else
				If $flhide = 1 Then
					If $idpic Then
						GUICtrlSetImage($idpic, '')
						$idpic = 0
					EndIf
					$flhide = 0
				EndIf
			EndIf
			If FileExists($wkdir & '\' & $gtpic[14] & '.mp3') Then
				If $nausetmod = 4 Then
					_SetNewSong($wkdir & '\' & $gtpic[14] & '.mp3')
				EndIf
			Else
				_ResetStopS()
			EndIf
			If Not (String($gtpic[22]) == '0') Then
				$idtxt = $oMod.Item('txt' & $CurGui)
				If $idtxt Then
					Local $medit = StringReplace($gtpic[22], '\n', @CRLF)
					$medit = StringReplace($medit, '\h', ' ')
					GUICtrlSetData($idtxt, $medit)
					$flhide = 1
				EndIf
			Else
				If $flhide = 1 Then
					If $idtxt Then
						GUICtrlSetData($idtxt, '')
						$idtxt = 0
					EndIf
					$flhide = 0
				EndIf
			EndIf
			$tmpcurtv = $getcurid
		Else
			If $flhide Then
				_UpDateVTV()
				$flhide = 0
			EndIf
		EndIf
	Else
		If $tmpcurtv Then
			_UpDateVTV()
			$flhide = 0
		EndIf
	EndIf
EndFunc   ;==>_PICTXT

Func _UpDateVTV()
	If $idpic Then
		GUICtrlSetImage($idpic, '')
		$idpic = 0
	EndIf
	If $idtxt Then
		GUICtrlSetData($idtxt, '')
		$idtxt = 0
	EndIf
	_ResetStopS()
	$tmpcurtv = 0
EndFunc   ;==>_UpDateVTV

Func _StopSound()
	_BASS_StreamFree($MusicHandleMod)
	_BASS_StreamFree($MusicHandleBck)
	_BASS_Stop()
	_BASS_Free()
EndFunc   ;==>_StopSound

Func _SetNewSong($sPath)
	_BASS_ChannelPause($MusicHandleBck)
	_BASS_StreamFree($MusicHandleMod)
	$MusicHandleMod = _BASS_StreamCreateFile(False, $sPath, 0, 0, 0)
	_BASS_ChannelPlay($MusicHandleMod, 1)
EndFunc   ;==>_SetNewSong

Func _ResetStopS()
	If $nausetmod = 4 Then _BASS_StreamFree($MusicHandleMod)
	If $nbackauset = 4 Then _BASS_ChannelPlay($MusicHandleBck, 0)
EndFunc   ;==>_ResetStopS