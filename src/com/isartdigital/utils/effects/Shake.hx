package com.isartdigital.utils.effects;

import openfl.geom.Point;
import motion.Actuate;
import openfl.utils.Object;
/**
 * ...
 * @author Gabriel Bernabeu
 */
class Shake 
{	
	private function new() {}
	
	/**
	 *Si pFinalPos n'est pas rempli, ses coordonnées seront (0, 0).
	 * @param	pObjet
	 * @param	pPosOffset
	 * @param	pDuration
	 * @param	pFinalX
	 * @param	pFinalY
	 */
	public static function operate (pObject: Object, pPosOffset: Float, pDuration: Int = 10, pFinalPos: Point = null): Void
	{
		if (pFinalPos == null) pFinalPos = new Point();
		
		var i: Int = pDuration;
		
		while (i > -1)
		{
			Actuate.tween(pObject, 0.025, {x: pFinalPos.x + ( - pPosOffset + Math.floor(Math.random() * (pPosOffset * 2 + 1))) * i / pDuration,
										   y: pFinalPos.y + ( - pPosOffset + Math.floor(Math.random() * (pPosOffset * 2 + 1))) * i / pDuration}, false);
			
			i--;
		}
	}
	
}