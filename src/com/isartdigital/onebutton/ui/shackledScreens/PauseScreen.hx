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
	private var btnRetry: SimpleButton;
	private var btnQuit: SimpleButton;
	
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
		
		//SoundManager.mainVolume /= 2;
		
		btnResume = cast(content.getChildByName("btnResume"), SimpleButton);
		btnRetry = cast(content.getChildByName("btnRetry"), SimpleButton);
		btnQuit = cast(content.getChildByName("btnQuit"), SimpleButton);
		
		btnResume.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnResume.addEventListener(MouseEvent.CLICK, onResume);
		
		btnRetry.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnRetry.addEventListener(MouseEvent.CLICK, onRetry);
		
		btnQuit.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnQuit.addEventListener(MouseEvent.CLICK, onQuit);
	}
	
	private function onDown(pEvent:MouseEvent) : Void {
		SoundManager.getSound("press").start();
	}
	
	private function onResume(pEvent:MouseEvent) : Void 
	{
		animatedDestroy();
		Actuate.timer(ShackledScreen.DESTROY_DURATION).onComplete(GameManager.resumeGame);
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onRetry(pEvent:MouseEvent) : Void 
	{
		GameManager.restart();
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onQuit(pEvent:MouseEvent) : Void 
	{
		GameManager.destroy();
		UIManager.addScreen(Menu.getInstance());
		
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
		btnRetry.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnRetry.removeEventListener(MouseEvent.CLICK, onRetry);
		btnQuit.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnQuit.removeEventListener(MouseEvent.CLICK, onQuit);
		
		instance = null;
		//SoundManager.mainVolume = SoundManager.initMainVolume;
		
		super.destroy();
	}

}