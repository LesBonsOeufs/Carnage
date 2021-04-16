package com.isartdigital.onebutton.game;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.onebutton.game.layers.scenes.ScrollingForest;
import com.isartdigital.onebutton.game.sprites.Obstacle;
import com.isartdigital.onebutton.game.sprites.Player;
import com.isartdigital.onebutton.game.sprites.Swordsman;
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
import haxe.ds.Vector;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.renderers.ParticleSystemRenderer;


/**
 * ...
 * @author Chadi Husser
 */
class GameManager 
{
	public static inline var FPS: Int = 60;
	
	private static inline var PARTICLE_DURATION: Float = 0.15;
	private static inline var PARTICLES_VECTORS_LENGTH: Int = 5;
	
	/**
	 * A multiplier avec des valeurs pensées par frame pour les utiliser
	 * par seconde
	 */
	public static var timeBasedCoeff(get, never): Float;
	
	private static function get_timeBasedCoeff(): Float {
		return timer.deltaTime * FPS;
	}
	
	public static var timer(default, null): Timer;
	
	private static var particleRenderer: ParticleSystemRenderer;
	private static var bloodParticles: Vector<ParticleSystem>;
	private static var woodParticles: Vector<ParticleSystem>;
	
	private static var controller:Controller;
	public static var player(default, null):Player;
	private static var gameLayer:GameLayer;
	
	public static function start() : Void 
	{
		var lRect: Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());
		
		//Offset initial pour éviter que le scrolling ne laisse du vide au départ.
		var lInitGameLayerX: Float = lRect.left - lRect.width;
		
		var lGameContainer: Sprite = GameStage.getInstance().getGameContainer();
		
		Debug.init();
		UIManager.closeScreens();
		
		timer = new Timer();
		controller = new Controller(GameStage.getInstance().stage);
		player = new Player(controller);
		
		gameLayer = new GameLayer();
		gameLayer.x = lInitGameLayerX;
		gameLayer.start();
		
		initParticles();
		ScrollingForest.init(gameLayer);
		PatternManager.init(gameLayer);
		
		UIManager.openHud();
		
		Main.getInstance().addEventListener(EventType.GAME_LOOP, gameLoop);
		
		var lJson:Dynamic = Json.parse(GameLoader.getText("assets/settings/player.json"));
		Monitor.setSettings(lJson, player);
		
		var fields : Array<MonitorField> = [{name:"smoothing", onChange:onChange}, {name:"x", step:1}, {name:"y", step:100}, {name:"xVelocity", step:1}];
		Monitor.start(player, fields, lJson);
		
		ScrollingForest.addBackgrounds(lGameContainer);
		lGameContainer.addChild(gameLayer);
		ScrollingForest.addForegrounds(lGameContainer);
		gameLayer.addChild(player);
		
		player.start();
		
		player.x = GameStage.getInstance().getLocalSafeZone(gameLayer).x + Player.INIT_X_OFFSET;
		player.y = ScrollingForest.groundY;
		
		resumeGame();
	}
	
	private static function initParticles(): Void
	{
		particleRenderer = DefaultParticleRenderer.createInstance();
		bloodParticles = new Vector<ParticleSystem>(PARTICLES_VECTORS_LENGTH);
		woodParticles = new Vector<ParticleSystem>(PARTICLES_VECTORS_LENGTH);
		gameLayer.addChild(cast particleRenderer);
		
		var lParticle: ParticleSystem;
		
		for (i in 0...PARTICLES_VECTORS_LENGTH)
		{
			lParticle = ParticleLoader.load("assets/particles/bloodParticle.pex");
			particleRenderer.addParticleSystem(lParticle);
			lParticle.duration = PARTICLE_DURATION;
			bloodParticles[i] = lParticle;
			
			lParticle = ParticleLoader.load("assets/particles/woodParticle.pex");
			particleRenderer.addParticleSystem(lParticle);
			lParticle.duration = PARTICLE_DURATION;
			woodParticles[i] = lParticle;
		}
	}
	
	public static function getAvailableBloodParticle(): ParticleSystem
	{
		for (particle in bloodParticles)
		{
			if (particle.active) continue;
			
			cast(particleRenderer, DisplayObject).parent.addChild(cast particleRenderer);
			return particle;
		}
		
		return null;
	}
	
	public static function getAvailableWoodParticle(): ParticleSystem
	{
		for (particle in woodParticles)
		{
			if (particle.active) continue;
			
			cast(particleRenderer, DisplayObject).parent.addChild(cast particleRenderer);
			return particle;
		}
		
		return null;
	}
	
	public static function resumeGame() : Void {
		timer.resume();
		
		if (!SoundManager.getSound("ingame").isPlaying)
			SoundManager.getSound("ingame").fadeIn();
		SoundManager.getSound("ui").stop();
	}
	
	private static function onChange(pValue:Bool) : Void {
		trace(pValue);
	}
	
	public static function pauseGame() : Void {
		timer.stop();
		
		if (!SoundManager.getSound("ui").isPlaying)
			SoundManager.getSound("ui").fadeIn();
		SoundManager.getSound("ingame").stop();
	}
	
	private static function gameLoop(pEvent:Event) : Void {
		timer.update();
		
		gameLayer.doAction();
		ScrollingForest.doAction();
		PatternManager.doAction();
		
		player.doAction();
		Obstacle.doActions();
		Swordsman.doActions();
	}
	
	public static function destroy(): Void
	{
		ScrollingForest.destroy();
		Obstacle.reset();
		player.destroy();
		gameLayer.destroy();
		controller.destroy();
	}
}