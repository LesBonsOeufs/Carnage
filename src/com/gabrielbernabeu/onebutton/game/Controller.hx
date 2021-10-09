package com.gabrielbernabeu.onebutton.game;
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
	public static inline var INPUT_UP:String = "INPUT_UP";
	
	public var maintained: Bool = false;
	
	private var stage:Stage;
	
	public function new(pStage:Stage) 
	{
		super();
		stage = pStage;
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
	}
	
	private function onTouchBegin(pEvent:TouchEvent): Void 
	{
		invokeInputDownEvent();
	}
	
	private function onTouchEnd(pEvent: TouchEvent): Void
	{
		invokeInputUpEvent();
	}
	
	private function onMouseDown(pEvent:MouseEvent): Void 
	{
		invokeInputDownEvent();
	}
	
	private function onMouseUp(pEvent: MouseEvent): Void
	{
		invokeInputUpEvent();
	}
	
	private function invokeInputDownEvent():Void {
		maintained = true;
		dispatchEvent(new Event(INPUT_DOWN));
	}
	
	private function invokeInputUpEvent():Void {
		maintained = false;
		dispatchEvent(new Event(INPUT_UP));
	}
	
	public function destroy():Void {
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		stage = null;
	}
}