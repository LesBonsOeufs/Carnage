package com.gabrielbernabeu.utils.ui;

import com.gabrielbernabeu.utils.ui.AlignType;
import openfl.display.DisplayObject;

/**
 * @author Mathieu Anthoine
 */
typedef UIPositionable = {
	var item:DisplayObject;
	var align:AlignType;
	@:optional var offsetX:Float;
	@:optional var offsetY:Float;
	@:optional var update:Bool;
}