package com.gabrielbernabeu.onebutton.game.layers;
import com.gabrielbernabeu.onebutton.game.GameManager;

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