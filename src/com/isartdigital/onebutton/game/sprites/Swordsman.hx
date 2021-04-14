package com.isartdigital.onebutton.game.sprites;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Swordsman extends MeleeObject 
{
	private inline static var LIGHT_ATTACK: String = "attack2";
	private inline static var RETREAT: String = "walkBack";
	private inline static var WALK: String = "walk";
	
	private inline static var MAX_BONUS_REACH: Float = 170;
	private inline static var MIN_BONUS_REACH: Float = 145;
	private inline static var ATTACK_COOLDOWN: Float = 1;
	private inline static var RUN_TRIGGER_VALUE: Float = 3.5;
	private inline static var RETREAT_ACCELERATION: Float = 6 / GameManager.FPS;
	private inline static var REPOSITION_ACCELERATION: Float = 15 / GameManager.FPS;
	
	private inline static var MIN_MAX_VELOCITY: Float = 4;
	private inline static var MAX_MAX_VELOCITY: Float = 7;
	
	private inline static var MIN_ADDED_REPOSITION: Float = 500;
	private inline static var MAX_ADDED_REPOSITION: Float = 800;
	private var minReposition: Float;
	private var maxReposition: Float;
	
	private var _maxVelocity: Float;
	private var normalMaxVelocity: Float;
	private var repositionMaxVelocity: Float;
	private var bonusReach: Float;
	
	private var countAttackCooldown: Float = 0;
	
	private var randomReposition: Float;
	
	public static var list(default, null): Array<Swordsman> = new Array<Swordsman>();
	
	private var target: StateMovieClip;
	
	override function get_accelerationValue():Float {
		return -3 / GameManager.FPS;
	}
	
	override function get_maxVelocity():Float {
		return _maxVelocity;
	}
	
	override function get_animStrikingFrame():Int {
		return 7;
	}

	public function new(?pTarget: DisplayObject = null) 
	{
		super();
		
		list.push(this);
		scaleX = -1;
		
		if (pTarget == null)
			target = GameManager.player;
		
		normalMaxVelocity = MIN_MAX_VELOCITY + Math.random() * (MAX_MAX_VELOCITY - MIN_MAX_VELOCITY);
		repositionMaxVelocity = normalMaxVelocity * 2.65;
		maxReposition = getReach() + MAX_ADDED_REPOSITION;
		minReposition = getReach() + MIN_ADDED_REPOSITION;
		bonusReach = MIN_BONUS_REACH + Math.random() * (MAX_BONUS_REACH - MIN_BONUS_REACH);
	}
	
	override public function start():Void 
	{
		super.start();
		
		if (Math.floor(Math.random() * 11) == 10) setModeRetreat();
	}
	
	static public function doActions(): Void
	{
		var i: Int = list.length - 1;
		while (i > -1)
		{
			list[i].doAction();
			i--;
		}
	}
	
	private function getReach(): Float
	{
		return hurtBox.width + bonusReach;
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
			if (countAttackCooldown >= ATTACK_COOLDOWN)
			{
				scaleX = -1;
				setModeAttack();
			}
			else
				setModeReposition();
			
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
		else if (targetToX <= 1500)
			xAcceleration = RETREAT_ACCELERATION;
		
		testOutOfBounds();
	}
	
	private function setModeAttack(): Void
	{
		doAction = doActionAttack;
		setState(MeleeObject.HEAVY_ATTACK);
	}
	
	private function doActionAttack(): Void
	{
		super.timedAnim();
		
		if (renderer.currentFrame == animStrikingFrame)
			weaponCollision();
		
		if (isAnimEnded)
		{
			countAttackCooldown = 0;
			xVelocity = 0;
			
			if (Math.floor(Math.random() * 11) >= 9)
				setModeRetreat();
			else
				setModeReposition();
		}
	}
	
	private function setModeReposition(): Void
	{
		doAction = doActionReposition;
		xAcceleration = REPOSITION_ACCELERATION;
		_maxVelocity = repositionMaxVelocity;
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
			trace("boum");
		}
	}
	
	private function testOutOfBounds(): Void
	{
		if (x + width / 2 < cast(parent, GameLayer).screenLimits.left)
			destroy();
	}
	
	override function timedAnim():Void 
	{
		countAttackCooldown += GameManager.timer.deltaTime;
		
		if (xVelocity != 0)
		{
			if (absVelocity() < RUN_TRIGGER_VALUE)
			{
				if (scaleX != -1)
					scaleX = -1;
				
				if (xVelocity > 0)
					setState(RETREAT);
				else
					setState(WALK);
			}
			else 
			{
				if (xVelocity > 0 && scaleX != 1)
					scaleX = 1;
				
				setState(MeleeObject.RUN);
			}
		}
		
		super.timedAnim();
	}
	
	static public function reset(): Void
	{
		var i: Int = list.length;
		
		while (i > -1)
		{
			list[i].destroy();
			i--;
		}
	}
	
	override public function destroy():Void 
	{
		list.remove(this);
		super.destroy();
	}
}