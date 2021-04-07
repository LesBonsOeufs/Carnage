package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;
import openfl.events.Event;

	
/**
 * ...
 * @author Chadi Husser
 */
class Player extends StateMovieClip 
{
	private var controller:Controller;
	private var gravity:Float = 0.89;
	private var jumpImpulse:Float = -25;
	private var yVelocity:Float = 0;
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new(pController:Controller) 
	{
		super();
		controller = pController;
	}
	
	override public function start():Void 
	{
		super.start();
		setState(stateDefault, true);
		controller.addEventListener(Controller.INPUT_DOWN, onInputDown);
	}
	
	private function onInputDown(pEvent:Event):Void 
	{
		yVelocity = jumpImpulse;
	}
	
	override function doActionNormal():Void 
	{
		yVelocity += gravity;
		y += yVelocity;
		x -= cast (parent, GameLayer).speed;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		controller.removeEventListener(Controller.INPUT_DOWN, onInputDown);
		controller = null;
	}

}