package com.isartdigital.onebutton.game.layers;

/**
 * ...
 * @author Théo Sabattié
 */
class GameLayer extends Layer
{
	public function new()
	{
		super();
	}
	
	override function doActionNormal():Void 
	{
		x -= GameManager.player.xVelocity * GameManager.timeBasedCoeff;
		updateScreenLimits();
	}
}