package com.gabrielbernabeu.utils.game.stateObjects;

import openfl.Assets;
import openfl.display.MovieClip;

/**
 * ...
 * @author Chadi Husser
 */
class StateMovieClip extends StateObject<MovieClip>
{
	/**
	 * Nom du swf utilisé par défault contenant les states associés
	**/
	public static var defaultLibraryName:String = "assets";
	
	/**
	 * Nom du swf contenant les states associés
	**/
	private var libraryName(get, never):String;

	private var loop:Bool;

	public function new()
	{
		super();
	}

	private function get_libraryName():String{
		return defaultLibraryName;
	}
	
	override function getID():String
	{
		return libraryName + ":" + super.getID();
	}

	override function updateRenderer():Void
	{
		removeChild(renderer);
		createRenderer();
		super.updateRenderer();
	}

	override function setBehavior(?pLoop:Bool = false, ?pAutoPlay:Bool = true, ?pStart:UInt = 0):Void
	{
		loop = pLoop;
		renderer.gotoAndStop(pStart);
		if (pAutoPlay) renderer.play();
	}

	override function get_isAnimEnded():Bool
	{
		if (renderer != null && !loop) return renderer.currentFrame == renderer.totalFrames;
		return false;
	}

	override public function pause():Void
	{
		if (renderer != null) renderer.stop();
	}

	override public function resume():Void
	{
		if (renderer != null) renderer.play();
	}

	override function createRenderer():Void
	{
		var lId:String = getID();
		renderer = Assets.getMovieClip(lId);
		super.createRenderer();
	}

	override function destroyRenderer():Void
	{
		renderer.stop();
		super.destroyRenderer();
	}
}