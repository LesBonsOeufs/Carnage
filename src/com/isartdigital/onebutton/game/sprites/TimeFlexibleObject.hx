package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.utils.Timer;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class TimeFlexibleObject extends StateMovieClip 
{
	private static inline var TIME_BETWEEN_ANIM_FRAME: Float = 0.05;
	private static var timer (get, never): Timer;
	
	private static function get_timer(): Timer {
		return GameManager.timer;
	}
	
	private var countTime: Float = 0;

	private function new(pAssetName:String=null) 
	{
		super(pAssetName);
		
		setState(stateDefault);
	}
	
	override function setState(pState:String, ?pLoop:Bool = false, ?pAutoPlay:Bool = true, ?pStart:UInt = 0):Void 
	{
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
		
		if (countTime >= TIME_BETWEEN_ANIM_FRAME)
		{
			countTime = 0;
			
			if (isAnimEnded)
				renderer.gotoAndStop(1);
			else
				renderer.nextFrame();
		}
	}
	
}