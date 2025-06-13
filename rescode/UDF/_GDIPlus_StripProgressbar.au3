;coded by UEZ build 2013-08-15
#include-once
#include <GDIPlus.au3>

Func _GDIPlus_StripProgressbar($fPerc, $iW, $iH, $iVisP = 1, $iBgColorGui = 0x000000, $iFgColor = 0x808080, $iBGColor = 0x0000FF, $iTextColor = 0xFFFFFF, $sFont = 'Arial Black')
	Local $sPerc = Ceiling($fPerc)
	If $sPerc < 0 Then $sPerc = 0
	If $sPerc > 100 Then $sPerc = 100
	_GDIPlus_Startup()
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iW, $iH)
	Local Const $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetPixelOffsetMode($hCtxt, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hCtxt, 0xFF000000 + $iBgColorGui)
	Local $iWidth = $iH * 2, $iLen = $iWidth / 2, $iY
	Local $hBmp = _GDIPlus_BitmapCreateFromScan0($iWidth, $iH)
	Local Const $hCtxt_Bmp = _GDIPlus_ImageGetGraphicsContext($hBmp)
	_GDIPlus_GraphicsSetPixelOffsetMode($hCtxt_Bmp, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)
	Local $hPen = _GDIPlus_PenCreate(0xFF0000000 + $iFgColor), $iPenSize = Int($iH / 12)
	Local $hPen2 = _GDIPlus_PenCreate(0x50000000, $iPenSize)
	_GDIPlus_GraphicsClear($hCtxt_Bmp, 0xFF000000 + $iBGColor)
	Local Static $iX = 0
	For $iY = 0 To $iH - 1
		_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, -$iX + $iY, $iY, -$iX + $iY + $iLen, $iY, $hPen)
		_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, -$iX + $iY + 2 * $iLen, $iY, -$iX + $iY + 3 * $iLen, $iY, $hPen)
	Next
	Local $tPoint1 = DllStructCreate('float;float')
	Local $tPoint2 = DllStructCreate('float;float')
	DllStructSetData($tPoint1, 1, $iW / 2) ;x1
	DllStructSetData($tPoint2, 1, $iW / 2) ;x2
	_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, 0, 0, $iWidth, 0, $hPen2)
	$iX = Mod($iX + 2, $iWidth);2 - скорость вращения
	Local $hTextureBrush = _GDIPlus_TextureCreate($hBmp)
	_GDIPlus_GraphicsFillRect($hCtxt, 0, 0, $sPerc / 100 * $iW, $iH, $hTextureBrush)
;~ 	_GDIPlus_ImageRotateFlip($hBitmap, 6); наклон полос прогресса
	If $iVisP Then
		_GDIPlus_GraphicsSetTextRenderingHint($hCtxt, 5)
		Local $hBrush = _GDIPlus_BrushCreateSolid(0xFF000000 + $iTextColor)
		Local $hFormat = _GDIPlus_StringFormatCreate()
		Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
		Local $hFont = _GDIPlus_FontCreate($hFamily, $iH * 2.5 / 5, 2)
		Local $tLayout = _GDIPlus_RectFCreate(0, 0, $iW, $iH)
		_GDIPlus_StringFormatSetAlign($hFormat, 1)
		_GDIPlus_GraphicsDrawStringEx($hCtxt, $sPerc & '%', $hFont, $tLayout, $hFormat, $hBrush)
		_GDIPlus_FontDispose($hFont)
		_GDIPlus_FontFamilyDispose($hFamily)
		_GDIPlus_StringFormatDispose($hFormat)
		_GDIPlus_BrushDispose($hBrush)
	EndIf
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($hPen2)
	_GDIPlus_GraphicsDispose($hCtxt)
	_GDIPlus_GraphicsDispose($hCtxt_Bmp)
	_GDIPlus_BitmapDispose($hBmp)
	_GDIPlus_BrushDispose($hTextureBrush)
	Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
	Return $hHBITMAP
EndFunc   ;==>_GDIPlus_StripProgressbar
