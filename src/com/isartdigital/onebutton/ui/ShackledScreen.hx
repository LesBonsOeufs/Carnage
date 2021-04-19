package com.isartdigital.onebutton.ui;

import com.isartdigital.onebutton.game.GameManager;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.Screen;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Quad;
import openfl.display.DisplayObject;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class ShackledScreen extends Screen 
{
	private static var ANIMATION_DURATION: Float = 0.7;
	private static var DESTROY_DURATION: Float = ANIMATION_DURATION / 1.5;
	
	private var localTopY: Float;
	
	private var btnRetry: SimpleButton;
	private var btnQuit: SimpleButton;

	private function new(?pLibrary:String="ui") 
	{
		super(pLibrary);
		
		SoundManager.mainVolume /= 1.5;
		
		btnRetry = cast(content.getChildByName("btnRetry"), SimpleButton);
		btnQuit = cast(content.getChildByName("btnQuit"), SimpleButton);
		
		btnRetry.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnRetry.addEventListener(MouseEvent.CLICK, onRetry);
		
		btnQuit.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnQuit.addEventListener(MouseEvent.CLICK, onQuit);
	}
	
	override function init(pEvent:Event):Void 
	{
		super.init(pEvent);
		
		var lBottom: DisplayObject = content.getChildByName("mcBottom");
		var lGlobalBottomCoordinates: Point = content.localToGlobal(new Point(lBottom.x, lBottom.y));
		var lLocalTopCoordinates: Point = content.parent.globalToLocal(new Point(lGlobalBottomCoordinates.x, -lGlobalBottomCoordinates.y));
		localTopY = lLocalTopCoordinates.y;
		
		var lCurrY: Float = content.y;
		content.y = localTopY;
		
		Actuate.tween(content, ANIMATION_DURATION, {y:  lCurrY}).ease(Back.easeOut);
		//Actuate.tween(content, ANIMATION_DURATION, {y:  localTopY}).reverse().ease(Back.easeIn);
		
		content.removeChild(lBottom);
	}
	
	private function onDown(pEvent:MouseEvent) : Void {
		SoundManager.getSound("press").start();
	}
	
	private function onRetry(pEvent: MouseEvent) : Void 
	{
		GameManager.restart();
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function onQuit(pEvent: MouseEvent) : Void 
	{
		GameManager.destroy();
		UIManager.addScreen(Menu.getInstance());
		
		SoundManager.getSound("press").stop();
		SoundManager.getSound("click").start();
	}
	
	private function animatedDestroy(): Void
	{
		Actuate.tween(content, DESTROY_DURATION, {y: localTopY}).ease(Quad.easeIn).onComplete(destroy);
	}
	
	override public function destroy():Void 
	{
		SoundManager.mainVolume = SoundManager.initMainVolume;
		
		btnRetry.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnRetry.removeEventListener(MouseEvent.CLICK, onRetry);
		btnQuit.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		btnQuit.removeEventListener(MouseEvent.CLICK, onQuit);
		
		super.destroy();
	}
}