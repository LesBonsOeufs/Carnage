package com.isartdigital.onebutton;

import haxe.Json;
import openfl.Assets;
import openfl.net.SharedObject;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Session 
{
	private static inline var SAFE_PREFIX: String = "CARNAGE_GABRIEL_";
	private static var localStorage(default, null): SharedObject = SharedObject.getLocal("localSave", "assets/settings", true);
	private static var name: String;
	
	private static var file: Dynamic;
	
	public static var highscore(get, set): Int;
	
	private static function get_highscore(): Int {
		return file.highscore;
	}
	
	private static function set_highscore(pValue: Int): Int {
		file.highscore = pValue;
		return file.highscore;
	}
	
	private function new() {}
	
	public static function init(): Void
	{
		name = SAFE_PREFIX + "SAVE";
		ifNewFile();
		
		file = Reflect.field(localStorage.data, name);
		highscore = file.highscore;
		trace(highscore);
	}
	
	public static function save(): Void {
		localStorage.setProperty(name, file);
		localStorage.flush();
	}
	
	private static function ifNewFile(): Void {
		if (Reflect.field(localStorage.data, name) == null) {
			localStorage.setProperty(name, Json.parse(Assets.getText("assets/settings/player.json")));
		}
	}
}