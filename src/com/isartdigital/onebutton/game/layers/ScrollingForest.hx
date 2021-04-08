package com.isartdigital.onebutton.game.layers;
import com.isartdigital.utils.game.GameStage;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class ScrollingForest 
{
	public static inline var NB_OF_LAYERS: Int = 9;
	public static inline var LAYER_Y_OFFSET: Int = 50;
	private static inline var ID: String = 'ScrollingForest';
	
	private static var layers: Array<ParallaxLayer>;

	private function new() {}
	
	public static function start(pTarget: DisplayObject): Void
	{
		layers = new Array<ParallaxLayer>();
		
		var lCoeff: Float = 1;
		var lGameContainer: Sprite = GameStage.getInstance().getGameContainer();
		
		for (i in 0...NB_OF_LAYERS)
		{
			layers.push(new ParallaxLayer(lCoeff, pTarget, ID + '_' + i));
			lGameContainer.addChild(layers[layers.length - 1]);
			layers[layers.length - 1].start();
			
			lCoeff *= 1.1;
		}
	}
	
	public static function doActions(): Void
	{
		for (layer in layers)
		{
			layer.doAction();
		}
	}
	
	public static function stop(): Void
	{
		for (layer in layers)
		{
			layer.destroy();
		}
		
		layers = null;
	}
	
}