package com.isartdigital.onebutton;

import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.onebutton.ui.GraphicLoader;
import com.isartdigital.onebutton.ui.TitleCard;
import com.isartdigital.onebutton.ui.UIManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.debug.Debug;
import com.isartdigital.utils.events.AssetsLoaderEvent;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.GameStageScale;
import com.isartdigital.utils.game.StateManager;
import com.isartdigital.utils.game.stateObjects.StateObject;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Json;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;

class Main extends Sprite
{
	
	private static var instance:Main;
	
	public static function getInstance():Main {
		return instance;
	}

	public function new ()
	{
		instance = this;
		
		super ();
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		
        StateObject.defaultColliderType = ColliderType.SIMPLE;
        
		//SETUP de la config
		Config.init(Json.parse(Assets.getText("assets/config.json")));

		//SETUP du gamestage
		GameStage.getInstance().scaleMode = GameStageScale.SHOW_ALL;
		GameStage.getInstance().init(null, 2160, 1440);
		
		DeviceCapabilities.init();
		
		stage.addChild(GameStage.getInstance());
		stage.addEventListener(Event.RESIZE, resize);
		resize();
		
		//SETUP du debug
		Debug.init();

		UIManager.addScreen(GraphicLoader.getInstance());

		//CHARGEMENT
		var lGameLoader:GameLoader = new GameLoader();
		lGameLoader.addEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
		lGameLoader.addEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);
		
		//Chargement des sons
		var soundPaths : Array<String> = SoundManager.setupSoundsData(Json.parse(Assets.getText("assets/sounds/sounds.json")));
        
		for (soundPath in soundPaths) {
			lGameLoader.addSound(soundPath);
		}
		
		//Chargement des settings
		lGameLoader.addText("assets/settings/player.json");
		lGameLoader.addText("assets/localization.json");
		
        //Chargement des particules
        lGameLoader.addText("assets/particles/bloodParticle.pex");
        lGameLoader.addBitmapData("assets/particles/texture.png");
		
		//Chargement des swf
		lGameLoader.addLibrary("assets");
		
		//Chargement de l'ui
		lGameLoader.addLibrary("ui");
		
		//Chargement des fonts
		lGameLoader.addFont("assets/fonts/alagard_by_pix3m.ttf");
		
		//Chargement des colliders
		lGameLoader.addText("assets/colliders.json");
		
		//Chargement des patterns
		lGameLoader.addText("assets/levels/leveldesign.json");
		
		lGameLoader.load();
	}

	private function onLoadProgress (pEvent:AssetsLoaderEvent): Void
	{
		GraphicLoader.getInstance().setProgress(pEvent.filesLoaded / pEvent.nbFiles);	
	}

	private function onLoadComplete (pEvent:AssetsLoaderEvent): Void
	{
		trace("LOAD COMPLETE");
		
		var lGameLoader : GameLoader = cast(pEvent.target, GameLoader);
		lGameLoader.removeEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
		lGameLoader.removeEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);		
		
		SoundManager.initSounds();
		FontAndLoca.initTranslationFile();
	
		//Ajout des colliders des stateObjects
		StateManager.addColliders(Json.parse(GameLoader.getText("assets/colliders.json")));
		
		UIManager.addScreen(TitleCard.getInstance());
		
		addEventListener(Event.ENTER_FRAME, gameLoop);
	}

	private static function importClasses() : Void {

	}
	
	private function gameLoop(pEvent:Event) : Void {
		dispatchEvent(new Event(EventType.GAME_LOOP));
	}
	
	public function resize (pEvent:Event = null): Void
	{
		GameStage.getInstance().resize();
	}

}