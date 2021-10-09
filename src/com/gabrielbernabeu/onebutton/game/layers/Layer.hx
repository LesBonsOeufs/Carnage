package com.gabrielbernabeu.onebutton.game.layers;

import com.gabrielbernabeu.utils.game.StateMachine;
import openfl.Lib;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.Stage;

/**
 * ...
 * @author Théo Sabattié
 */
class Layer extends StateMachine 
{
	public var screenLimits(default, null):Rectangle = new Rectangle();
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(pEvent:Event):Void 
	{
		updateScreenLimits();
	}
	
	private function updateScreenLimits():Void {
		var lStage:Stage = Lib.current.stage;
		var lTopLeft:Point = globalToLocal(new Point(0, 0));
		var lBottomRight:Point = globalToLocal(new Point(lStage.stageWidth, lStage.stageHeight));
		screenLimits.setTo(lTopLeft.x, lTopLeft.y, lBottomRight.x - lTopLeft.x, lBottomRight.y - lTopLeft.y);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
}