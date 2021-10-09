package com.gabrielbernabeu.onebutton.ui.shackledScreens;

import com.gabrielbernabeu.onebutton.FontAndLoca;
import com.gabrielbernabeu.onebutton.Session;
import openfl.text.TextField;

	
/**
 * ...
 * @author Gabriel Bernabeu
 */
class EndScreen extends ShackledScreen 
{
	private static var ENGLISH_NEW_HIGHSCORE_MESSAGE: String = "New highscore!";
	private static var FRENCH_NEW_HIGHSCORE_MESSAGE: String = "Nouveau meilleur score!";
	
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
		var lHighscoreField: TextField = cast(content.getChildByName("txtHighscore"), TextField);
		
		if (Session.highscore < Hud.getInstance().score)
		{
			Session.highscore = Hud.getInstance().score;
			
			if (FontAndLoca.currentTranslation == FontAndLoca.ENGLISH)
				lHighscoreField.text = ENGLISH_NEW_HIGHSCORE_MESSAGE;
			else if (FontAndLoca.currentTranslation == FontAndLoca.FRANCAIS)
				lHighscoreField.text = FRENCH_NEW_HIGHSCORE_MESSAGE;
		}
		else lHighscoreField.text += Session.highscore;
		
		Session.save();
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