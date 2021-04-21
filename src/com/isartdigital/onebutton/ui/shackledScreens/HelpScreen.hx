package com.isartdigital.onebutton.ui.shackledScreens;

import com.isartdigital.onebutton.game.GameManager;
import com.isartdigital.onebutton.ui.ShackledScreen;
import com.isartdigital.utils.sound.SoundManager;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.display.SimpleButton;
import openfl.geom.Point;

	
/**
 * ...
 * @author Gabriel Bernabeu
 */
class HelpScreen extends ShackledScreen 
{
	
	/**
	 * instance unique de la classe HelpScreen
	 */
	private static var instance: HelpScreen;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): HelpScreen {
		if (instance == null) instance = new HelpScreen();
		return instance;
	}
	
	private var btnNext0: SimpleButton;
	private var btnNext1: SimpleButton;
	private var btnBack: SimpleButton;
	
	private var helpPart1Pos: Point;
	private var helpPart2Pos: Point;
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
		var lHelpPart1Indicator: DisplayObject = content.getChildByName("mcHelpPart1");
		var lHelpPart2Indicator: DisplayObject = content.getChildByName("mcHelpPart2");
		helpPart1Pos = new Point(lHelpPart1Indicator.x, lHelpPart1Indicator.y);
		helpPart2Pos = new Point(lHelpPart2Indicator.x, lHelpPart2Indicator.y);
		
		content.removeChild(lHelpPart1Indicator);
		content.removeChild(lHelpPart2Indicator);
		
		btnNext0 = cast(content.getChildByName("btnNext0"), SimpleButton);
		btnNext1 = cast(content.getChildByName("btnNext1"), SimpleButton);
		btnBack = cast(content.getChildByName("btnBack"), SimpleButton);
		
		btnNext0.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnNext0.addEventListener(MouseEvent.CLICK, onNext0);
		btnNext1.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnNext1.addEventListener(MouseEvent.CLICK, onNext1);
		btnBack.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnBack.addEventListener(MouseEvent.CLICK, onBack);
	}
	
	override function animatedInit():Void 
	{	
		var lBottom: DisplayObject = content.getChildByName("mcBottom");
		var lGlobalBottomCoordinates: Point = content.localToGlobal(new Point(lBottom.x, lBottom.y));
		var lLocalTopCoordinates: Point = content.parent.globalToLocal(new Point(lGlobalBottomCoordinates.x, -lGlobalBottomCoordinates.y));
		localTopY = lLocalTopCoordinates.y;
		var lCurrY: Float = content.y;
		
		content.removeChild(lBottom);
		var lMask: DisplayObject = content.getChildByName("mcMask");
		
		Actuate.tween(lMask, ShackledScreen.ANIMATION_DURATION, {alpha: 0}, false).ease(Cubic.easeOut).onComplete(function () {content.removeChild(lMask); });
	}
	
	private function onNext0(pEvent: MouseEvent): Void {		
		Actuate.tween(content, ShackledScreen.DESTROY_DURATION, {y: -helpPart2Pos.y}, false).ease(Back.easeOut);
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onBack(pEvent: MouseEvent): Void {
		Actuate.tween(content, ShackledScreen.DESTROY_DURATION, {y: -helpPart1Pos.y}, false).ease(Back.easeOut);
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onNext1(pEvent: MouseEvent): Void {
		animatedDestroy();
		Actuate.timer(ShackledScreen.DESTROY_DURATION).onComplete(GameManager.resumeGame);
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	override public function destroy():Void 
	{
		btnNext0.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnNext0.removeEventListener(MouseEvent.CLICK, onNext0);
		btnNext1.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnNext1.removeEventListener(MouseEvent.CLICK, onNext1);
		btnBack.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnBack.removeEventListener(MouseEvent.CLICK, onBack);
		
		instance = null;
		super.destroy();
	}

}