package com.isartdigital.onebutton.game.layers;

import com.isartdigital.onebutton.game.layers.Layer;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.events.Event;

/**
 * ...
 * @author Théo Sabattié
 */
class ParallaxLayer extends Layer 
{
	private static inline var PART_WIDTH: Int = 2000;
	
	private var target:DisplayObject;
	private var offsetCoef:Float;
	
	private var content: MovieClip;
	private var childList: Array<DisplayObject>;
	
	public function new(pOffsetCoef: Float, pTarget: DisplayObject, pID: String, ?pLibrary: String = "assets") 
	{
		super();
		
		content = Assets.getMovieClip(pLibrary + ":" + pID);
		addChild(content);
		
		offsetCoef = pOffsetCoef;
		target = pTarget;
	}
	
	override function onAddedToStage(pEvent:Event):Void 
	{
		super.onAddedToStage(pEvent);
		
		x = screenLimits.left;
		
		childList = new Array<DisplayObject>();
		
		for (i in 0...content.numChildren)
		{
			childList.push(content.getChildAt(i));
		}
		
		childList.sort(sortByXValue);
	}
	
	override function doActionNormal(): Void 
	{
		x = target.x * offsetCoef;
		updateScreenLimits();
		
		if (childList[0].x + PART_WIDTH < screenLimits.left + 1)
		{
			childList[0].x = childList[childList.length - 1].x + PART_WIDTH;
			childList.push(childList.shift());
		}
	}
	
	private function sortByXValue(pObjectA: DisplayObject, pObjectB: DisplayObject): Int
	{
		if (pObjectA.x > pObjectB.x)
			return 1;
		else if (pObjectA.x < pObjectB.x)
			return -1;
		
		return 0;
	}
	
	override public function destroy():Void 
	{
		target = null;
		super.destroy();
	}
}