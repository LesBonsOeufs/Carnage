package com.isartdigital.onebutton.game.sprites;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class MeleeObject extends TimeFlexibleObject 
{
	/**
	 * retourne un tableau de zones d'attaques de l'objet
	 */
	public var hurtBoxes (default, null): Array<DisplayObject>;

	public function new(pAssetName:String=null) 
	{
		super(pAssetName);
		
	}
	
}