package com.isartdigital.onebutton.game.sprites;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Enemy extends MeleeObject 
{
	public static var list(default, null): Array<Enemy> = new Array<Enemy>();
	
	private var target: Player;

	public function new(?pTarget: Player = null) 
	{
		super();
		
		list.push(this);
		scaleX = -1;
		
		if (pTarget == null)
			target = GameManager.player;
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
	
	override public function destroy():Void 
	{
		list.remove(this);
		super.destroy();
	}
	
	public static function reset(): Void 
	{
		var i: Int = list.length - 1;
		
		while (i > -1)
		{
			list[i].destroy();
			i--;
		}
	}
}