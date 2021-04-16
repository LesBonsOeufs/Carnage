package com.isartdigital.onebutton.ui;

import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import motion.Actuate;
import motion.easing.Quad;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class AnimatedScreen extends Screen 
{
	public static inline var ANIMATION_DURATION: Float = 1;
	public static inline var SHORTER_ANIMATION_DURATION: Float = ANIMATION_DURATION * 0.8;

	public function new(?pLibrary:String="ui") 
	{
		super(pLibrary);
		
		content.visible = false;
	}
	
	override function init(pEvent:Event):Void 
	{
		super.init(pEvent);
		initAnimation();
	}
	
	private function initAnimation(): Void 
	{
		var lRect: Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());
		
		var lTopLeft: DisplayObject = content.getChildByName("mcTopLeft");
		var lTopRight: DisplayObject = content.getChildByName("mcTopRight");
		var lTopCenter: DisplayObject = content.getChildByName("mcTopCenter");
		var lCenter: DisplayObject = content.getChildByName("mcCenter");
		var lBottomLeft: DisplayObject = content.getChildByName("mcBottomLeft");
		var lBottomRight: DisplayObject = content.getChildByName("mcBottomRight");
		var lBottomCenter: DisplayObject = content.getChildByName("mcBottomCenter");
		
		var lExistingObjects: Array<DisplayObject> = new Array<DisplayObject>();
		
		//var lBg: DisplayObject = content.getChildByName("background");
		
		if (lTopLeft != null)
		{
			lExistingObjects.push(lTopLeft);
			lTopLeft.visible = false;
			
			Actuate.tween(lTopLeft, ANIMATION_DURATION, {x: lTopLeft.x - lTopLeft.width * 2}, false)
				   .ease(Quad.easeIn)
				   .reverse();
		}
		
		if (lTopRight != null)
		{
			lExistingObjects.push(lTopRight);
			lTopRight.visible = false;
			
			Actuate.tween(lTopRight, ANIMATION_DURATION, {x: lTopRight.x + lTopRight.width * 2}, false)
				   .ease(Quad.easeIn)
				   .reverse();
		}
		
		if (lTopCenter != null)
		{
			lExistingObjects.push(lTopCenter);
			lTopCenter.visible = false;
			
			Actuate.tween(lTopCenter, ANIMATION_DURATION, {y: lTopCenter.y - lTopCenter.height * 2}, false)
				   .ease(Quad.easeIn)
				   .reverse();
		}
		
		if (lCenter != null)
		{
			lExistingObjects.push(lCenter);
			lCenter.visible = false;
			
			Actuate.tween(lCenter, SHORTER_ANIMATION_DURATION, {alpha: 0}, false)
				   .ease(Quad.easeIn)
				   .reverse();
		}
		
		if (lBottomLeft != null)
		{
			lExistingObjects.push(lBottomLeft);
			lBottomLeft.visible = false;
			
			Actuate.tween(lBottomLeft, ANIMATION_DURATION, {x: lBottomLeft.x - lBottomLeft.width * 2}, false)
				   .ease(Quad.easeIn)
				   .reverse();
		}
		
		if (lBottomRight != null)
		{
			lExistingObjects.push(lBottomRight);
			lBottomRight.visible = false;
			
			Actuate.tween(lBottomRight, ANIMATION_DURATION, {x: lBottomRight.x + lBottomRight.width * 2}, false)
				   .ease(Quad.easeIn)
				   .reverse();
		}
		
		if (lBottomCenter != null)
		{
			lExistingObjects.push(lBottomCenter);
			lBottomCenter.visible = false;
			
			Actuate.tween(lBottomCenter, ANIMATION_DURATION, {y: lBottomCenter.y + lBottomCenter.height * 2}, false)
				   .ease(Quad.easeIn)
				   .reverse();
		}
		
		//if (lBg != null)
			//Actuate.tween(lBg, ANIMATION_DURATION * 0.8, {alpha: 0}, false)
				   //.ease(Quad.easeIn)
				   //.reverse();
		
		content.visible = true;
		Actuate.timer(0.00001).onComplete(function() {for (object in lExistingObjects) {object.visible = true;}});
	}
	
	private function destroyAnimation(pNextScreen: Screen = null): Void 
	{	
		var lRect: Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());
		
		var lTopLeft: DisplayObject = content.getChildByName("mcTopLeft");
		var lTopRight: DisplayObject = content.getChildByName("mcTopRight");
		var lTopCenter: DisplayObject = content.getChildByName("mcTopCenter");
		var lCenter: DisplayObject = content.getChildByName("mcCenter");
		var lBottomLeft: DisplayObject = content.getChildByName("mcBottomLeft");
		var lBottomRight: DisplayObject = content.getChildByName("mcBottomRight");
		var lBottomCenter: DisplayObject = content.getChildByName("mcBottomCenter");
		
		//var lBg: DisplayObject = content.getChildByName("background");
		
		if (lTopLeft != null)
			Actuate.tween(lTopLeft, ANIMATION_DURATION, {x: lTopLeft.x - lTopLeft.width * 2}, false)
				   .ease(Quad.easeIn);
		
		if (lTopRight != null)
			Actuate.tween(lTopRight, ANIMATION_DURATION, {x: lTopRight.x + lTopRight.width * 2}, false)
				   .ease(Quad.easeIn);
		
		if (lTopCenter != null)
			Actuate.tween(lTopCenter, ANIMATION_DURATION, {y: lTopCenter.y - lTopCenter.height * 2}, false)
				   .ease(Quad.easeIn);
		
		if (lCenter != null)
			Actuate.tween(lCenter, SHORTER_ANIMATION_DURATION, {alpha: 0}, false)
				   .ease(Quad.easeIn);
		
		if (lBottomLeft != null)
			Actuate.tween(lBottomLeft, ANIMATION_DURATION, {x: lBottomLeft.x - lBottomLeft.width * 2}, false)
				   .ease(Quad.easeIn);
		
		if (lBottomRight != null)
			Actuate.tween(lBottomRight, ANIMATION_DURATION, {x: lBottomRight.x + lBottomRight.width * 2}, false)
				   .ease(Quad.easeIn);
		
		if (lBottomCenter != null)
			Actuate.tween(lBottomCenter, ANIMATION_DURATION, {y: lBottomCenter.y + lBottomCenter.height * 2}, false)
				   .ease(Quad.easeIn);
		
		//if (lBg != null)
			//Actuate.tween(lBg, ANIMATION_DURATION, {alpha: 0}, false)
				   //.ease(Quad.easeIn);
		
		if (pNextScreen != null)
			Actuate.timer(ANIMATION_DURATION).onComplete(UIManager.addScreen, [pNextScreen]);
	}
}