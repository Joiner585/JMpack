

#include-once

; Имя.....................: _FFSearch
; Назначение..............: Поиск файлов и папок
; Синтаксис...............: _FileSearch($sPath, [$sExt = '',[ $iPart = 0, [$iDepth = 0,[ $aArray = 1]]]])
; Параметры...............: $sPath - Путь поиска(строка)
;                           $sExt - Имя и расширение, или имя(часть имени), или расширение(строка).Можно использовать несколько данных для поиска. Использовать разделитель '|'. Расширения пишутся без точки: exe|txt|jpg
;                           $iPart - Параметры поиска(число)
;                                |0 - Поиск файлов и папок.Если $sExt пуст, то будут возвращены все файлы и папки. Если $sExt равен строке, то будут возвращены все файлы и папки, имена которых частично или полностью совпадают со строкой $sExt
;                                |1 - Поиск файлов по имени и расширению |
;                                |2 - Поиск файлов по имени              |Если $sExt пуст, то будут возвращены все файлы
;                                |3 - Поиск файлов по расширению         |
;                                |4 - Поиск папок по имени. Полное совпадение имени. Если $sExt пуст, то будут возвращены все папки
;                                |5 - Поиск пустых папок(внутри нет ни папок ни файлов)
;                                |6 - Поиск файлов нулевого размера
;                                |7 - Поиск пустых папок(внутри есть папки, но они пустые)
;                                |11(5+6) - Поиск пустых папок и файлов нулевого размера
;                          $iDepth - Глубина поиска(число)
;                                |0 - Поиск во всех папках
;                                |1 - Поиск на первом уровне
;                          $aArray - Вид массива(число)
;                                |1 - Первый элемент массива содержит количество элементов массива
;                                |2 - Отключить возвращение количества элементов в первый элемент массива (необходимо использовать UBound(), чтобы получить размер массива)
; Возвращаемые значения...: Успех - Массив найденных файлов и/или папок
; Ошибки..................: Ошибки 1, 3, 4, 5 - указывают на ошибку в параметрах функции. Номер ошибки соответствует порядковому номеру параметра функции
;                           6 - Папка пуста(путь не существует)
;                           7 - Ничего не найдено
; Автор...................: Joiner
Func _FFSearch($sPath, $sExt = '', $iPart = 0, $iDepth = 0, $aArray = 1)
	$sPath = StringStripWS($sPath, 3)
	$iPart = Number($iPart)
	$iDepth = Number($iDepth)
	$aArray = Number($aArray)
	Select
		Case $sPath = ''
			Return SetError(1)
		Case ($iPart < 0 Or $iPart > 7) And $iPart <> 11
			Return SetError(3)
		Case $iDepth < 0 Or $iDepth > 1
			Return SetError(4)
		Case $aArray < 1 Or $aArray > 2
			Return SetError(5)
	EndSelect
	If StringCompare(StringRight($sPath, 1), '\') Then $sPath = $sPath & '\'
	Local $sFileList
	If StringInStr($sExt, '|') Then
		Local $sDelim = StringSplit($sExt, '|', 1)
		For $i = 1 To $sDelim[0]
			__FFSearchAll($sFileList, $sPath, $sDelim[$i], $iPart, $iDepth)
			If @error Then Return SetError(6)
		Next
	Else
		__FFSearchAll($sFileList, $sPath, $sExt, $iPart, $iDepth)
		If @error Then Return SetError(6)
	EndIf
	$sFileList = StringTrimRight($sFileList, 1)
	If Not $sFileList Then Return SetError(7)
	$sFileList = StringSplit($sFileList, '|', $aArray)
	Return $sFileList
EndFunc   ;==>_FFSearch

Func __FFSearchAll(ByRef $sFileList, $sPath, $sExt = '', $iPart = 0, $iDepth = 0)
	Local $sFile = '', $hFirstFile = FileFindFirstFile($sPath & '*'), $lastpoint, $RetString = ''
	If $hFirstFile = -1 Then Return SetError(1)
	Local $aEmptyF
	While 1
		$sFile = FileFindNextFile($hFirstFile)
		If @error Then ExitLoop
		If @extended Then
			If $sExt Then
				Switch $iPart
					Case 0
						If StringInStr($sFile, $sExt) Then $sFileList &= $sPath & $sFile & '|'
					Case 4
						If Not StringCompare($sFile, $sExt) Then $sFileList &= $sPath & $sFile & '|'
					Case 5, 11
						$aEmptyF = DirGetSize($sPath & $sFile, 1)
						If Not @error Then
							If Not $aEmptyF[1] And Not $aEmptyF[2] Then $sFileList &= $sPath & $sFile & '|'
						EndIf
					Case 7
						$aEmptyF = DirGetSize($sPath & $sFile, 1)
						If Not @error Then
							If Number($aEmptyF[1]) = 0 Then $sFileList &= $sPath & $sFile & '|'
						EndIf
				EndSwitch
			Else
				Switch $iPart
					Case 0, 4
						$sFileList &= $sPath & $sFile & '|'
					Case 5, 11
						$aEmptyF = DirGetSize($sPath & $sFile, 1)
						If Not @error Then
							If Number($aEmptyF[1]) = 0 And Number($aEmptyF[2]) = 0 Then $sFileList &= $sPath & $sFile & '|'
						EndIf
					Case 7
						$aEmptyF = DirGetSize($sPath & $sFile, 1)
						If Not @error Then
							If Number($aEmptyF[1]) = 0 Then $sFileList &= $sPath & $sFile & '|'
						EndIf
				EndSwitch
			EndIf
			If Not $iDepth Then __FFSearchAll($sFileList, $sPath & $sFile & '\', $sExt, $iPart, $iDepth)
		Else
			If $sExt Then
				$lastpoint = StringInStr($sFile, '.', 0, -1)
				Switch $iPart
					Case 0
						$RetString = StringLeft($sFile, $lastpoint - 1)
						If StringInStr($RetString, $sExt) Then $sFileList &= $sPath & $sFile & '|'
					Case 1
						If Not StringCompare($sFile, $sExt) Then $sFileList &= $sPath & $sFile & '|'
					Case 2
						$RetString = StringLeft($sFile, $lastpoint - 1)
						If Not StringCompare($RetString, $sExt) Then $sFileList &= $sPath & $sFile & '|'
					Case 3
						$RetString = StringTrimLeft($sFile, $lastpoint)
						If Not StringCompare($RetString, $sExt) Then $sFileList &= $sPath & $sFile & '|'
					Case 6, 11
						If Not FileGetSize($sPath & $sFile) Then $sFileList &= $sPath & $sFile & '|'
				EndSwitch
			Else
				Switch $iPart
					Case 0 To 3
						$sFileList &= $sPath & $sFile & '|'
					Case 6, 11
						If Not FileGetSize($sPath & $sFile) Then $sFileList &= $sPath & $sFile & '|'
				EndSwitch
			EndIf
		EndIf
	WEnd
	FileClose($hFirstFile)
EndFunc   ;==>__FFSearchAll
