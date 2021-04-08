package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import openfl.events.Event;

	
/**
 * ...
 * @author Chadi Husser
 */
class Player extends TimeFlexibleStateMovieClip 
{
	private inline static var RUN_STATE: String = "run";
	private inline static var BLOCK_STATE: String = "block";
	private inline static var HEAVY_ATTACK_STATE: String = "attack1";
	
	private var controller:Controller;
	
	public function new(pController:Controller) 
	{
		super();
		controller = pController;
	}
	
	override public function start():Void 
	{
		setState(stateDefault, true);
		super.start();
		controller.addEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.addEventListener(Controller.INPUT_UP, onInputUp);
	}
	
	private function onInputDown(pEvent:Event):Void 
	{
		if (state == HEAVY_ATTACK_STATE) return;
		
		var lCurrentFrame: UInt = renderer.currentFrame;
		
		setState(BLOCK_STATE);
		
		renderer.gotoAndStop(lCurrentFrame);
	}
	
	private function onInputUp(pEvent:Event):Void 
	{
		if (state != BLOCK_STATE) return;
		
		//yVelocity = jumpImpulse;
		setState(HEAVY_ATTACK_STATE);
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		setState(RUN_STATE);
	}
	
	override function doActionNormal():Void 
	{
		//trace(state);
		
		timedAnim();
		
		//trace(controller.maintained);
		
		//yVelocity += gravity;
		//y += yVelocity;
		x -= cast (parent, GameLayer).speed;
	}
	
	override function timedAnim():Void 
	{
		var lNextCountTime: Float = countTime + TimeFlexibleStateMovieClip.timer.deltaTime;
		
		if (state == HEAVY_ATTACK_STATE)
			if (lNextCountTime >= TimeFlexibleStateMovieClip.TIME_BETWEEN_ANIM_FRAME && isAnimEnded)
				setState(RUN_STATE);
		
		super.timedAnim();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		controller.removeEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.removeEventListener(Controller.INPUT_UP, onInputUp);
		controller = null;
	}

}