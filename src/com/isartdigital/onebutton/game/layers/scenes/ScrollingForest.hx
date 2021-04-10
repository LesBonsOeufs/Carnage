package com.isartdigital.onebutton.game.layers.scenes;
import com.isartdigital.onebutton.game.layers.ParallaxLayer;
import com.isartdigital.utils.system.DeviceCapabilities;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class ScrollingForest 
{
	private static inline var NB_OF_FOREGROUNDS: Int = 2;
	public static inline var NB_OF_BACKGROUNDS: Int = 7;
	
	private static inline var ID: String = 'ScrollingForest';
	private static inline var GROUND_ID: String = 'ground';
	
	public static var groundY(default, null): Float;
	
	private static var backgrounds: Array<ParallaxLayer>;
	private static var foregrounds: Array<ParallaxLayer>;

	private function new() {}
	
	public static function init(pTarget: DisplayObject): Void
	{
		foregrounds = new Array<ParallaxLayer>();
		backgrounds = new Array<ParallaxLayer>();
		
		var lCoeffs: Array<Float> = [1.4, 1, 0.8, 0.7, 0.6, 0.5, 0.4, 0.2];
		
		for (i in 0...NB_OF_FOREGROUNDS)
		{
			foregrounds.push(new ParallaxLayer(lCoeffs[i], pTarget, ID + '_' + i));
		}
		
		for (i in NB_OF_FOREGROUNDS...NB_OF_BACKGROUNDS + NB_OF_FOREGROUNDS)
		{
			backgrounds.push(new ParallaxLayer(lCoeffs[i], pTarget, ID + '_' + i));
		}
		
		var lGround: MovieClip = Assets.getMovieClip('assets:' + ID + '_' + GROUND_ID);
		
		groundY = lGround.getChildAt(0).y;
	}
	
	public static function addForegrounds(pContainer: DisplayObjectContainer): Void
	{
		var i: Int = foregrounds.length - 1;
		
		var lForeground: ParallaxLayer;
		
		while (i > -1)
		{
			lForeground = foregrounds[i];
			lForeground.start();
			pContainer.addChild(lForeground);
			i--;
		}
	}
	
	public static function addBackgrounds(pContainer: DisplayObjectContainer): Void
	{
		var i: Int = backgrounds.length - 1;
		
		var lBackground: ParallaxLayer;
		
		while (i > -1)
		{
			lBackground = backgrounds[i];
			lBackground.start();
			pContainer.addChild(lBackground);
			i--;
		}
	}
	
	public static function doAction(): Void
	{
		for (layer in foregrounds)
		{
			layer.doAction();
		}
		
		for (layer in backgrounds)
		{
			layer.doAction();
		}
	}
	
	public static function stop(): Void
	{
		for (layer in foregrounds)
		{
			layer.destroy();
		}
		
		for (layer in backgrounds)
		{
			layer.destroy();
		}
		
		foregrounds = null;
		backgrounds = null;
		groundY = null;
	}
	
}