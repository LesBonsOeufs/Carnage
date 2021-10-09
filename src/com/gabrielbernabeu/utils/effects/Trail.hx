package com.gabrielbernabeu.utils.effects;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class Trail extends Sprite
{
	private var points:Array<Point> = new Array<Point>();
	private var lastX:Float;
	private var lastY:Float;
	private var size:Float;
	private var time:Int = 1;

	/**
	 * Cible du trail
	 */
	private var target:DisplayObject;

	/**
	 * Longueur maximum du trail en pixels
	 */
	public var length:Int = 0;

	/**
	 * distance entre chaque point composant le trail
	 */
	public var distance:Float;

	/**
	 * couleur du trail
	 */
	public var color:Int = 0x0;

	/**
	 * persistence (vitesse de disparition du trail)
	 */
	public var persistence:Float = 1;

	/**
	 * ferme l'arc sur la cible
	 */
	public var closed:Bool = true;

	
	public function new()
	{
		super();
	}

	/**
	 * Initialisation du trail
	 * @param	pTarget définition de la cible
	 * @param	pSize largeur
	 * @param	pDistance distance entre chaque point du trail
	 * @param	pLength longueur maximum en pixels
	 */
	
	public function init(pTarget:DisplayObject, pSize:Float=5, pDistance:Float=10, pLength:Int=0):Void
	{
		target = pTarget;
		size = pSize;
		lastX = target.x;
		lastY = target.y;
		distance = pDistance;
		length = pLength == 0 ? Std.int(distance * 20) : pLength;
	}

	/**
	 * dessine le trail (à executer chaque frame)
	 */
	public function draw():Void
	{

		var lParent:DisplayObjectContainer = target.parent;
		if (lParent == null) return;

		lParent.addChildAt(this, Std.int(Math.max(0,lParent.getChildIndex(target)-1)));

		if (Point.distance(new Point(lastX,lastY),new Point(target.x,target.y))>distance )
		{
			points.push(new Point(target.x, target.y));
			lastX = target.x;
			lastY = target.y;
		}

		graphics.clear();

		if (points.length>0) graphics.moveTo(points[0].x, points[0].y);

		for (i in 1...points.length)
		{
			graphics.lineStyle((i / points.length)*size, color);

			graphics.lineTo(points[i].x, points[i].y);
		}

		if (points.length>0 && closed) graphics.lineTo(target.x, target.y);

		graphics.endFill();

		if (points.length>1 && (points.length * distance > length || time++> Math.ceil(persistence)))
		{
			points.shift();
			var lTime:Int = Math.round(1 / persistence)-1;
			if (persistence < 1 && points.length>5)
			{
				while (points.length > 1 && lTime-->0)
				{
					points.shift();
				}
			}
			time = 1;
		}

	}

	/**
	 * Efface le trail
	 */
	public function clear ():Void
	{
		//points.length = 0;
	}

	public function destroy ():Void
	{
		clear();
		parent.removeChild(this);
	}

}