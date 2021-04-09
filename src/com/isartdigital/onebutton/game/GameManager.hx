package com.isartdigital.onebutton.game;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.onebutton.game.layers.scenes.ScrollingForest;
import com.isartdigital.onebutton.game.sprites.Player;
import com.isartdigital.onebutton.ui.UIManager;
import com.isartdigital.utils.Timer;
import com.isartdigital.utils.debug.Debug;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.system.Monitor;
import com.isartdigital.utils.system.MonitorField;
import haxe.Json;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;


/**
 * ...
 * @author Chadi Husser
 */
class GameManager 
{
	private static inline var FPS: Int = 60;
	
	public static var timeBasedCoeff(get, never): Float;
	
	private static function get_timeBasedCoeff(): Float
	{
		return timer.deltaTime * FPS;
	}
	
	public static var timer: Timer;
	
	private static var controller:Controller;
	private static var player:Player;
	private static var gameLayer:GameLayer;
	
	public static function start() : Void 
	{
		var lRect: Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());
		
		Debug.init();
		UIManager.closeScreens();
		
		timer = new Timer();
		controller = new Controller(GameStage.getInstance().stage);
		player = new Player(controller);
		
		gameLayer = new GameLayer(-3);
		gameLayer.x = lRect.left;
		gameLayer.start();
		
		ScrollingForest.init(gameLayer);
		
		UIManager.openHud();
		
		Main.getInstance().addEventListener(EventType.GAME_LOOP, gameLoop);
		
		var lJson:Dynamic = Json.parse(GameLoader.getText("assets/settings/player.json"));
		Monitor.setSettings(lJson, player);
		
		var fields : Array<MonitorField> = [{name:"smoothing", onChange:onChange}, {name:"x", step:1}, {name:"y", step:100}];
		Monitor.start(player, fields, lJson);
		
		var fields : Array<MonitorField> = [{name:"speed", step:1}, {name:"x", step:1}, {name:"y", step:1}];
		Monitor.start(gameLayer, fields);
		
		GameStage.getInstance().getGameContainer().addChild(gameLayer);
		ScrollingForest.addBackgrounds(gameLayer);
		gameLayer.addChild(player);
		ScrollingForest.addForegrounds(gameLayer);
		
		player.start();
		
		player.x = GameStage.getInstance().getLocalSafeZone(gameLayer).x + Player.INIT_X_OFFSET;
		player.y = ScrollingForest.groundY;
		
		resumeGame();
	}
	
	public static function resumeGame() : Void {
		timer.resume();
		
		if (!SoundManager.getSound("ingame").isPlaying)
			SoundManager.getSound("ingame").loop();
		SoundManager.getSound("ui").stop();
	}
	
	private static function onChange(pValue:Bool) : Void {
		trace(pValue);
	}
	
	public static function pauseGame() : Void {
		timer.stop();
		
		if (!SoundManager.getSound("ui").isPlaying)
			SoundManager.getSound("ui").loop();
		SoundManager.getSound("ingame").stop();
	}
	
	private static function gameLoop(pEvent:Event) : Void {
		timer.update();
		
		gameLayer.doAction();
		ScrollingForest.doActions();
		
		player.doAction();
	}
}