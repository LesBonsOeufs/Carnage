package com.isartdigital.onebutton.ui.shackledScreens;

import com.isartdigital.onebutton.ui.Hud;
import com.isartdigital.onebutton.ui.ShackledScreen;
import openfl.text.TextField;

	
/**
 * ...
 * @author Gabriel Bernabeu
 */
class EndScreen extends ShackledScreen 
{
	/**
	 * instance unique de la classe EndScreen
	 */
	private static var instance: EndScreen;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): EndScreen {
		if (instance == null) instance = new EndScreen();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
		cast(content.getChildByName("txtScore"), TextField).text = "Score : " + Hud.getInstance().score;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override function destroy():Void 
	{
		instance = null;
		super.destroy();
	}
}