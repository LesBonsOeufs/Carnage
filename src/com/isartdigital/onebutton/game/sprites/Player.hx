package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.stateObjects.StateObject;
import com.isartdigital.utils.sound.SoundManager;
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
		
		if (state == MeleeObject.HEAVY_ATTACK && renderer.currentFrame == animStrikingFrame && !strikeDone)
		{
			strikeDone = true;
			weaponCollision();
		}
		
		x -= cast(parent, GameLayer).speed * GameManager.timeBasedCoeff;
	}
	
	override function weaponCollision():Void
	{
		var lObstacle: Obstacle;
		var lSwordsman: Swordsman;
		var lMissed: Bool = true;
		var lRandomSoundIndex: Int;
		
		var i: Int;
		
		i = Obstacle.list.length - 1;
		while (i > -1)
		{
			lObstacle = Obstacle.list[i];
			
			if (CollisionManager.hasCollision(lObstacle.hitBox, hurtBox, lObstacle.hitBoxes, hurtBoxes))
			{
				lRandomSoundIndex = Math.floor(Math.random() * 2);
				lMissed = false;
				SoundManager.getSound("player_hit_wood" + lRandomSoundIndex).start();
				lObstacle.destroy();
			}
			
			i--;
		}
		
		i = Swordsman.list.length - 1;
		while (i > -1)
		{
			lSwordsman = Swordsman.list[i];
			
			if (CollisionManager.hasCollision(lSwordsman.hitBox, hurtBox, lSwordsman.hitBoxes, hurtBoxes))
			{
				lRandomSoundIndex = Math.floor(Math.random() * 2);
				lMissed = false;
				SoundManager.getSound("player_hit_armor" + lRandomSoundIndex).start();
				lSwordsman.die();
			}
			
			i--;
		}
		
		if (lMissed == true)
		{
			lRandomSoundIndex = Math.floor(Math.random() * 2);
			SoundManager.getSound("player_miss" + lRandomSoundIndex).start();
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
				strikeDone = false;
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