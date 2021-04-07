package com.isartdigital.onebutton.game;

import com.isartdigital.utils.game.StateMachine;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Théo Sabattié
 */
class ParallaxLayer extends Layer 
{
	private var target:DisplayObject;
	private var offsetCoef:Float;
	
	public function new(pOffsetCoef:Float, pTarget:DisplayObject) 
	{
		super();
		offsetCoef = pOffsetCoef;
		target = pTarget;
	}
	
	override function doActionNormal():Void 
	{
		x = target.x - offsetCoef;
		updateScreenLimits();
	}
	
	override public function destroy():Void 
	{
		target = null;
		super.destroy();
	}
}