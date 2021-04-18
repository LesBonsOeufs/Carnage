package com.isartdigital.onebutton.ui;

import com.isartdigital.onebutton.game.GameManager;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.geom.Point;
import motion.Actuate;
import motion.easing.Cubic;
import motion.easing.Elastic;
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
	
	private var topLeft: DisplayObjectContainer;
	private var bottomCenter: DisplayObjectContainer;
	
	private var btnPlay: SimpleButton;
	private var btnCredits: SimpleButton;
	private var btnSound: SimpleButton;
	private var btnLanguage: SimpleButton;
	private var btnBack: SimpleButton;
	
	private var btnBackOffset: Point = new Point(400, 300);
	
	private var titleCardPos: Point;
	private var creditsPos: Point;
	
	private function new() 
	{
		super();
		
		if (!SoundManager.getSound("ui").isPlaying)
			SoundManager.getSound("ui").fadeIn();
		
		var lTitleCardIndicator: DisplayObject = content.getChildByName("mcTitleCardIndicator");
		titleCardPos = new Point(lTitleCardIndicator.x, lTitleCardIndicator.y);
		content.removeChild(lTitleCardIndicator);
		
		var lCreditsIndicator: DisplayObject = content.getChildByName("mcCreditsIndicator");
		creditsPos = new Point(lCreditsIndicator.x, lCreditsIndicator.y);
		content.removeChild(lCreditsIndicator);
		
		topLeft = cast(content.getChildByName("mcTopLeft"), DisplayObjectContainer);
		bottomCenter = cast(content.getChildByName("mcBottomCenter"), DisplayObjectContainer);
		
		btnPlay = cast(bottomCenter.getChildByName("btnPlay"), SimpleButton);
		btnCredits = cast(bottomCenter.getChildByName("btnCredits"), SimpleButton);
		btnSound = cast(topLeft.getChildByName("btnSound"), SimpleButton);
		btnLanguage = cast(topLeft.getChildByName("btnLanguage"), SimpleButton);
		btnBack = cast(content.getChildByName("btnBack"), SimpleButton);
		
		updatePositionablesForTitleCard();
		goToTitleCard(true);
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
	
	private function goToTitleCard(pFirst: Bool = false): Void
	{	
		btnBackActivation(false);
		btnPlayActivation(true);
		btnCreditsActivation(true);
		btnSoundActivation(true);
		btnLanguageActivation(true);
		
		if (pFirst)
		{
			btnBack.visible = false;
			return;
		}
		
		positionables = new Array<UIPositionable>();
		
		Actuate.tween(btnBack, 0.6, {x: btnBack.x + btnBackOffset.x + btnBack.width * 1.5}).ease(Cubic.easeOut).onComplete(function(){btnBack.visible = false;});
		Actuate.timer(0.1).onComplete(function() {
			Actuate.tween(content, 2, {x: -titleCardPos.x, y: -titleCardPos.y}).ease(Cubic.easeInOut).onComplete(updatePositionablesForTitleCard, []);
		});
	}
	
	private function updatePositionablesForTitleCard(): Void
	{
		var lPositionnable:UIPositionable = {item:bottomCenter, align:AlignType.BOTTOM};
		positionables.push(lPositionnable);
		lPositionnable = {item:topLeft, align:AlignType.TOP_LEFT};
		positionables.push(lPositionnable);
		onResize();
	}
	
	private function goToCredits(): Void
	{	
		btnPlayActivation(false);
		btnCreditsActivation(false);
		btnSoundActivation(false);
		btnLanguageActivation(false);
		btnBackActivation(true);
		
		btnBack.visible = false;
		positionables = new Array<UIPositionable>();
		
		Actuate.tween(content, 2, {x: -creditsPos.x, y: -creditsPos.y}).ease(Cubic.easeInOut).onComplete(updatePositionablesForCredits, []);
	}
	
	private function updatePositionablesForCredits(): Void
	{
		var lPositionnable:UIPositionable = {item:btnBack, align:AlignType.BOTTOM_RIGHT, offsetX: btnBackOffset.x, offsetY: btnBackOffset.y};
		positionables.push(lPositionnable);
		
		btnBack.visible = false;
		onResize();
		
		Actuate.tween(btnBack, 0.7, {x: btnBack.x + btnBackOffset.x + btnBack.width * 1.5}).ease(Cubic.easeIn).reverse();
		Actuate.timer(0.00001).onComplete(function() {btnBack.visible = true;});
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