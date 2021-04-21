package com.isartdigital.onebutton.ui.shackledScreens;

import com.isartdigital.onebutton.game.GameManager;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.Screen;
import motion.Actuate;
import motion.easing.Back;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;

	
/**
 * ...
 * @author Gabriel Bernabeu
 */
class PauseScreen extends ShackledScreen 
{
	
	/**
	 * instance unique de la classe PauseScreen
	 */
	private static var instance: PauseScreen;
	
	private var btnResume: SimpleButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): PauseScreen {
		if (instance == null) instance = new PauseScreen();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(?pLibrary:String="ui") 
	{
		super(pLibrary);
		
		btnResume = cast(content.getChildByName("btnResume"), SimpleButton);
		
		btnResume.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnResume.addEventListener(MouseEvent.CLICK, onResume);
	}
	
	private function onResume(pEvent:MouseEvent) : Void 
	{
		animatedDestroy();
		Actuate.timer(ShackledScreen.DESTROY_DURATION).onComplete(GameManager.resumeGame);
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override function destroy():Void 
	{	
		btnResume.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnResume.removeEventListener(MouseEvent.CLICK, onResume);
		
		instance = null;
		super.destroy();
	}

}