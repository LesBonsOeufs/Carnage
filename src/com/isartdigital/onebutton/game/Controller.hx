package com.isartdigital.onebutton.game;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;

/**
 * ...
 * @author Théo Sabattié
 */
class Controller extends EventDispatcher
{
	public static inline var INPUT_DOWN:String = "INPUT_DOWN";
	
	private var stage:Stage;
	
	public function new(pStage:Stage) 
	{
		super();
		stage = pStage;
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
	}
	
	private function onTouchBegin(pEvent:TouchEvent):Void 
	{
		invokeInputDownEvent();
	}
	
	private function onMouseDown(pEvent:MouseEvent):Void 
	{
		invokeInputDownEvent();
	}
	
	private function invokeInputDownEvent():Void {
		dispatchEvent(new Event(INPUT_DOWN));
	}
	
	public function destroy():Void {
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		stage = null;
	}
}