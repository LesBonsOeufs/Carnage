package com.isartdigital.onebutton.game;

import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.StateMachine;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Théo Sabattié
 */
class GameLayer extends Layer 
{
	public var speed(default, null):Float;
	
	public function new(pSpeed:Float)
	{
		super();
		
		speed  = pSpeed;
	}
	
	override function doActionNormal():Void 
	{
		x += speed;
		updateScreenLimits();
	}
}