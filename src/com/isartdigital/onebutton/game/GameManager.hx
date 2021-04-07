package com.isartdigital.onebutton.game;
import animateAtlasPlayer.assets.AssetFactory;
import com.isartdigital.onebutton.game.sprites.Player;
import com.isartdigital.onebutton.ui.UIManager;
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
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;


/**
 * ...
 * @author Chadi Husser
 */
class GameManager 
{
	private static var controller:Controller;
	private static var player:Player;
	private static var gameLayer:GameLayer;
	
	public static function start() : Void {
		
		UIManager.closeScreens();
		
		controller = new Controller(GameStage.getInstance().stage);
		player = new Player(controller);
		
		gameLayer = new GameLayer(-10);
		gameLayer.start();
		
		UIManager.openHud();
		
		Main.getInstance().addEventListener(EventType.GAME_LOOP, gameLoop);
		
		var lJson:Dynamic = Json.parse(GameLoader.getText("assets/settings/player.json"));
		Monitor.setSettings(lJson, player);
		
		var fields : Array<MonitorField> = [{name:"smoothing", onChange:onChange}, {name:"gravity", step:0.01}, {name:"jumpImpulse", step:1}, {name:"x", step:1}, {name:"y", step:100}];
		Monitor.start(player, fields, lJson);
		
		var fields : Array<MonitorField> = [{name:"speed", step:1}, {name:"x", step:1}, {name:"y", step:1}];
		Monitor.start(gameLayer, fields);
		
		var lRect :Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());
		
		GameStage.getInstance().getGameContainer().addChild(gameLayer);
		gameLayer.addChild(player);
		player.start();
		
		var lPos:Point = new Point(lRect.x + lRect.width / 4, lRect.y + lRect.height / 2);
		
		player.x = lPos.x;
		player.y = lPos.y;
		
		resumeGame();
	}
	
	public static function resumeGame() : Void {
		SoundManager.getSound("world1").start();
	}
	
	private static function onChange(pValue:Bool) : Void {
		trace(pValue);
	}
	
	public static function pauseGame() : Void {
		
	}
	
	private static function gameLoop(pEvent:Event) : Void {
		gameLayer.doAction();
		player.doAction();
	}
}