package com.isartdigital.onebutton.game.sprites.enemies;
import com.isartdigital.onebutton.game.sprites.enemies.Swordsman;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Tank extends Swordsman 
{
	private var health: Int = 2;
	
	override function get_accelerationValue():Float {
		return -4 / GameManager.FPS;
	}
	
	//@:getter(maxVelocity)
	override function get_maxVelocity():Float {
		return 17;
	}
	
	//@:getter(size)
	override function get_size():Float {
		return 1.2;
	}

	public function new() 
	{
		var lClassName:String = Type.getClassName(Swordsman);
		assetName = lClassName.split(".").pop();
		
		super();
	}
	
	override public function fearChance():Bool 
	{
		return false;
	}
	
	override function die():Void 
	{
		if (--health > 0 && target.degree < Player.MAX_DEGREE) return;
		
		super.die();
	}
	
}