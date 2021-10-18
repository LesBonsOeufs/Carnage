package com.gabrielbernabeu.onebutton.game.sprites;

import com.gabrielbernabeu.onebutton.game.GameManager;
import com.gabrielbernabeu.utils.Timer;
import com.gabrielbernabeu.utils.game.stateObjects.StateMovieClip;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class TimeFlexibleObject extends StateMovieClip 
{
	public static inline var BASE_TIME_BETWEEN_ANIM_FRAME: Float = 0.05;
	private static var timer (get, never): Timer;
	
	private var timeBetweenAnimFrame: Float;
	
	private static function get_timer(): Timer {
		return GameManager.timer;
	}
	
	private var countTime: Float = 0;

	private function new() 
	{
		super();
		setState(stateDefault);
		timeBetweenAnimFrame = BASE_TIME_BETWEEN_ANIM_FRAME;
	}
	
	override function setState(pState:String, ?pLoop:Bool = false, ?pAutoPlay:Bool = true, ?pStart:UInt = 0):Void 
	{
		if (state == pState)
		return;
		
		super.setState(pState, pLoop, pAutoPlay, pStart);
		renderer.stop();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		timedAnim();
	}
	
	private function timedAnim():Void 
	{
		countTime += timer.deltaTime;
		
		if (countTime >= timeBetweenAnimFrame)
		{
			countTime = 0;
			
			if (isAnimEnded)
				renderer.gotoAndStop(1);
			else
				renderer.nextFrame();
		}
	}
	
}