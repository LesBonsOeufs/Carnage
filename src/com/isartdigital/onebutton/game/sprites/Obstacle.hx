package com.isartdigital.onebutton.game.sprites;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;

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
		for (element in list)
		{
			element.doAction();
		}
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		var lPlayer: Player = GameManager.player;
		
		if (CollisionManager.hasCollision(hitBox, lPlayer.hitBox, hitBoxes, lPlayer.getGlobalHitPoints()))
			trace("ok");
		
		if (x + width / 2 < cast(parent, GameLayer).screenLimits.left)
			destroy();
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