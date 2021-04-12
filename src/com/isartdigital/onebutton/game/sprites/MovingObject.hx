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
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		x += xVelocity * GameManager.timeBasedCoeff;
	
		var lXVelocityAbsValue: Float = Math.abs(xVelocity);
		
		if (lXVelocityAbsValue < maxVelocity)
			xVelocity += xAcceleration;
		else if (lXVelocityAbsValue > maxVelocity)
		{
			if (xVelocity < 0)
				xVelocity = -maxVelocity;
			else if (xVelocity > 0)
				xVelocity = maxVelocity;
		}
	}
}