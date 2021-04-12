package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;
import openfl.events.Event;

	
/**
 * ...
 * @author Chadi Husser
 */
class Player extends MeleeObject 
{
	public inline static var INIT_X_OFFSET: Int = 300;
	
	private inline static var BLOCK_STATE: String = "block";
	
	private var controller: Controller;
	
	override function get_animStrikingFrame():Int {
		return 3;
	}
	
	public function new(pController: Controller) 
	{
		super();
		controller = pController;
	}
	
	override public function start():Void 
	{
		super.start();
		controller.addEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.addEventListener(Controller.INPUT_UP, onInputUp);
	}
	
	private function onInputDown(pEvent:Event):Void 
	{
		if (state == MeleeObject.HEAVY_ATTACK_STATE) return;
		
		var lCurrentFrame: UInt = renderer.currentFrame;
		
		setState(BLOCK_STATE);
		
		renderer.gotoAndStop(lCurrentFrame);
	}
	
	private function onInputUp(pEvent:Event):Void 
	{
		if (state != BLOCK_STATE) return;
		
		setState(MeleeObject.HEAVY_ATTACK_STATE);
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		setState(MeleeObject.RUN_STATE);
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		if (state == MeleeObject.HEAVY_ATTACK_STATE && renderer.currentFrame == animStrikingFrame)
			collision();
		
		x -= cast(parent, GameLayer).speed * GameManager.timeBasedCoeff;
	}
	
	private function collision(): Void
	{
		for (obstacle in Obstacle.list)
		{
			if (CollisionManager.hasCollision(obstacle.hitBox, hurtBox, obstacle.hitBoxes, hurtBoxes))
				obstacle.destroy();
		}
		
		for (swordsman in Swordsman.list)
		{
			if (CollisionManager.hasCollision(swordsman.hitBox, hurtBox, swordsman.hitBoxes, hurtBoxes))
				swordsman.destroy();
		}
	}
	
	override function timedAnim():Void 
	{
		var lNextCountTime: Float = countTime + TimeFlexibleObject.timer.deltaTime;
		
		if (state == MeleeObject.HEAVY_ATTACK_STATE)
		{
			if (lNextCountTime >= TimeFlexibleObject.TIME_BETWEEN_ANIM_FRAME && isAnimEnded)
			{
				countTime = 0;
				setState(MeleeObject.RUN_STATE);
				return;
			}
		}
		
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