package com.gabrielbernabeu.onebutton.game.sprites;
import com.gabrielbernabeu.onebutton.game.GameManager;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class MovingObject extends TimeFlexibleObject 
{
	private var xAcceleration: Float = 0;
	public var xVelocity(default, null): Float = 0;
	
	private var accelerationValue(get, never): Float;
	private var maxVelocity(get, never): Float;
	
	//à override avec les valeurs correctes dans les classes filles
	private function get_accelerationValue(): Float {
		return 0;
	}
	
	//à override avec les valeurs correctes dans les classes filles
	private function get_maxVelocity(): Float {
		return 0;
	}
	
	private var unlimitVelocity: Bool = false;

	public function new() 
	{
		super();
	}
	
	private function absVelocity(): Float {
		return Math.abs(xVelocity);
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		xVelocity += xAcceleration * GameManager.timeBasedCoeff;
		
		if (!unlimitVelocity)
			clampVelocity();
		
		x += xVelocity * GameManager.timeBasedCoeff;
	}
	
	private function clampVelocity(): Void
	{
		if (absVelocity() > maxVelocity)
		{
			if (xVelocity < 0)
				xVelocity = -maxVelocity;
			else if (xVelocity > 0)
				xVelocity = maxVelocity;
		}
	}
}