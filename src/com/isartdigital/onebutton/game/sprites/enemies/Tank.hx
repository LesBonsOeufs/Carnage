package com.isartdigital.onebutton.game.sprites.enemies;
import com.isartdigital.onebutton.game.sprites.enemies.Swordsman;
import motion.Actuate;
import motion.easing.Quad;
import openfl.geom.ColorTransform;

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
		if (target.degree != Player.MAX_DEGREE) return false;
		
		if (Math.floor(Math.random() * 8) >= 6)
		{
			setModeRetreat();
			return true;
		}
		
		return false;
	}
	
	override function die():Void 
	{
		if (--health > 0 && target.degree < Player.MAX_DEGREE) 
		{
			Actuate.transform(this, 0.3, false).color(0x8a0303, 0.7).reverse().ease(Quad.easeOut);
			return;
		}
		
		super.die();
	}
	
}