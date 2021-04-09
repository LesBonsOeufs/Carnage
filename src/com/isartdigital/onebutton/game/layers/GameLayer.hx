package com.isartdigital.onebutton.game.layers;

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
		
		speed = pSpeed;
	}
	
	override function doActionNormal():Void 
	{
		x += speed * GameManager.timeBasedCoeff;
		updateScreenLimits();
	}
}