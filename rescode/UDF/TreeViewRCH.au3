
;~ autor: joiner (http://autoit-script.ru/index.php?action=downloads;sa=view;down=602)
;~ ver. 2.0
#include-once
#include <GuiTreeView.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

Opt('MustDeclareVars', 1)

Global $g_GTVEx_aTVData = 0; Дескриптор TreeView
Global $hModificationItemTV = 0; Дескриптор текущего выбранного пункта
Global $UnchkUp = 0, $fItemDelTV = 0
Global $MnTVs = 0, $sNewTxtItemTV = 0, $nNewTxtItemTV = 0, $nFlagKeyDn = 0, $nFlagSelect = 0
Global $oSNTV, $oSNTVEX
$oSNTV = ObjCreate('Scripting.Dictionary')
If @error Then
	MsgBox(16, '1', 'Сreation error Scripting.Dictionary')
Else
	$oSNTV.CompareMode = 1
EndIf

$oSNTVEX = ObjCreate('Scripting.Dictionary')
If @error Then
	MsgBox(16, '2', 'Creation error Scripting.Dictionary')
Else
	$oSNTVEX.CompareMode = 1
EndIf
;~ $sTvIniData - Путь к файлу сохранения
;~ $sSection - Имя секции
;~ $sKey - Имя параметра
;~ По умолчанию функция выводит в массив все пункты. Первая колонка - имя пункта, вторая - параметр пункта, третья - состояние пункта: 1 - пункт отмечен
;~ Если все параметры заполнены, то данные будут записаны в файл
;~ Параметр пункта может быть использован в функции _GUITreeViewEx_GetItemData

Func _GUITreeViewEx_SaveTV($hTVX, $sTvIniData = '', $sSection = '', $sKey = '')
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	If Not _GUICtrlTreeView_GetCount($hTV) Then Return SetError(2)
	Local $z = 0, $c = 0
	Local $hHandle = _GUICtrlTreeView_GetFirstItem($hTV)
	Local $sDelimiter = '|', $sLevel = '~', $ParamItem, $valparam
	Local $sString = '', $sText, $sLevelCount, $StringParam, $ChkType
	Local $GetRes, $aCheckedTV[0][3]
	If Not ($sTvIniData Or $sSection Or $sKey) Then
		$GetRes = 0
	Else
		$GetRes = 1
	EndIf
	While 1
		$sLevelCount = ''
		For $i = 1 To _GUICtrlTreeView_Level($hTV, $hHandle)
			$sLevelCount &= $sLevel
		Next
		$sText = _GUICtrlTreeView_GetText($hTV, $hHandle)
		$ParamItem = _GUICtrlTreeView_GetItemParam($hTV, $hHandle)
		$valparam = $oSNTV.Item($ParamItem)
		If Not $GetRes Then
			$ChkType = Number($valparam[1])
			ReDim $aCheckedTV[$z + 1][3]
			$aCheckedTV[$c][0] = $sText
			$aCheckedTV[$c][1] = $ParamItem
			If $ChkType = 3 Or $ChkType = 1 Then $aCheckedTV[$c][2] = 1
			$z += 1
			$c += 1
		Else
			$StringParam = $ParamItem & '*' & _ArrayToString($valparam, '*')
			$sString &= $sLevelCount & $sText & '*' & $StringParam & $sDelimiter
		EndIf
		$hHandle = _GUICtrlTreeView_GetNext($hTV, $hHandle)
		If Not $hHandle Then ExitLoop
	WEnd
	Local $wrtv = 0
	If $sString Then
		$wrtv = IniWrite($sTvIniData, $sSection, $sKey, StringTrimRight($sString, 1))
		Return $wrtv
	Else
		Return $aCheckedTV
	EndIf
EndFunc   ;==>_GUITreeViewEx_SaveTV


;~ $sTvIniData - Путь к файлу сохранения
;~ $sSection - Имя секции
;~ $sKey - Имя параметра

Func _GUITreeViewEx_LoadTV($hTVX, $sTvIniData, $sSection, $sKey)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	If _GUICtrlTreeView_GetCount($hTV) Then _GUITreeViewEx_Delete($hTV, True)
	Local $sString = IniRead($sTvIniData, $sSection, $sKey, '')
	If Not $sString Then Return SetError(1)
	Local $sTVItem, $iLevel, $hChild, $infoparam, $ParamItem
	Local $sDelimiter = '|', $sLevel = '~'
	Local $aLevelParent[100] = [0]
	Local $aTVItems = StringSplit($sString, $sDelimiter)
	_GUICtrlTreeView_BeginUpdate($hTV)
	For $i = 1 To $aTVItems[0]
		$sTVItem = StringReplace($aTVItems[$i], $sLevel, '')
		$iLevel = @extended
		$infoparam = StringSplit($sTVItem, '*', 2)
		If UBound($infoparam) < 4 Then
			_GUITreeViewEx_Delete($hTV)
			Return SetError(2); данные в файле повреждены
		EndIf
		$sTVItem = $infoparam[0]
		$hChild = _GUICtrlTreeView_AddChild($hTV, $aLevelParent[$iLevel], $sTVItem)
		_GUICtrlTreeView_SetState($hTV, $hChild, $TVIS_EXPANDED, 1)
		$aLevelParent[$iLevel + 1] = $hChild
		$ParamItem = Number($infoparam[1])
		_GUICtrlTreeView_SetItemParam($hTV, $hChild, $ParamItem)
		_ArrayDelete($infoparam, '0 - 1')
		$oSNTV.Add($ParamItem, $infoparam)
		_GUICtrlTreeView_SetStateImageIndex($hTV, $hChild, Number($infoparam[1]))
	Next
	_GUICtrlTreeView_EndUpdate($hTV)
EndFunc   ;==>_GUITreeViewEx_LoadTV

Func _GUITreeViewEx_GetItems($hTVX);Получить по порядку список параметров всех пунктов дерева
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	If Not _GUICtrlTreeView_GetCount($hTV) Then Return SetError(1)
	Local $hHandle = _GUICtrlTreeView_GetFirstItem($hTV)
	Local $aAllItemsTV[0], $ParamItem
	While 1
		$ParamItem = _GUICtrlTreeView_GetItemParam($hTV, $hHandle)
		_ArrayAdd($aAllItemsTV, $ParamItem)
		$hHandle = _GUICtrlTreeView_GetNext($hTV, $hHandle)
		If Not $hHandle Then ExitLoop
	WEnd
	If UBound($aAllItemsTV) > 0 Then Return $aAllItemsTV
EndFunc   ;==>_GUITreeViewEx_GetItems

Func _GUITreeViewEx_GetItemsTVX()
	If IsObj($oSNTV) Then Return $oSNTV.Keys()
EndFunc   ;==>_GUITreeViewEx_GetItemsTVX

Func _GUITreeViewEx_GetTVX()
	If IsObj($oSNTVEX) Then Return $oSNTVEX.Keys()
EndFunc   ;==>_GUITreeViewEx_GetTVX

Func _GUITreeViewEx_DeleteTVX()
	Local $aKeysTVX = $oSNTVEX.Keys()
	For $i In $aKeysTVX
		_GUITreeViewEx_Delete(HWnd($i), False)
	Next
EndFunc   ;==>_GUITreeViewEx_DeleteTVX

;~ Параметр: 1 - удалить все пункты, 0 - удалить TreeView
Func _GUITreeViewEx_Delete($hTVX, $nPart = True)
	Local $hTvImg, $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	Local $aAllItemsTV
	If $nPart Then
		$aAllItemsTV = _GUITreeViewEx_GetItems($hTV)
		If Not @error Then
			For $i = 0 To UBound($aAllItemsTV) - 1
				$oSNTV.Remove($aAllItemsTV[$i])
			Next
			_GUICtrlTreeView_DeleteAll($hTV)
		EndIf
	Else
		$aAllItemsTV = _GUITreeViewEx_GetItems($hTV)
		If Not @error Then
			For $i = 0 To UBound($aAllItemsTV) - 1
				$oSNTV.Remove($aAllItemsTV[$i])
			Next
		EndIf
		If $oSNTVEX.Exists(String($hTV)) Then
			$hTvImg = $oSNTVEX.Item(String($hTV))
			$oSNTVEX.Remove(String($hTV))
			_GUIImageList_Destroy($hTvImg[0])
		EndIf
		_GUICtrlTreeView_DeleteAll($hTV)
		_GUICtrlTreeView_Destroy($hTV)
		If Not $oSNTVEX.Count() Then
			_GUITreeViewEx_CloseTV()
			Return
		EndIf
		$g_GTVEx_aTVData = 0
	EndIf
	$fItemDelTV = 0
	$UnchkUp = 0
	$hModificationItemTV = 0
EndFunc   ;==>_GUITreeViewEx_Delete

;~ $hTV - handle\id TreeView
;~ $aTvIco - массив, состоящий из четырех строк. в каждой строке путь к соответствующей иконке. смотри функцию _TvImg()
;~ Иконки произвольные, назначение иконок - визуальное поределение типа элемента
Func _GUITreeViewEx_InitTV($hTVX)
	If IsHWnd($hTVX) Then
		$g_GTVEx_aTVData = $hTVX
	Else
		$g_GTVEx_aTVData = GUICtrlGetHandle($hTVX)
		If Not $g_GTVEx_aTVData Then Return SetError(1)
	EndIf
	If Not $oSNTVEX.Count() Then GUIRegisterMsg($WM_NOTIFY, '_GUITreeViewEx')
	Local $aInfTv[2] = [0, 0]
	If Not $oSNTVEX.Exists(String($g_GTVEx_aTVData)) Then $oSNTVEX.Add(String($g_GTVEx_aTVData), $aInfTv)
EndFunc   ;==>_GUITreeViewEx_InitTV

Func _GUITreeViewEx_CloseTV()
	GUIRegisterMsg($WM_NOTIFY, '')
	$g_GTVEx_aTVData = 0
	$hModificationItemTV = 0
	$UnchkUp = 0
	$fItemDelTV = 0
	$MnTVs = 0
	$sNewTxtItemTV = 0
	$nNewTxtItemTV = 0
	$nFlagKeyDn = 0
	$nFlagSelect = 0
EndFunc   ;==>_GUITreeViewEx_CloseTV

Func _GUITreeViewEx_TvImg($hTVX, $aTvIco)
	If UBound($aTvIco) <> 4 Then Return SetError(1)
	For $i = 0 To UBound($aTvIco) - 1
		If Not FileExists($aTvIco[$i]) Then Return SetError(2)
	Next
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(3)
	EndIf
	Local $aInfTv
	Local $hTvImg = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($hTvImg, $aTvIco[0]) ;'\chk.ico' - Checkbox с отметкой
	_GUIImageList_AddIcon($hTvImg, $aTvIco[1]) ;'\unchk.ico' - Checkbox без отметки
	_GUIImageList_AddIcon($hTvImg, $aTvIco[2]) ;'\rd.ico' - RadioButton с отметкой
	_GUIImageList_AddIcon($hTvImg, $aTvIco[3]) ;'\unrd.ico' - RadioButton без отметки
	_GUICtrlTreeView_SetStateImageList($hTV, $hTvImg)
	If $oSNTVEX.Exists(String($hTV)) Then
		$aInfTv = $oSNTVEX.Item(String($hTV))
		$aInfTv[0] = $hTvImg
		$oSNTVEX.Item(String($hTV)) = $aInfTv
	EndIf
EndFunc   ;==>_GUITreeViewEx_TvImg

Func _GUITreeViewEx_GetHItem()
	Local $tPoint = _WinAPI_GetMousePos(1, $g_GTVEx_aTVData)
	Local $tTVHTI = _GUICtrlTreeView_HitTestEx($g_GTVEx_aTVData, DllStructGetData($tPoint, 1, 1), DllStructGetData($tPoint, 2))
	Local $hItemTV = DllStructGetData($tTVHTI, 'Item')
	If $hItemTV Then
		Switch DllStructGetData($tTVHTI, 'Flags')
			Case 4, 64
				_TVAutoSetImg($hItemTV, $UnchkUp)
				Return $hItemTV
		EndSwitch
	EndIf
EndFunc   ;==>_GUITreeViewEx_GetHItem

Func _GUITreeViewEx($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hItem, $nAction, $aInfTv
	Local $tStruct = DllStructCreate('struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct;' & _
			'uint Action;struct;uint OldMask;handle OldhItem;uint OldState;uint OldStateMask;' & _
			'ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;endstruct;' & _
			'struct;uint NewMask;handle NewhItem;uint NewState;uint NewStateMask;' & _
			'ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;endstruct;' & _
			'struct;long PointX;long PointY;endstruct', $lParam)
	Local $hWndFrom = DllStructGetData($tStruct, 'hWndFrom')
	If $oSNTVEX.Exists(String($hWndFrom)) Then
		$g_GTVEx_aTVData = $hWndFrom
		Switch DllStructGetData($tStruct, 'Code')
			Case $NM_RCLICK
				$MnTVs = 1
			Case $NM_CLICK
				$MnTVs = 0
			Case $TVN_DELETEITEMA, $TVN_DELETEITEMW
;~ 				$hItem = DllStructGetData($tStruct, 'NewParam')
				$fItemDelTV = 1
			Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW
				$hItem = DllStructGetData($tStruct, 'NewhItem')
				If Not $fItemDelTV Then
					If $hItem Then
						$aInfTv = $oSNTVEX.Item(String($hWndFrom))
						$aInfTv[1] = $hItem
						$oSNTVEX.Item(String($hWndFrom)) = $aInfTv
						$hModificationItemTV = $hItem
						If $nFlagSelect Then
							_GUICtrlTreeView_SetState($g_GTVEx_aTVData, $hItem, $TVIS_SELECTED, False)
						Else
							If DllStructGetData($tStruct, 'Action') <> 2 Then
								_TVAutoSetImg($hItem, $UnchkUp)
								$nFlagKeyDn = 1
							ElseIf DllStructGetData($tStruct, 'Action') = 2 Then
								$nFlagKeyDn = 1
							EndIf
						EndIf
					Else
						_GUICtrlTreeView_SetSelected($g_GTVEx_aTVData, $hItem, 0)
						$aInfTv = $oSNTVEX.Item(String($hWndFrom))
						$aInfTv[1] = 0
						$oSNTVEX.Item(String($hWndFrom)) = $aInfTv
						$hModificationItemTV = 0
						$fItemDelTV = 0
					EndIf
				EndIf
			Case $TVN_KEYDOWN
				If $hModificationItemTV Then
					If DllStructGetData($tStruct, 'Action') = 32 Then _TVAutoSetImg($hModificationItemTV, $UnchkUp)
				EndIf
			Case $TVN_ENDLABELEDITA, $TVN_ENDLABELEDITW
				Local $tInfo = DllStructCreate($tagNMHDR & ';' & $tagTVITEMEX, $lParam)
				If DllStructGetData($tInfo, 'Text') <> 0 Then
					Local $tBuffer = DllStructCreate('wchar Text[' & DllStructGetData($tInfo, 'TextMax') & ']', DllStructGetData($tInfo, 'Text'))
					If StringStripWS(DllStructGetData($tBuffer, 'Text'), 3) Then
						$sNewTxtItemTV = StringReplace(StringRegExpReplace(DllStructGetData($tBuffer, 'Text'), '[*~|#><]', ' '), '\', '')
						_GUICtrlTreeView_SetText($g_GTVEx_aTVData, $hModificationItemTV, $sNewTxtItemTV)
						_TextEndTV($g_GTVEx_aTVData)
					EndIf
				EndIf
		EndSwitch
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_GUITreeViewEx

Func _ReactchangeCHK()
	$UnchkUp = Not $UnchkUp
EndFunc   ;==>_ReactchangeCHK

Func _EditTextTV($hTVX)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	Local $aInfTv
	If $oSNTVEX.Exists(String($hTV)) Then
		$aInfTv = $oSNTVEX.Item(String($hTV))
		If $aInfTv[1] Then _GUICtrlTreeView_EditText($hTV, $aInfTv[1])
	EndIf
EndFunc   ;==>_EditTextTV

Func _TextEndTV($hTVX)
	_GUICtrlTreeView_EndEdit($hTVX)
	$nNewTxtItemTV = 1
EndFunc   ;==>_TextEndTV

;~ Снимает отметки со всех пунктов TreeView
Func _GUITreeViewEx_UnCheckAll($hTVX)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(-1)
	EndIf
	If Not _GUICtrlTreeView_GetCount($hTV) Then Return SetError(1)
	Local $ParamItem, $valparam
	Local $hHandle = _GUICtrlTreeView_GetFirstItem($hTV)
	While 1
		$ParamItem = _GUICtrlTreeView_GetItemParam($hTV, $hHandle)
		$valparam = $oSNTV.Item($ParamItem)
		Switch Number($valparam[1])
			Case 1
				_GUICtrlTreeView_SetStateImageIndex($hTV, $hHandle, 2)
				$valparam[1] = 2
			Case 3
				_GUICtrlTreeView_SetStateImageIndex($hTV, $hHandle, 4)
				$valparam[1] = 4
		EndSwitch
		$oSNTV.Item($ParamItem) = $valparam
		$hHandle = _GUICtrlTreeView_GetNext($hTV, $hHandle)
		If Not $hHandle Then ExitLoop
	WEnd
EndFunc   ;==>_GUITreeViewEx_UnCheckAll

Func _TVAutoSetImg($hItem, $UpUnchk)
	If Not $hItem Then Return
	Local $valparam, $vpp, $ptpm
	Local $getparam = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hItem)
	Local $hParent = _GUICtrlTreeView_GetParentHandle($g_GTVEx_aTVData, $hItem)
	If $hParent Then
		$ptpm = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hParent)
		$vpp = $oSNTV.Item($ptpm)
	EndIf
	$valparam = $oSNTV.Item($getparam)
	Switch Number($valparam[1])
		Case 1
			_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hItem, 2)
			$valparam[1] = 2
			$oSNTV.Item($getparam) = $valparam
;~ 			If $hParent Then
;~ 				If $UpUnchk Then _AutoUnCheckParents($hItem)
;~ 				__TVUnCheck($hItem, False)
;~ 			Else
			__TVUnCheck($hItem, False)
;~ 			EndIf
		Case 2
			_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hItem, 1)
			$valparam[1] = 1
			$oSNTV.Item($getparam) = $valparam
			If $hParent Then
				Switch Number($vpp[1])
					Case 2, 4
						_AutoCheckParents($hItem)
				EndSwitch
				If $UpUnchk Then __TVUnCheck($hItem, True, True)
			Else
				If $UpUnchk Then __TVUnCheck($hItem, True, True)
			EndIf
		Case 3
		Case 4
			_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hItem, 3)
			$valparam[1] = 3
			$oSNTV.Item($getparam) = $valparam
			If $hParent Then
				Switch Number($vpp[1])
					Case 2, 4
						_AutoCheckParents($hItem)
				EndSwitch
				If $UpUnchk Then __TVUnCheck($hItem, True, True)
			Else
				If $UpUnchk Then __TVUnCheck($hItem, True, True)
			EndIf
			If $hParent Then
				Local $ParamItem, $Child
				If Number($vpp[0]) Then
					$Child = _GUICtrlTreeView_GetFirstChild($g_GTVEx_aTVData, $hParent)
					If Not $Child Then Return
					While 1
						$ParamItem = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $Child)
						If StringCompare($getparam, $ParamItem) Then
							$valparam = $oSNTV.Item($ParamItem)
							Switch Number($valparam[1])
								Case 1
									$valparam[1] = 2
									$oSNTV.Item($ParamItem) = $valparam
									_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $Child, 2)
								Case 3
									$valparam[1] = 4
									$oSNTV.Item($ParamItem) = $valparam
									_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $Child, 4)
							EndSwitch
							__TVUnCheck($Child, False)
						EndIf
						$Child = _GUICtrlTreeView_GetNextChild($g_GTVEx_aTVData, $Child)
						If Not $Child Then ExitLoop
					WEnd
				EndIf
			EndIf
	EndSwitch
EndFunc   ;==>_TVAutoSetImg

;----------------------------------------------------------------------------------------------------------------------

Func _AutoUnCheckParents($hPassedItem)
	Local $hParent = _GUICtrlTreeView_GetParentHandle($g_GTVEx_aTVData, $hPassedItem)
	If Not $hParent Then Return
	Local $vch = __TVVerifyCheck($hParent)
	If Not $vch Then
		Local $ParamItem = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hParent)
		Local $valparam = $oSNTV.Item($ParamItem)
		Switch Number($valparam[1])
			Case 1
				_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hParent, 2)
				$valparam[1] = 2
			Case 3
				_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hParent, 4)
				$valparam[1] = 4
		EndSwitch
		$oSNTV.Item($ParamItem) = $valparam
		_AutoUnCheckParents($hParent)
	EndIf
EndFunc   ;==>_AutoUnCheckParents

Func __TVVerifyCheck($hPassedItem)
	Local $hChild = _GUICtrlTreeView_GetFirstChild($g_GTVEx_aTVData, $hPassedItem)
	If Not $hChild Then Return
	Local $ParamItem
	Local $vlpm
	While 1
		$ParamItem = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hChild)
		$vlpm = $oSNTV.Item($ParamItem)
		Switch Number($vlpm[1])
			Case 1, 3
				Return 1
		EndSwitch
		$hChild = _GUICtrlTreeView_GetNextChild($g_GTVEx_aTVData, $hChild)
		If Not $hChild Then ExitLoop
	WEnd
EndFunc   ;==>__TVVerifyCheck

;-----------------------------------------------------------------------------------------------------------------------


Func _AutoCheckParents($hPassedItem)
	Local $hParent = _GUICtrlTreeView_GetParentHandle($g_GTVEx_aTVData, $hPassedItem)
	If Not $hParent Then Return
	Local $ParamItem = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hParent)
	Local $valparam = $oSNTV.Item($ParamItem)
	Switch Number($valparam[1])
		Case 2
			_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hParent, 1)
			$valparam[1] = 1
		Case 4
			_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hParent, 3)
			$valparam[1] = 3
	EndSwitch
	$oSNTV.Item($ParamItem) = $valparam
	If Number($valparam[0]) Then _TVUnCheckOther($hPassedItem, $hParent)
	_AutoCheckParents($hParent)
EndFunc   ;==>_AutoCheckParents

Func _TVUnCheckOther($hPassedItem, $hParent)
	Local $ncompare = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hPassedItem)
	Local $Child, $ParamItem, $valparam
	$Child = _GUICtrlTreeView_GetFirstChild($g_GTVEx_aTVData, $hParent)
	If Not $Child Then Return
	While 1
		$ParamItem = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $Child)
		If StringCompare($ncompare, $ParamItem) Then
			$valparam = $oSNTV.Item($ParamItem)
			Switch Number($valparam[1])
				Case 1
					_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $Child, 2)
					$valparam[1] = 2
				Case 3
					_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $Child, 4)
					$valparam[1] = 4
			EndSwitch
			$oSNTV.Item($ParamItem) = $valparam
			__TVUnCheck($Child, False)
		EndIf
		$Child = _GUICtrlTreeView_GetNextChild($g_GTVEx_aTVData, $Child)
		If Not $Child Then ExitLoop
	WEnd
EndFunc   ;==>_TVUnCheckOther

Func __TVUnCheck($hPassedItem, $bState, $itemf = False)
	Local $checkpram, $valparam
	$checkpram = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hPassedItem)
	$valparam = $oSNTV.Item($checkpram)
	Switch Number($valparam[1])
		Case 1
			If Not $bState Then
				_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hPassedItem, 2)
				$valparam[1] = 2
			EndIf
		Case 2
			If $bState Then
				_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hPassedItem, 1)
				$valparam[1] = 1
			EndIf
		Case 3
			If Not $bState Then
				_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hPassedItem, 4)
				$valparam[1] = 4
			EndIf
		Case 4
			If $bState Then
				_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hPassedItem, 3)
				$valparam[1] = 3
			EndIf
	EndSwitch
	$oSNTV.Item($checkpram) = $valparam
	Local $hChild = _GUICtrlTreeView_GetFirstChild($g_GTVEx_aTVData, $hPassedItem)
	If Not $hChild Then Return
	While 1
		$checkpram = _GUICtrlTreeView_GetItemParam($g_GTVEx_aTVData, $hChild)
		$valparam = $oSNTV.Item($checkpram)
		Switch Number($valparam[1])
			Case 1
				If Not $bState Then
					_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hChild, 2)
					$valparam[1] = 2
				EndIf
			Case 2
				If $bState Then
					_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hChild, 1)
					$valparam[1] = 1
				EndIf
			Case 3
				If Not $bState Then
					_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hChild, 4)
					$valparam[1] = 4
				EndIf
			Case 4
				If $bState Then
					_GUICtrlTreeView_SetStateImageIndex($g_GTVEx_aTVData, $hChild, 3)
					$valparam[1] = 3
				EndIf
		EndSwitch
		$oSNTV.Item($checkpram) = $valparam
		__TVUnCheck($hChild, $bState, $itemf)
		If Not $itemf Then
			$hChild = _GUICtrlTreeView_GetNextChild($g_GTVEx_aTVData, $hChild)
		Else
			$hChild = _GUICtrlTreeView_GetFirstChild($g_GTVEx_aTVData, $hChild)
		EndIf
		If Not $hChild Then ExitLoop
	WEnd
EndFunc   ;==>__TVUnCheck

;~ Дочерние подпункты первого уровня выбранного пункта будут иметь поведение RadioButton. то есть, будет возможен выбор только одного подпункта
;~ При повторной использовании функции для пункта его дочерним подпунктам возвращается исходное поведение - Checkbox
Func _GUITreeViewEx_ChooseOnlyOne($hTVX)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	Local $hParent, $aInfTv
	$aInfTv = $oSNTVEX.Item(String($hTV))
	$hParent = $aInfTv[1]
	If Not $hParent Then Return
	Local $nameparent = _GUICtrlTreeView_GetItemParam($hTV, $hParent)
	Local $aDataItem = $oSNTV.Item($nameparent)
	If Not Number($aDataItem[0]) Then
		$aDataItem[0] = 1
		Switch Number($aDataItem[1])
			Case 1
				$aDataItem[1] = 2
				_GUICtrlTreeView_SetStateImageIndex($hTV, $hParent, 2)
			Case 3
				$aDataItem[1] = 4
				_GUICtrlTreeView_SetStateImageIndex($hTV, $hParent, 4)
		EndSwitch
		$oSNTV.Item($nameparent) = $aDataItem
		_TVCHRD($hTV, $hParent, 4)
		__TVUnCheck($hParent, False)
	ElseIf Number($aDataItem[0]) Then
		$aDataItem[0] = 0
		$oSNTV.Item($nameparent) = $aDataItem
		_TVCHRD($hTV, $hParent, 2)
		__TVUnCheck($hParent, False)
	EndIf
	_AutoUnCheckParents($hParent)
EndFunc   ;==>_GUITreeViewEx_ChooseOnlyOne

;~ Удаление пункта со всеми подпунктами, удаление информации пунктов
Func _GUITreeViewEx_DeleteItem($hTVX)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	Local $aInfTv
	$aInfTv = $oSNTVEX.Item(String($hTV))
	If Not $aInfTv[1] Then Return
	__DeletedKeys($hTV, $aInfTv[1])
	_GUICtrlTreeView_Delete($hTV, $aInfTv[1])
	$fItemDelTV = 0
EndFunc   ;==>_GUITreeViewEx_DeleteItem

Func __DeletedKeys($hTVX, $hItem)
	Local $ParamItem = _GUICtrlTreeView_GetItemParam($hTVX, $hItem)
	$oSNTV.Remove($ParamItem)
	__DeletedNext($hTVX, $hItem)
EndFunc   ;==>__DeletedKeys

Func __DeletedNext($hTVX, $hItem)
	Local $hChild = _GUICtrlTreeView_GetFirstChild($hTVX, $hItem)
	If Not $hChild Then Return
	Local $nextparam
	While 1
		$nextparam = _GUICtrlTreeView_GetItemParam($hTVX, $hChild)
		$oSNTV.Remove($nextparam)
		__DeletedNext($hTVX, $hChild)
		$hChild = _GUICtrlTreeView_GetNextChild($hTVX, $hChild)
		If Not $hChild Then ExitLoop
	WEnd
EndFunc   ;==>__DeletedNext

Func _TVCHRD($hTV, $hPassedItem, $chType)
	Local $checkpram, $valparam
	Local $hChild = _GUICtrlTreeView_GetFirstChild($hTV, $hPassedItem)
	If Not $hChild Then Return
	While 1
		$checkpram = _GUICtrlTreeView_GetItemParam($hTV, $hChild)
		$valparam = $oSNTV.Item($checkpram)
		Switch $chType
			Case 4
				$valparam[1] = 4
				_GUICtrlTreeView_SetStateImageIndex($hTV, $hChild, 4)
			Case 2
				$valparam[1] = 2
				_GUICtrlTreeView_SetStateImageIndex($hTV, $hChild, 2)
		EndSwitch
		$oSNTV.Item($checkpram) = $valparam
		$hChild = _GUICtrlTreeView_GetNextChild($hTV, $hChild)
		If Not $hChild Then ExitLoop
	WEnd
EndFunc   ;==>_TVCHRD

;~ Создание пунктов TreeView. Возвращает дескриптор созданного пункта
Func _GUITreeViewEx_CreateItem($hTVX, $sText, $ctItem = 0)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	If Not $oSNTVEX.Exists(String($hTV)) Then Return SetError(-1)
	Local $sString = StringStripWS($sText, 7)
	If Not $sString Then Return
	$sString = StringRegExpReplace($sString, '[*~|#]', ' ')
	Local $NewName, $hItemNew, $hParent, $valparam, $aInfoTV[2], $nParamItemTV
	While 1
		$NewName = Random(1, 100000, 1)
		If Not $oSNTV.Exists($NewName) Then ExitLoop
	WEnd
	Local $aInfTv
	$aInfTv = $oSNTVEX.Item(String($hTV))
	$nParamItemTV = _GUICtrlTreeView_GetItemParam($hTV, $aInfTv[1])
	Switch $ctItem
		Case 0; 'Основной пункт'
			_GUICtrlTreeView_BeginUpdate($hTV)
			$hItemNew = _GUICtrlTreeView_Add($hTV, 0, $sString)
			_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 2)
			_GUICtrlTreeView_EndUpdate($hTV)
			_GUICtrlTreeView_SetItemParam($hTV, $hItemNew, $NewName)
			_GUICtrlTreeView_EnsureVisible($hTV, $hItemNew)
			$aInfoTV[1] = 2
			$oSNTV.Add($NewName, $aInfoTV)
;~ 			_GUICtrlTreeView_SelectItem($hTV, $hItemNew, $TVGN_CARET)
		Case 1; 'Основной первым'
			_GUICtrlTreeView_BeginUpdate($hTV)
			$hItemNew = _GUICtrlTreeView_AddFirst($hTV, 0, $sString)
			_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 2)
			_GUICtrlTreeView_EndUpdate($hTV)
			_GUICtrlTreeView_SetItemParam($hTV, $hItemNew, $NewName)
			_GUICtrlTreeView_EnsureVisible($hTV, $hItemNew)
			$aInfoTV[1] = 2
			$oSNTV.Add($NewName, $aInfoTV)
;~ 			_GUICtrlTreeView_SelectItem($hTV, $hItemNew, $TVGN_CARET)
		Case 2; 'Дочерний пункт'
			If $aInfTv[1] Then
				_GUICtrlTreeView_BeginUpdate($hTV)
				$hItemNew = _GUICtrlTreeView_AddChild($hTV, $aInfTv[1], $sString)
				_GUICtrlTreeView_EndUpdate($hTV)
				_GUICtrlTreeView_EnsureVisible($hTV, $hItemNew)
				_GUICtrlTreeView_SetItemParam($hTV, $hItemNew, $NewName)
				$valparam = $oSNTV.Item($nParamItemTV)
				Switch Number($valparam[0])
					Case 1
						$aInfoTV[1] = 4
						_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 4)
					Case 0
						$aInfoTV[1] = 2
						_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 2)
				EndSwitch
				$oSNTV.Add($NewName, $aInfoTV)
			EndIf
		Case 3; 'Дочерний первым'
			If $aInfTv[1] Then
				_GUICtrlTreeView_BeginUpdate($hTV)
				$hItemNew = _GUICtrlTreeView_AddChildFirst($hTV, $aInfTv[1], $sString)
				_GUICtrlTreeView_EndUpdate($hTV)
				_GUICtrlTreeView_EnsureVisible($hTV, $hItemNew)
				_GUICtrlTreeView_SetItemParam($hTV, $hItemNew, $NewName)
				$valparam = $oSNTV.Item($nParamItemTV)
				Switch Number($valparam[0])
					Case 1
						$aInfoTV[1] = 4
						_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 4)
					Case 0
						$aInfoTV[1] = 2
						_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 2)
				EndSwitch
				$oSNTV.Add($NewName, $aInfoTV)
			EndIf
		Case 4; 'После указанного'
			If $aInfTv[1] Then
				$hParent = _GUICtrlTreeView_GetParentHandle($hTV, $aInfTv[1])
				_GUICtrlTreeView_BeginUpdate($hTV)
				$hItemNew = _GUICtrlTreeView_InsertItem($hTV, $sString, $hParent, $aInfTv[1])
				_GUICtrlTreeView_EndUpdate($hTV)
				_GUICtrlTreeView_EnsureVisible($hTV, $hItemNew)
				_GUICtrlTreeView_SetItemParam($hTV, $hItemNew, $NewName)
				$valparam = $oSNTV.Item($nParamItemTV)
				Switch Number($valparam[1])
					Case 1, 2
						$aInfoTV[1] = 2
						_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 2)
					Case 3, 4
						$aInfoTV[1] = 4
						_GUICtrlTreeView_SetStateImageIndex($hTV, $hItemNew, 4)
				EndSwitch
				$oSNTV.Add($NewName, $aInfoTV)
;~ 				If Not $hParent Then _GUICtrlTreeView_SelectItem($hTV, $hItemNew, $TVGN_CARET)
			EndIf
	EndSwitch
	Return $hItemNew
EndFunc   ;==>_GUITreeViewEx_CreateItem

;~ Возвращает массив данных текущего пункта, если не указан $ParamItem
Func _GUITreeViewEx_GetItemData($hTVX, $ParamItem = 0, $nTechData = 0)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	If Not $oSNTVEX.Exists(String($hTV)) Then Return SetError(-1)
	Local $aInfTv
	Local $CurrentParam = Number($ParamItem)
	If Not $CurrentParam Then
		$aInfTv = $oSNTVEX.Item(String($hTV))
		If Not $aInfTv[1] Then Return SetError(1)
		$CurrentParam = _GUICtrlTreeView_GetItemParam($hTV, $aInfTv[1])
	EndIf
	If Not $oSNTV.Exists($CurrentParam) Then Return SetError(2)
	Local $aDataItem = $oSNTV.Item($CurrentParam)
	If Not $nTechData Then _ArrayDelete($aDataItem, '0 - 1')
	If Not UBound($aDataItem) Then
		Return SetError(3)
	Else
		Return $aDataItem
	EndIf
EndFunc   ;==>_GUITreeViewEx_GetItemData

;~ Обновляет данные пункта. Данные заменются полностью
;~ $aUserData - Массив данных для обновления
;~ Данные обновляются в текущем пункте, если не указан $ParamItem
;~ Для записи многострочного текста заменяйте @CRLF или @LF на спецсимвол
Func _GUITreeViewEx_SetItemData($hTVX, $aUserData, $ParamItem = 0, $nTechData = 0)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	If Not $oSNTVEX.Exists(String($hTV)) Then Return SetError(-1)
	Local $aInfTv
	Local $checkarray = UBound($aUserData)
	If Not $checkarray Then Return SetError(1)
	Local $CurrentParam = Number($ParamItem)
	If Not $CurrentParam Then
		$aInfTv = $oSNTVEX.Item(String($hTV))
		If Not $aInfTv[1] Then Return SetError(2)
		$CurrentParam = _GUICtrlTreeView_GetItemParam($hTV, $aInfTv[1])
	EndIf
	If Not $oSNTV.Exists($CurrentParam) Then Return SetError(3)
	Local $aDataItem = $oSNTV.Item($CurrentParam)
	If Not $nTechData Then
		Local $aTechData[2] = [$aDataItem[0], $aDataItem[1]]
		_ArrayConcatenate($aTechData, $aUserData)
		If @error Then Return SetError(4)
		$oSNTV.Item($CurrentParam) = $aTechData
	Else
		$oSNTV.Item($CurrentParam) = $aUserData
	EndIf
EndFunc   ;==>_GUITreeViewEx_SetItemData

;~ Удаляет данные пункта
Func _GUITreeViewEx_DelItemData($hTVX, $ParamItem = 0, $nTechData = 0)
	Local $hTV
	If IsHWnd($hTVX) Then
		$hTV = $hTVX
	Else
		$hTV = GUICtrlGetHandle($hTVX)
		If Not $hTV Then Return SetError(1)
	EndIf
	If Not $oSNTVEX.Exists(String($hTV)) Then Return SetError(-1)
	Local $aInfTv
	Local $CurrentParam = Number($ParamItem)
	If Not $CurrentParam Then
		$aInfTv = $oSNTVEX.Item(String($hTV))
		If Not $aInfTv[1] Then Return SetError(1)
		$CurrentParam = _GUICtrlTreeView_GetItemParam($hTV, $aInfTv[1])
	EndIf
	If Not $oSNTV.Exists($CurrentParam) Then Return SetError(2)
	If Not $nTechData Then
		Local $aDataItem = $oSNTV.Item($CurrentParam)
		Local $aTechData[2] = [$aDataItem[0], $aDataItem[1]]
		$oSNTV.Item($CurrentParam) = $aTechData
	Else
		$oSNTV.Item($CurrentParam) = ''
	EndIf
EndFunc   ;==>_GUITreeViewEx_DelItemData



