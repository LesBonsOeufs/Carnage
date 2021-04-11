package com.isartdigital.onebutton.game.sprites;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Swordsman extends MeleeObject 
{
	public static var list(default, null): Array<Swordsman> = new Array<Swordsman>();

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