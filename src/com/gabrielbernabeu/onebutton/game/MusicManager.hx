package com.gabrielbernabeu.onebutton.game;
import com.gabrielbernabeu.utils.sound.SoundFX;
import com.gabrielbernabeu.utils.sound.SoundManager;
import openfl.Vector;

/**
 * ...
 * @author Gabriel Bernabeu
 */
typedef Music = {
	var file: SoundFX;
	var initVolume: Float;
}

class MusicManager 
{
	private static inline var VOLUME_FRACTION_IN_BACKGROUND: Float = 1.7;
	private static var ui: Music;
	private static var ingame: Music;

	private function new() {}
	
	public static function init(): Void 
	{
		var lUISoundFx: SoundFX = SoundManager.getSound("ui");
		var lInGameSoundFx: SoundFX = SoundManager.getSound("ingame");
		
		ui = {file: lUISoundFx, initVolume: lUISoundFx.volume};
		ingame = {file: lInGameSoundFx, initVolume: lInGameSoundFx.volume};
	}
	
	public static function initUI(): Void 
	{
		if (!ui.file.isPlaying)
			ui.file.fadeIn();
		if (ingame.file.isPlaying)
			ingame.file.stop();
	}
	
	public static function initInGame(): Void 
	{
		if (!ingame.file.isPlaying)
			ingame.file.fadeIn();
		if (ui.file.isPlaying)
			ui.file.stop();
	}
	
	public static function inGameVolumeToLow(): Void 
	{
		if (ingame.file.volume == ingame.initVolume) 
			ingame.file.volume /= VOLUME_FRACTION_IN_BACKGROUND;
	}
	
	public static function inGameVolumeToNormal(): Void 
	{
		if (ingame.file.volume != ingame.initVolume)
			ingame.file.fadeIn(SoundFX.FADE_SPEED, ingame.initVolume);
	}
	
	public static function stop(): Void 
	{
		if (ingame.file.isPlaying)
			ingame.file.stop();
		if (ui.file.isPlaying)
			ui.file.stop();
	}
}