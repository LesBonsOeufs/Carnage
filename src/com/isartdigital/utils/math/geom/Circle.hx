package com.isartdigital.utils.math.geom;

/**
 * ...
 * @author Chadi Husser
 */
class Circle 
{
	public var x:Float;
	public var y:Float;
	public var radius(default, set):Float;
	public var radiusSquared(default, null):Float;
	
	public function new(pX:Float, pY:Float, pRadius:Float) 
	{
		x = pX;
		y = pY;
		radius = pRadius;
	}
	
	private function set_radius (pRadius:Float):Float 
	{ 
		radius = pRadius;
		radiusSquared = radius * radius;
		return radius;
	}
	
}