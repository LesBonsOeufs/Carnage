package com.isartdigital.onebutton.game.sprites.enemies;

import com.isartdigital.onebutton.game.sprites.Enemy;
import com.isartdigital.onebutton.game.sprites.Player;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Bowman extends Enemy 
{
	private inline static var LOW_ATTACK: String = "attack2";
	
	private inline static var MIN_MAX_VELOCITY: Float = 6;
	private inline static var MAX_MAX_VELOCITY: Float = 9;
	
	private inline static var REPOSITION_INSTANT_VELOCITY_FRACTION: Float = 1;
	
	private inline static var ATTACK_SPEED: Float = 1;
	
	private inline static var MIN_RANGE: Int = 1200;
	private inline static var MAX_RANGE: Int = 1800;
	
	private var range: Int;
	private var countTimeAttack: Float;
	
	override function get_animStrikingFrame():Int {
		return 6;
	}

	public function new() 
	{
		super();
		
		_maxVelocity = MIN_MAX_VELOCITY + Math.random() * (MAX_MAX_VELOCITY - MIN_MAX_VELOCITY);
		range = Math.floor(MIN_RANGE + Math.random() * (MAX_RANGE - MIN_RANGE));
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		countTimeAttack += GameManager.timer.deltaTime;
		
		var lTargetToX: Float = x - target.x;
		
		if (lTargetToX <= range && lTargetToX > 0)
		{
			if (countTimeAttack >= ATTACK_SPEED)
			{
				countTimeAttack = 0;
				setModeAttack();
				return;
			}
			else
				xVelocity = maxVelocity;
		}
		
		xAcceleration = accelerationValue;
		
		testOutOfBounds();
	}
	
	override function setModeAttack(): Void
	{
		super.setModeAttack();
		
		scaleX = -size;
		setState(MeleeObject.BASIC_ATTACK);
	}
	
	override function doActionAttack(): Void
	{
		super.doActionAttack();
		
		if (renderer.currentFrame == animStrikingFrame && !strikeDone) 
		{
			strikeDone = true;
			shoot();
		}
		
		if (isAnimEnded)
		{
			strikeDone = false;
			xVelocity = 0;
			
			if(!fearChance()) setModeNormal();
		}
	}
	
	private function shoot(): Void
	{
		trace("fiouuu");
	}
	
}