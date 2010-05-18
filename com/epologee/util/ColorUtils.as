package com.epologee.util {	import flash.display.DisplayObject;	import flash.display.GradientType;	import flash.display.Graphics;	import flash.geom.ColorTransform;	import flash.geom.Matrix;	/**	 * @author epologee	 */	public class ColorUtils {		public static function composeColor(inR : Number, inG : Number, inB : Number, inIsNormalized : Boolean = true) : uint {			var r : uint = NumberUtils.limit(inR * (inIsNormalized ? 0xFF : 1), 0, 0xFF);			var g : uint = NumberUtils.limit(inG * (inIsNormalized ? 0xFF : 1), 0, 0xFF);			var b : uint = NumberUtils.limit(inB * (inIsNormalized ? 0xFF : 1), 0, 0xFF);			var s : uint = r << 16;			s += g << 8;			s += b;						return s;		}		public static function multiplyColor(inColor : uint, inMultiplication : Number) : uint {			var r : uint = inColor >> 16 & 0xFF;			var g : uint = inColor >> 8 & 0xFF;			var b : uint = inColor & 0xFF;						r = NumberUtils.limit(r * inMultiplication, 0, 0xFF);			g = NumberUtils.limit(g * inMultiplication, 0, 0xFF);			b = NumberUtils.limit(b * inMultiplication, 0, 0xFF);						var s : uint = r << 16;			s += g << 8;			s += b;									return s;		}		public static function getRandomColor(inChannelMinimum : uint = 0x00, inChannelMaximum : uint = 0xFF) : uint {			var colorDiff : uint = inChannelMaximum - inChannelMinimum;						var r : uint = inChannelMinimum + Math.random() * colorDiff;			var g : uint = inChannelMinimum + Math.random() * colorDiff;			var b : uint = inChannelMinimum + Math.random() * colorDiff;			var s : uint = r << 16;			s += g << 8;			s += b;						return s;		}		public static function beginVerticalGradientFill(inGraphics : Graphics, inY : Number, inHeight : Number, ...inColorAlphas : Array) : void {			var colors : Array = [];			var alphas : Array = [];			var ratios : Array = [];			createColorsAlphasRatios(colors, alphas, ratios, inColorAlphas);						var matrix : Matrix = new Matrix();			matrix.createGradientBox(inHeight, 1);			matrix.rotate(Math.PI / 2);			matrix.translate(0, inY);				inGraphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);		}		public static function beginAngularGradientFill(inGraphics : Graphics, inTopLeftX : Number, inTopLeftY : Number, inLength : Number, inAngle : Number = Math.PI / 2, ...inColorAlphas : Array) : void {			var colors : Array = [];			var alphas : Array = [];			var ratios : Array = [];			createColorsAlphasRatios(colors, alphas, ratios, inColorAlphas);						var matrix : Matrix = new Matrix();			matrix.createGradientBox(inLength, 1);			matrix.rotate(inAngle);			matrix.translate(inTopLeftX, inTopLeftY);						inGraphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);		}		public static function beginCircularGradientFill(inGraphics : Graphics, inCenterX : Number, inCenterY : Number, inDiameter : Number, inStartColor : uint, inStartAlpha : Number, inEndColor : uint, inEndAlpha : Number) : void {			var colors : Array = [inStartColor, inEndColor];			var alphas : Array = [inStartAlpha, inEndAlpha];			var ratios : Array = [0, 255];			var matrix : Matrix = new Matrix();			matrix.createGradientBox(inDiameter, inDiameter, 0, inCenterX - inDiameter / 2, inCenterY - inDiameter / 2);			//			matrix.translate(inCenterX, inCenterY);			inGraphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);		}		public static function RGBtoHSV(inColor : uint) : Array {			var r : uint = inColor >> 16 & 0xFF;			var g : uint = inColor >> 8 & 0xFF;			var b : uint = inColor & 0xFF;			var max : uint = Math.max(r, g, b);			var min : uint = Math.min(r, g, b); 			var hue : Number = 0;			var saturation : Number = 0;			var value : Number = 0; 			//get Hue			if(max == min) {				hue = 0;			}else if(max == r) {				hue = (60 * (g - b) / (max - min) + 360) % 360;			}else if(max == g) {				hue = (60 * (b - r) / (max - min) + 120);			}else if(max == b) {				hue = (60 * (r - g) / (max - min) + 240);			} 			//get Value			value = max; 			//get Saturation			if(max == 0) {				saturation = 0;			} else {				saturation = (max - min) / max;			} 			return [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];		}		public static function HSVtoRGB(h : Number, s : Number, v : Number) : Array {			var r : Number = 0;			var g : Number = 0;			var b : Number = 0;			var rgb : Array = []; 			var tempS : Number = s / 100;			var tempV : Number = v / 100; 			var hi : int = Math.floor(h / 60) % 6;			var f : Number = h / 60 - Math.floor(h / 60);			var p : Number = (tempV * (1 - tempS));			var q : Number = (tempV * (1 - f * tempS));			var t : Number = (tempV * (1 - (1 - f) * tempS)); 			switch(hi) {				case 0: 					r = tempV; 					g = t; 					b = p; 					break;				case 1: 					r = q; 					g = tempV; 					b = p; 					break;				case 2: 					r = p; 					g = tempV; 					b = t; 					break;				case 3: 					r = p; 					g = q; 					b = tempV; 					break;				case 4: 					r = t; 					g = p; 					b = tempV; 					break;				case 5: 					r = tempV; 					g = p; 					b = q; 					break;			} 			rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];			return rgb;		}		private static function createColorsAlphasRatios(inColors : Array, inAlphas : Array, inRatios : Array, inColorAlphas : Array) : void {			var spacing : int = 255 / ((inColorAlphas.length / 2) - 1);						for (var i : int = 0;i < inColorAlphas.length;i++) {				var j : int = i / 2;				if (i % 2 == 0) {					inColors.push(inColorAlphas[i]);					inRatios.push(Math.max(Math.min(j * spacing, 255), 0));				} else {					inAlphas.push(inColorAlphas[i]);				}			}		}		public static function setExposure(inTarget : DisplayObject, inExposure : Number) : void {			var exposure : ColorTransform = new ColorTransform();			exposure.redOffset = exposure.greenOffset = exposure.blueOffset = 255 * (inExposure - 1);			inTarget.transform.colorTransform = exposure;		}
	}}