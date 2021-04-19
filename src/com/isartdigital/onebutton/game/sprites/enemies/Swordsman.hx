package com.isartdigital.onebutton.game.sprites.enemies;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.onebutton.game.sprites.Player;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.sound.SoundManager;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import org.zamedev.particles.ParticleSystem;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Swordsman extends Enemy 
{	
	private inline static var BONUS_REACH: Float = 0;
	private inline static var RETREAT_ACCELERATION: Float = 6 / GameManager.FPS;
	
	private inline static var REPOSITION_ACCELERATION: Float = 10 / GameManager.FPS;
	private inline static var REPOSITION_MAX_VELOCITY_COEFF: Float = 2.65;
	private inline static var REPOSITION_INSTANT_VELOCITY_FRACTION: Float = 3;
	
	private inline static var MIN_MAX_VELOCITY: Float = 4;
	private inline static var MAX_MAX_VELOCITY: Float = 7;
	
	private inline static var MIN_ADDED_REPOSITION: Float = 500;
	private inline static var MAX_ADDED_REPOSITION: Float = 800;
	
	private var minReposition: Float;
	private var maxReposition: Float;
	
	private var normalMaxVelocity: Float;
	private var repositionMaxVelocity: Float;
	
	private var randomReposition: Float;
	
	override function get_animStrikingFrame():Int {
		return 8;
	}

	public function new() 
	{	
		super();
		
		normalMaxVelocity = MIN_MAX_VELOCITY + Math.random() * (MAX_MAX_VELOCITY - MIN_MAX_VELOCITY);
		repositionMaxVelocity = normalMaxVelocity * REPOSITION_MAX_VELOCITY_COEFF;
		maxReposition = getReach() + MAX_ADDED_REPOSITION;
		minReposition = getReach() + MIN_ADDED_REPOSITION;
	}
	
	override public function start():Void 
	{
		super.start();	
		fearChance();
	}
	
	private function getReach(): Float {
		return hurtBox.width + BONUS_REACH + target.xVelocity * 26;
	}
	
	override function fearChance(): Bool
	{
		if (Math.floor(Math.random() * 21) >= 20 - 8 * target.degree / Player.MAX_DEGREE)
		{
			setModeRetreat();
			return true;
		}
		
		return false;
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		_maxVelocity = normalMaxVelocity;
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		var lTargetToX: Float = x - target.x;
		
		if (lTargetToX <= getReach() && lTargetToX > 0)
		{
			setModeAttack();
			return;
		}
		
		xAcceleration = accelerationValue;
		
		if (absVelocity() <= normalMaxVelocity)
			unlimitVelocity = false;
		
		testOutOfBounds();
	}
	
	private function setModeRetreat(): Void
	{
		doAction = doActionRetreat;
		xAcceleration = accelerationValue;
	}
	
	private function doActionRetreat(): Void
	{
		super.doActionNormal();
		
		var targetToX: Float = x - target.x;
		
		if (targetToX < 0)
			xAcceleration = -RETREAT_ACCELERATION;
		else if (targetToX <= 1250 + getReach())
			xAcceleration = RETREAT_ACCELERATION;
		
		testOutOfBounds();
	}
	
	override function setModeAttack(): Void
	{
		super.setModeAttack();
		
		setState(MeleeObject.BASIC_ATTACK);
	}
	
	override function doActionAttack(): Void
	{
		super.doActionAttack();
		
		if (renderer.currentFrame == animStrikingFrame && !strikeDone)
		{
			strikeDone = true;
			weaponCollision();
		}
		
		if (isAnimEnded)
		{
			strikeDone = false;
			xVelocity = 0;
			
			if(!fearChance()) setModeReposition();
		}
	}
	
	private function setModeReposition(): Void
	{
		doAction = doActionReposition;
		xAcceleration = REPOSITION_ACCELERATION;
		_maxVelocity = repositionMaxVelocity;
		xVelocity = maxVelocity / REPOSITION_INSTANT_VELOCITY_FRACTION;
		randomReposition = minReposition + Math.random() * (maxReposition - minReposition);
	}
	
	private function doActionReposition(): Void
	{
		super.doActionNormal();
		
		var lTargetToX: Float = x - target.x;
		
		if (lTargetToX > randomReposition)
		{
			unlimitVelocity = true;
			setModeNormal();
		}
		
		testOutOfBounds();
	}
	
	override function weaponCollision():Void 
	{
		if (CollisionManager.hasCollision(hurtBox, target.hitBox, hurtBoxes, target.hitBoxes))
		{
			var lRandomSoundIndex: Int = Math.floor(Math.random() * 2);
			
			if (target.isBlocking())
				SoundManager.getSound("player_block" + lRandomSoundIndex).start();
			else
			{
				target.degreeBar -= damage;
				SoundManager.getSound("swordsman_hit" + lRandomSoundIndex).start();
			}
		}
		else
			SoundManager.getSound("swordsman_miss").start();
	}
}