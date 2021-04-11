package com.isartdigital.onebutton.game.sprites;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class MeleeObject extends TimeFlexibleObject 
{
	/**
	 * retourne la zone englobante d'attaque
	 */
	public var hurtBox(default, null): DisplayObject;
	
	/**
	 * retourne un tableau de zones d'attaques de l'objet
	 */
	public var hurtBoxes (default, null): Array<DisplayObject>;
	
	private var animStrikingFrame(get, never): Int;
	
	//à override avec les valeurs correctes dans les classes filles
	private function get_animStrikingFrame(): Int {
		return null;
	}

	public function new(pAssetName:String=null) 
	{
		super(pAssetName);
		
	}
	
	override function initColliderArrays():Void 
	{
		super.initColliderArrays();
		
		hurtBoxes = new Array<DisplayObject>();
		var lHurtBox: DisplayObject;
		
		for (i in 0...collider.numChildren)
		{
			lHurtBox = collider.getChildByName("mcHurtBox" + i);
			if (lHurtBox == null) continue;
			
			hurtBoxes.push(lHurtBox);
		}
		
		hurtBox = collider.getChildByName("mcMainHurtBox");
	}
	
}