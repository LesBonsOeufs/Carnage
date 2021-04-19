package com.isartdigital.onebutton.ui;

import com.isartdigital.utils.ui.Screen;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Quad;
import openfl.display.DisplayObject;
import openfl.events.Event;
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

	private function new(?pLibrary:String="ui") 
	{
		super(pLibrary);
		
	}
	
	override function init(pEvent:Event):Void 
	{
		super.init(pEvent);
		
		var lBottom: DisplayObject = content.getChildByName("mcBottom");
		var lGlobalBottomCoordinates: Point = content.localToGlobal(new Point(lBottom.x, lBottom.y));
		var lLocalTopCoordinates: Point = content.parent.globalToLocal(new Point(lGlobalBottomCoordinates.x, -lGlobalBottomCoordinates.y));
		localTopY = lLocalTopCoordinates.y;
		
		Actuate.tween(content, ANIMATION_DURATION, {y:  localTopY}).reverse().ease(Back.easeIn);
		
		content.removeChild(lBottom);
	}
	
	private function animatedDestroy(): Void
	{
		Actuate.tween(content, DESTROY_DURATION, {y: localTopY}).ease(Quad.easeIn).onComplete(destroy);
	}
	
}