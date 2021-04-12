package com.isartdigital.onebutton.game.sprites;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class MovingObject extends TimeFlexibleObject 
{
	private var xAcceleration: Float = 0;
	private var xVelocity: Float = 0;
	
	private var accelerationValue(get, never): Float;
	private var maxVelocity(get, never): Float;
	
	//à override avec les valeurs correctes dans les classes filles
	private function get_accelerationValue(): Float {
		return null;
	}
	
	//à override avec les valeurs correctes dans les classes filles
	private function get_maxVelocity(): Float {
		return null;
	}

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
		
		x += xVelocity * GameManager.timeBasedCoeff;
		
		if (absVelocity() < maxVelocity)
			xVelocity += xAcceleration * GameManager.timeBasedCoeff;
		else// if (absVelocity() > maxVelocity)
		{
			if (xVelocity < 0)
				xVelocity = -maxVelocity;
			else if (xVelocity > 0)
				xVelocity = maxVelocity;
		}
	}
}