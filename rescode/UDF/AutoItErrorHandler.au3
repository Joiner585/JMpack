#include-once

#Region Header

#CS
	Name: 				AutoItErrorHandler - AutoIt critical error handler.
	Author: 			Copyright © 2015 CreatoR's Lab (G.Sandler), www.creator-lab.ucoz.ru, www.autoit-script.ru. All rights reserved.
	AutoIt version: 	3.3.12.0 / 3.3.9.4 / 3.3.8.X / 3.3.6.X
	UDF version:		0.1

	Credits:
	* Firex - SEH.au3 UDF.

	Notes:
	* Use supplied GetErrLineCode.au3 to get proper error line code by line number from error that was triggered in compiled script.
	* Memory leaks errors (hard crash and recursion) are not supported.
	* ATM, works only for compiled script.

	History:

	v0.1
	* First version.

#CE

#include <WindowsConstants.au3>
#include <WinAPIProc.au3>
#include <WinAPILocale.au3>
#include <StaticConstants.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>

#EndRegion Header

#Region Global Variables

Global Enum $iAEH_bSet_ErrLine, $iAEH_bIn_Proc, $iAEH_sMainTitle, $iAEH_sUserFunc, $iAEH_vUserParams, $iAEH_iCOMErrorNumber, $iAEH_sCOMErrorDesc,$iAEH_Total

Global $aAEH_DATA[$iAEH_Total]

#EndRegion Global Variables

#Region User Variables

Global Const $iAEH_CONTINUE_PROC = 1
Global Const $iAEH_TERMINATE_PROC = 0

Global Const $iAEH_ButtonsStyle = 1
Global Const $nAEH_DefWndBkColor = 0xE0DFE2

#EndRegion User Variables

#Region Public Functions

; #FUNCTION# ====================================================================================================
; Name...........:	_OnAutoItErrorRegister
; Description....:	Registers a function to be called when AutoIt produces a critical error (syntax error usualy).
; Syntax.........:	_OnAutoItErrorRegister( [$sFunction = '' [, $vParams = '' [, $sTitle = '' [, $bUseStdOut = False [, $bSetErrLine = False]]]]])
; Parameters.....:	$sFunction        - [Optional] The name of the user function to call.
;                                           If this parameter is empty (''), then default (built-in) error message function is called.
;                                           Function called with these arguments:
;                                           							$sScriptPath 	- Full path to the script / executable
;                                           							$iScriptLine	- Error script line number
;                                           							$sError_Msg		- Error message
;                                           							$vParams		- User parameters passed by $vParams
;                                           							$hBitmap        - [Optional] If the last window was captured, this will contain hBitmap of captured window (and only if $bUseStdOut = False).
;					$vParams          - [Optional] User defined parameters that passed to $sFunction (default is '' - no parameters).
;					$sTitle           - [Optional] The title of the default error message dialog (used only if $sFunction = '').
;
; Return values..:	None.
; Author.........:	G.Sandler (CreatoR), www.autoit-script.ru, www.creator-lab.ucoz.ru
; Remarks........:
; Related........:	_OnAutoItErrorUnRegister
; Example........:	Yes.
; ===============================================================================================================
Func _OnAutoItErrorRegister($sFunction = '', $vParams = '')
	If Not @Compiled Then
		Return SetError(-1, 0, 0)
	EndIf

	If $aAEH_DATA[$iAEH_bIn_Proc] Then
		If $sFunction <> $aAEH_DATA[$iAEH_sUserFunc] Or $aAEH_DATA[$iAEH_sUserFunc] = '' Then
			_OnAutoItErrorUnRegister()
		Else
			Return ;Prevent conflicts
		EndIf
	EndIf

	$aAEH_DATA[$iAEH_bIn_Proc] = True
	$aAEH_DATA[$iAEH_sUserFunc] = $sFunction
	$aAEH_DATA[$iAEH_vUserParams] = $vParams

	Local $iRet = __AEH_Register(True)
	Return SetError(@error, 0, $iRet)
EndFunc   ;==>_OnAutoItErrorRegister

; #FUNCTION# ====================================================================================================================
; Name ..........: _OnAutoItErrorUnRegister
; Description ...: UnRegister AutoIt Error Handler.
; Syntax ........: _OnAutoItErrorUnRegister()
; Parameters ....: None.
; Return values .: None.
; Author ........: Firex
; Remarks .......:
; Related .......: _OnAutoItErrorRegister
; Example .......: Yes.
; ===============================================================================================================================
Func _OnAutoItErrorUnRegister()
	$aAEH_DATA[$iAEH_bIn_Proc] = False
	Return __AEH_Register(False)
EndFunc   ;==>_OnAutoItErrorUnRegister

#EndRegion Public Functions

#Region Internal Functions

Func __AEH_Register($bRegister)
	Local Static $__Au3ErrCallback[2]

	If Not @Compiled Or ((Not $__Au3ErrCallback[0]) <> $bRegister) Then
		Return SetError(-1, 0, False)
	EndIf

	Local $aRes, $hModule, $pOffset, $tPatch, $iOpCode_sz, $pvCallback
	Local $Ver, $Arch = 3 + @AutoItX64

	Local $aLib[5][5] = [[4], _ ;* - ptr32
			['3.3.12.0', 0x0004CE15, 0x000572F2, _
			'0xFF75ECB8*FFD085C07550909090909090909090', _
			'0x488B4C2430B8*FFD085C0755D909090909090909090909090' _
			], _
			['3.3.9.4', 0x00065FAC, 0x000708B0, _
			'0x50B8*FFD085C0754F9090', _
			'0x488B4C2430B8*FFD085C07554909090909090909090909090' _
			], _
			['3.3.8.', 0x0005E8ED, 0x0006CE50, _
			2, _ ;Ref to 3.3.9.4
			2 _  ;Ref to 3.3.9.4
			], _
			['3.3.6.', 0x0005E7EA, 0x000702B3, _
			'0x50B8*FFD085C0755B9090', _
			'0x488B4C2430B8*FFD085C0756890909090909090909090909090909090' _
			] _
			]

	$aRes = DllCall('kernel32.dll', 'handle', 'GetModuleHandle', 'ptr', 0)

	If @error Or Not $aRes[0] Then
		Return SetError(-2, 0, False)
	EndIf

	$hModule = $aRes[0]

	For $Ver = 1 To $aLib[0][0] Step 1
		If Not StringInStr(@AutoItVersion, $aLib[$Ver][0]) Then
			ContinueLoop
		EndIf

		$pOffset = $hModule + Ptr($aLib[$Ver][$Arch - 2]) ; !!! Ptr() 3.3.8.1 <= !!!

		If IsInt($aLib[$Ver][$Arch]) Then
			$Ver = $aLib[$Ver][$Arch] ;Ref to equal path
		EndIf

		$iOpCode_sz = BinaryLen(StringReplace($aLib[$Ver][$Arch], '*', '00000000'))

		;Replace opcode region
		$aRes = DllCall('kernel32.dll', 'bool', 'VirtualProtect', 'ptr', $pOffset, 'ulong', $iOpCode_sz, 'dword', 0x40, 'dword*', '')

		If @error Or Not $aRes[0] Then
			ExitLoop
		EndIf

		$tPatch = DllStructCreate('byte Code[' & $iOpCode_sz & ']', $pOffset)

		If Not $__Au3ErrCallback[0] Then
			If Not $__Au3ErrCallback[1] Then
				$__Au3ErrCallback[1] = DllStructGetData($tPatch, 'Code') ;Save opcode
			EndIf

			$__Au3ErrCallback[0] = DllCallbackRegister('__AEH_OnErrorCallback', 'int', 'ptr')
			$pvCallback = Hex(Binary(DllCallbackGetPtr($__Au3ErrCallback[0])))
			$pvCallback = StringLeft($pvCallback, 8) ;Fix for x64 (dword=4 byte)

			DllStructSetData($tPatch, 'Code', StringReplace($aLib[$Ver][$Arch], '*', $pvCallback))
		Else
			DllStructSetData($tPatch, 'Code', $__Au3ErrCallback[1]) ;Restore opcode

			DllCallbackFree($__Au3ErrCallback[0])
			$__Au3ErrCallback[0] = 0
		EndIf

		DllCall('kernel32.dll', 'bool', 'VirtualProtect', 'ptr', $pOffset, 'ulong', $iOpCode_sz, 'dword', $aRes[4], 'ptr', 0)
		;Replace opcode endregion

		Return True
	Next

	Return SetError(1, 0, False)
EndFunc   ;==>__AEH_Register


Volatile Func __AEH_OnErrorCallback($pErrMsg)
	Local $tError, $aRes

	$aRes = DllCall('kernel32.dll', 'int', 'lstrlenW', 'ptr', $pErrMsg)

	If @error Or Not $aRes[0] Then
		Return $iAEH_TERMINATE_PROC ;Terminate script
	EndIf

	$tError = DllStructCreate('wchar Msg[' & $aRes[0] & ']', $pErrMsg)

	If @error Then
		Return $iAEH_TERMINATE_PROC ;Terminate script
	EndIf

	Local $sError_Msg = DllStructGetData($tError, 'Msg')
	Local $aEnumWin = _WinAPI_EnumWindows()

	For $i = 1 To $aEnumWin[0][0]
		If WinGetProcess($aEnumWin[$i][0]) = @AutoItPID And $aEnumWin[$i][1] = 'AutoIt v3 GUI' Then
			_WinAPI_ShowWindow($aEnumWin[$i][0], @SW_HIDE)
		EndIf
	Next

	Local $sScriptPath, $iScriptLine
	__AEH_ParseErrorMsg($sScriptPath, $iScriptLine, $sError_Msg)

	If @error Then
		Return $iAEH_TERMINATE_PROC ;Terminate script
	EndIf

	Local $iRet
	$iRet = Call($aAEH_DATA[$iAEH_sUserFunc], $sScriptPath, $iScriptLine, $sError_Msg, $aAEH_DATA[$iAEH_vUserParams])

	If @error = 0xDEAD And @extended = 0xBEEF Then
		$iRet = Call($aAEH_DATA[$iAEH_sUserFunc], $sScriptPath, $iScriptLine, $sError_Msg, $aAEH_DATA[$iAEH_vUserParams])
	EndIf

	Return $iRet ;0 - Terminate script ($iAEH_TERMINATE_PROC), 1 - Continue execute ($iAEH_CONTINUE_PROC)
EndFunc   ;==>__AEH_OnErrorCallback

Func __AEH_ParseErrorMsg(ByRef $sPath, ByRef $iLine, ByRef $sMsg)
	Local $sScriptPath_Pttrn = '(?is)^.*Line \d+\s+\(File "(.*?)"\):\s+.*Error: .*'
	Local $sScriptLine_Pttrn = '(?is)^.*Line (\d+)\s+\(File ".*?"\):\s+.*Error: .*'
	Local $sErrDesc_Pttrn = '(?is)^.*Line \d+\s+\(File ".*?"\):\s+(.*Error: .*)'

	If Not StringRegExp($sMsg, $sScriptPath_Pttrn) Then
		Return SetError(1, 0, 0)
	EndIf

	$sPath = StringRegExpReplace($sMsg, $sScriptPath_Pttrn, '\1')
	$iLine = StringRegExpReplace($sMsg, $sScriptLine_Pttrn, '\1')
	$sMsg = StringRegExpReplace($sMsg, $sErrDesc_Pttrn, '\1')

	$sMsg = StringStripWS(StringRegExpReplace($sMsg, '(?mi)^Error:\h*|:$', ''), 3)
EndFunc   ;==>__AEH_ParseErrorMsg