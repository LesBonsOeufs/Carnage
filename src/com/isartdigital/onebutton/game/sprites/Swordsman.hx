package com.isartdigital.onebutton.game.sprites;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Swordsman extends MeleeObject 
{
	private inline static var WALK_STATE: String = "walk";
	private inline static var RUN_TRIGGER_VALUE: Float = 3;
	
	public static var list(default, null): Array<Swordsman> = new Array<Swordsman>();
	
	override function get_accelerationValue():Float {
		return -1 / GameManager.FPS;
	}
	
	override function get_maxVelocity():Float {
		return 4;
	}
	
	override function get_animStrikingFrame():Int {
		return 3;
	}

	public function new() 
	{
		super();
		
		list.push(this);
		scaleX = -1;
	}
	
	static public function doActions(): Void
	{
		for (element in list)
		{
			element.doAction();
		}
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		xAcceleration = accelerationValue;
		
		if (xVelocity != 0)
			if (xVelocity < RUN_TRIGGER_VALUE)
				setState(WALK_STATE);
			else
				setState(MeleeObject.RUN_STATE);
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