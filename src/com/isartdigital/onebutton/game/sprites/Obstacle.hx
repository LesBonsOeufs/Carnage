package com.isartdigital.onebutton.game.sprites;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;
import org.zamedev.particles.ParticleSystem;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Obstacle extends TimeFlexibleObject 
{
	public static var list(default, null): Array<Obstacle> = new Array<Obstacle>();

	public function new() 
	{
		super();
		
		list.push(this);
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
		
		var lPlayer: Player = GameManager.player;
		
		//if (CollisionManager.hasCollision(hitBox, lPlayer.hitBox, hitBoxes, lPlayer.getGlobalHitPoints()))
			//trace("ok");
		
		if (x + width / 2 < cast(parent, GameLayer).screenLimits.left)
			destroy();
	}
	
	static public function reset(): Void
	{
		var i: Int = list.length - 1;
		
		while (i > -1)
		{
			list[i].destroy();
			i--;
		}
	}
	
	override public function destroy():Void 
	{
		var lWoodParticle: ParticleSystem = GameManager.getAvailableWoodParticle();
		
		if (lWoodParticle != null)
			lWoodParticle.emit(x, y - collider.height / 2);
		
		list.remove(this);
		super.destroy();
	}
}