package com.isartdigital.onebutton.ui;

import com.isartdigital.onebutton.game.GameManager;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import js.html.svg.Point;
import motion.Actuate;
import motion.easing.Cubic;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.SimpleButton;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Chadi Husser
 */
class Menu extends AnimatedScreen 
{
	private static var instance : Menu;
	
	private var btnPlay: SimpleButton;
	private var btnCredits: SimpleButton;
	private var btnSound: SimpleButton;
	private var btnLanguage: SimpleButton;
	private var btnBack: SimpleButton;
	
	private var titleCardIndicator: DisplayObject;
	private var creditsIndicator: DisplayObject;
	
	private function new() 
	{
		super();
		
		var lBottomCenter: DisplayObject = content.getChildByName("mcBottomCenter");
		var lTopLeft: DisplayObject = content.getChildByName("mcTopLeft");
		
		var lPositionnable:UIPositionable = {item:lBottomCenter, align:AlignType.BOTTOM};
		positionables.push(lPositionnable);
		lPositionnable = {item:lTopLeft, align:AlignType.TOP_LEFT};
		positionables.push(lPositionnable);
		
		if (!SoundManager.getSound("ui").isPlaying)
			SoundManager.getSound("ui").fadeIn();
		
		titleCardIndicator = content.getChildByName("mcTitleCardIndicator");
		titleCardIndicator.alpha = 0;
		
		creditsIndicator = content.getChildByName("mcCreditsIndicator");
		creditsIndicator.alpha = 0;
		
		btnPlay = cast(cast(lBottomCenter, DisplayObjectContainer).getChildByName("btnPlay"), SimpleButton);
		btnCredits = cast(cast(lBottomCenter, DisplayObjectContainer).getChildByName("btnCredits"), SimpleButton);
		btnSound = cast(cast(lTopLeft, DisplayObjectContainer).getChildByName("btnSound"), SimpleButton);
		btnLanguage = cast(cast(lTopLeft, DisplayObjectContainer).getChildByName("btnLanguage"), SimpleButton);
		btnBack = cast(content.getChildByName("btnBack"), SimpleButton);
		
		goToTitleCard();
	}
	
	public static function getInstance() : Menu {
		if (instance == null) instance = new Menu();
		return instance;
	}
	
	private function btnPlayActivation(pActivate: Bool): Void
	{
		if (pActivate)
		{
			btnPlay.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnPlay.addEventListener(MouseEvent.CLICK, onPlay);
		}
		else
		{
			btnPlay.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnPlay.removeEventListener(MouseEvent.CLICK, onPlay);
		}
	}
	
	private function btnCreditsActivation(pActivate: Bool): Void
	{
		if (pActivate)
		{
			btnCredits.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnCredits.addEventListener(MouseEvent.CLICK, onCredits);
		}
		else
		{
			btnCredits.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnCredits.removeEventListener(MouseEvent.CLICK, onCredits);
		}
	}
	
	private function btnSoundActivation(pActivate: Bool): Void
	{
		if (pActivate)
		{
			btnSound.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnSound.addEventListener(MouseEvent.CLICK, onSound);
		}
		else
		{
			btnSound.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnSound.removeEventListener(MouseEvent.CLICK, onSound);
		}
	}
	
	private function btnLanguageActivation(pActivate: Bool): Void
	{
		if (pActivate)
		{
			btnLanguage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnLanguage.addEventListener(MouseEvent.CLICK, onLanguage);
		}
		else
		{
			btnLanguage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnLanguage.removeEventListener(MouseEvent.CLICK, onLanguage);
		}
	}
	
	private function btnBackActivation(pActivate: Bool): Void
	{
		if (pActivate)
		{
			btnBack.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnBack.addEventListener(MouseEvent.CLICK, onBack);
		}
		else
		{
			btnBack.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btnBack.removeEventListener(MouseEvent.CLICK, onBack);
		}
	}
	
	public function goToTitleCard(): Void
	{
		btnBackActivation(false);
		btnPlayActivation(true);
		btnCreditsActivation(true);
		btnSoundActivation(true);
		btnLanguageActivation(true);
		
		Actuate.tween(content, 2, {x: -titleCardIndicator.x, y: -titleCardIndicator.y}).ease(Cubic.easeInOut);
	}
	
	public function goToCredits(): Void
	{
		btnPlayActivation(false);
		btnCreditsActivation(false);
		btnSoundActivation(false);
		btnLanguageActivation(false);
		btnBackActivation(true);
		
		Actuate.tween(content, 2, {x: -creditsIndicator.x, y: -creditsIndicator.y}).ease(Cubic.easeInOut);
	}
	
	private function onDown(pEvent:MouseEvent) : Void {
		SoundManager.getSound("press").start();
	}
	
	private function onPlay(pEvent:MouseEvent) : Void {
		GameManager.start();
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onCredits(pEvent:MouseEvent) : Void {
		goToCredits();
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onBack(pEvent:MouseEvent) : Void {
		goToTitleCard();
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onLanguage(pEvent:MouseEvent) : Void 
	{
		FontAndLoca.switchLanguage();
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
		
		btnPlayActivation(false);
		btnCreditsActivation(false);
		btnSoundActivation(false);
		btnLanguageActivation(false);
		btnBackActivation(false);
		
		destroyAnimation();
		Actuate.timer(AnimatedScreen.ANIMATION_DURATION).onComplete(UIManager.reloadScreen, [getInstance]);
	}
	
	private function onSound(pEvent: MouseEvent): Void 
	{
		SoundManager.mute = !SoundManager.mute;
		
		SoundManager.stopSounds();
		
		if (!SoundManager.mute)
			SoundManager.getSound("ui").loop();
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	override public function destroy():Void 
	{
		btnPlayActivation(false);
		btnCreditsActivation(false);
		btnSoundActivation(false);
		btnLanguageActivation(false);
		btnBackActivation(false);
		
		instance = null;
		super.destroy();
	}
}