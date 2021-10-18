package com.gabrielbernabeu.onebutton.game;

import com.gabrielbernabeu.onebutton.Main;
import com.gabrielbernabeu.onebutton.game.layers.GameLayer;
import com.gabrielbernabeu.onebutton.game.sprites.Arrow;
import com.gabrielbernabeu.onebutton.game.sprites.Chicken;
import com.gabrielbernabeu.onebutton.game.sprites.Enemy;
import com.gabrielbernabeu.onebutton.game.sprites.Obstacle;
import com.gabrielbernabeu.onebutton.game.sprites.Player;
import com.gabrielbernabeu.onebutton.ui.Hud;
import com.gabrielbernabeu.onebutton.ui.UIManager;
import com.gabrielbernabeu.onebutton.ui.shackledScreens.HelpScreen;
import com.gabrielbernabeu.onebutton.ui.shackledScreens.PauseScreen;
import com.gabrielbernabeu.utils.Timer;
import com.gabrielbernabeu.utils.debug.Debug;
import com.gabrielbernabeu.utils.events.EventType;
import com.gabrielbernabeu.utils.game.GameStage;
import com.gabrielbernabeu.onebutton.ui.shackledScreens.EndScreen;
import com.gabrielbernabeu.utils.system.DeviceCapabilities;
import com.gabrielbernabeu.utils.system.MonitorField;
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
import com.gabrielbernabeu.onebutton.game.layers.scenes.ScrollingForest;


/**
 * ...
 * @author Chadi Husser
 */
class GameManager 
{
	public static inline var FPS: Int = 60;
	
	private static inline var PARTICLE_DURATION: Float = 0.15;
	private static inline var PARTICLES_VECTORS_LENGTH: Int = 5;
	
	public static inline var WIN_DELAY_IN_SECONDS: Float = 1.3;
	
	/**
	 * A multiplier avec des valeurs pensées par frame pour les utiliser
	 * par seconde
	 */
	public static var timeBasedCoeff(get, never): Float;
	
	private static function get_timeBasedCoeff(): Float {
		return timer.deltaTime * FPS;
	}
	
	public static var timer(default, null): Timer;
	
	public static var isPaused(default, null): Bool = true;
	
	private static var particleRenderer: ParticleSystemRenderer;
	private static var bloodParticles: Vector<ParticleSystem>;
	private static var woodParticles: Vector<ParticleSystem>;
	
	public static var countWinFrames(default, null): Float = 0;
	
	private static var controller:Controller;
	public static var player(default, null):Player;
	private static var gameLayer:GameLayer;
	
	public static function start(?pStartedFromTitleCard: Bool = false) : Void 
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
		
		ScrollingForest.addBackgrounds(lGameContainer);
		lGameContainer.addChild(gameLayer);
		ScrollingForest.addForegrounds(lGameContainer);
		gameLayer.addChild(player);
		
		player.x = GameStage.getInstance().getLocalSafeZone(gameLayer).x + Player.INIT_X_OFFSET;
		player.y = ScrollingForest.groundY;
		
		player.start();
		
		MusicManager.initInGame();
		
		if (pStartedFromTitleCard)	
			UIManager.addScreen(HelpScreen.getInstance());
		else
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
	
	public static function resumeGame() : Void 
	{
		if (!isPaused) return;
		
		isPaused = false;
		Main.getInstance().addEventListener(Event.DEACTIVATE, onDeactivate);
		UIManager.closeScreens();
		
		timer.resume();
	}
	
	private static function onChange(pValue:Bool) : Void {
		trace(pValue);
	}
	
	public static function pauseScreen(): Void 
	{
		pauseGame();
		UIManager.addScreen(PauseScreen.getInstance());
	}
	
	public static function pauseGame() : Void 
	{	
		if (isPaused) return;
		
		isPaused = true;
		Main.getInstance().removeEventListener(Event.DEACTIVATE, onDeactivate);
		
		timer.stop();
		
		//if (!SoundManager.getSound("ui").isPlaying)
			//SoundManager.getSound("ui").fadeIn();
		//SoundManager.getSound("ingame").stop();
	}
	
	public static function gameEnd(): Void
	{
		Main.getInstance().addEventListener(EventType.GAME_LOOP, winLoop);
	}
	
	private static function gameLoop(pEvent:Event) : Void 
	{
		timer.update();
		
		gameLayer.doAction();
		ScrollingForest.doAction();
		PatternManager.doAction();
		
		player.doAction();
		Obstacle.doActions();
		Enemy.doActions();
		Chicken.doActions();
		Arrow.doActions();
	}
	
	private static function onDeactivate(pEvent: Event): Void {
		pauseScreen();
	}
	
	private static function winLoop(pEvent: Event): Void 
	{
		countWinFrames += timer.deltaTime;
		
		if (countWinFrames >= WIN_DELAY_IN_SECONDS)
		{
			countWinFrames = 0;
			pauseGame();
			//UIManager.closeHud();
			UIManager.addScreen(EndScreen.getInstance());
			Main.getInstance().removeEventListener(EventType.GAME_LOOP, winLoop);
		}
	}
	
	public static function restart(): Void
	{
		destroy();
		start();
	}
	
	public static function destroy(): Void
	{
		Main.getInstance().removeEventListener(EventType.GAME_LOOP, gameLoop);
		
		pauseGame();
		
		ScrollingForest.destroy();
		Obstacle.reset();
		Hud.getInstance().destroy();
		UIManager.closeScreens();
		PatternManager.reset();
		Enemy.reset();
		Arrow.reset();
		Chicken.reset();
		player.destroy();
		gameLayer.destroy();
		controller.destroy();
		
		MusicManager.stop();
	}
}