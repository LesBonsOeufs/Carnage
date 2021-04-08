package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import openfl.events.Event;

	
/**
 * ...
 * @author Chadi Husser
 */
class Player extends StateMovieClip 
{
	private inline static var RUN_STATE: String = "run";
	private inline static var HEAVY_ATTACK_STATE: String = "attack1";
	
	private var controller:Controller;
	private var gravity:Float = 0.89;
	private var jumpImpulse:Float = -25;
	private var yVelocity:Float = 0;
	
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
	}
	
	private function onInputDown(pEvent:Event):Void 
	{
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
		//yVelocity += gravity;
		//y += yVelocity;
		x -= cast (parent, GameLayer).speed;
		
		if (isAnimEnded) setState(RUN_STATE, true);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		controller.removeEventListener(Controller.INPUT_DOWN, onInputDown);
		controller = null;
	}

}