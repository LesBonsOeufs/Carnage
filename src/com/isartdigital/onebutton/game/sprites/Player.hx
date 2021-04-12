package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.stateObjects.StateObject;
import openfl.events.Event;

	
/**
 * ...
 * @author Chadi Husser
 */
class Player extends MeleeObject 
{
	private inline static var BLOCK: String = "block";
	
	public inline static var INIT_X_OFFSET: Int = 300;
	
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
		if (state == MeleeObject.HEAVY_ATTACK) return;
		
		var lCurrentFrame: UInt = renderer.currentFrame;
		
		setState(BLOCK);
		
		renderer.gotoAndStop(lCurrentFrame);
	}
	
	private function onInputUp(pEvent:Event):Void 
	{
		if (state != BLOCK) return;
		
		setState(MeleeObject.HEAVY_ATTACK);
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		setState(MeleeObject.RUN);
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		if (state == MeleeObject.HEAVY_ATTACK && renderer.currentFrame == animStrikingFrame)
			collision();
		
		x -= cast(parent, GameLayer).speed * GameManager.timeBasedCoeff;
	}
	
	private function collision(): Void
	{
		var lObstacle: Obstacle;
		var lSwordsman: Swordsman;
		var i: Int;
		
		i = Obstacle.list.length - 1;
		while (i > -1)
		{
			lObstacle = Obstacle.list[i];
			
			if (CollisionManager.hasCollision(lObstacle.hitBox, hurtBox, lObstacle.hitBoxes, hurtBoxes))
				lObstacle.destroy();
			
			i--;
		}
		
		i = Swordsman.list.length - 1;
		while (i > -1)
		{
			lSwordsman = Swordsman.list[i];
			
			if (CollisionManager.hasCollision(lSwordsman.hitBox, hurtBox, lSwordsman.hitBoxes, hurtBoxes))
				lSwordsman.destroy();
			
			i--;
		}
	}
	
	override function timedAnim():Void 
	{
		var lNextCountTime: Float = countTime + TimeFlexibleObject.timer.deltaTime;
		
		if (state == MeleeObject.HEAVY_ATTACK)
		{
			if (lNextCountTime >= TimeFlexibleObject.TIME_BETWEEN_ANIM_FRAME && isAnimEnded)
			{
				countTime = 0;
				setState(MeleeObject.RUN);
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