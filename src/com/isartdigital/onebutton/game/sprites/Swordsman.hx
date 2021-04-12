package com.isartdigital.onebutton.game.sprites;
import com.isartdigital.onebutton.game.layers.GameLayer;
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
	
	private inline static var RUN_TRIGGER_VALUE: Float = 4.5;
	private inline static var RETREAT_ACCELERATION: Float = 6 / GameManager.FPS;
	
	private inline static var MIN_MAX_VELOCITY: Float = 4;
	private inline static var MAX_MAX_VELOCITY: Float = 8;
	
	private var _maxVelocity: Float;
	
	public static var list(default, null): Array<Swordsman> = new Array<Swordsman>();
	
	private var target: DisplayObject;
	
	override function get_accelerationValue():Float {
		return -2 / GameManager.FPS;
	}
	
	override function get_maxVelocity():Float {
		return _maxVelocity;
	}
	
	override function get_animStrikingFrame():Int {
		return 3;
	}

	public function new(?pTarget: DisplayObject = null) 
	{
		super();
		
		list.push(this);
		scaleX = -1;
		
		if (pTarget == null)
			target = GameManager.player;
		
		_maxVelocity = MIN_MAX_VELOCITY + Math.random() * (MAX_MAX_VELOCITY - MIN_MAX_VELOCITY);
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
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		var targetToX: Float = x - target.x;
		
		if (targetToX <= 1500)
		{
			if (targetToX >= 0)
				xAcceleration = RETREAT_ACCELERATION;
			else
				xAcceleration = accelerationValue;
		}
		else if (state != RETREAT)
		{
			xAcceleration = accelerationValue;
		}
		
		//if (scaleX == -1 && targetToX < 0 && (state == WALK || state == MeleeObject.RUN))
		//{
			//trace("DEVIANT!!!!" + ">>> xVelocity: " + xVelocity);
			//destroy();
			//return;
		//}
		
		if (x + width / 2 < cast(parent, GameLayer).screenLimits.left)
			destroy();		
	}
	
	override function timedAnim():Void 
	{
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