package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.effects.Shake;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.stateObjects.StateObject;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.onebutton.ui.Hud;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import motion.Actuate;
import motion.easing.Quad;
import openfl.events.Event;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.renderers.ParticleSystemRenderer;

	
/**
 * ...
 * @author Gabriel Bernabeu
 */
class Player extends MeleeObject 
{
	private inline static var BLOCK: String = "block";
	
	private inline static var DEGREE_0_PARTICLE_DURATION: Float = 0.15;
	
	public inline static var INIT_X_VELOCITY: Int = 8;
	public inline static var INIT_X_OFFSET: Int = 300;
	
	public inline static var MAX_DEGREE: Int = 4;
	
	private static inline var BLOCKING_AXE_X: Float = 95;
	private static inline var BLOCKING_AXE_Y: Float = -225;
	
	private inline static var DEGREE_0_MAX_VELOCITY: Float = 10;
	private inline static var DEGREE_1_MAX_VELOCITY: Float = 11;
	private inline static var DEGREE_2_MAX_VELOCITY: Float = 12;
	private inline static var DEGREE_3_MAX_VELOCITY: Float = 14;
	private inline static var DEGREE_4_MAX_VELOCITY: Float = 18;
	
	public inline static var INIT_DEGREE: UInt = 1;
	public inline static var DEGREE_BAR_MAX_VALUE: Int = 5;
	
	private var maxVelocitiesPerDegree: Array<Float>;
	private var scalesPerDegree: Array<Float>;
	
	private var _degreeBar: Int = 0;
	public var degreeBar(get, set): Int;
	
	private inline static var ATTACK_COOLDOWN: Float = 0.12;
	private var attackTimeCounter: Float = 0;
	
	private static inline var PERFECT_BLOCK_PARTICLE_DURATION: Float = 0.05;
	private inline static var PERFECT_BLOCK_TIME_SLOW: Float = 0.65;
	private inline static var PERFECT_BLOCK_TIME_SLOW_DURATION: Float = 0.3;
	private inline static var PERFECT_BLOCK_WINDOW: Float = 0.08;
	private inline static var PERFECT_BLOCK_SCORE_VALUE: Int = 30;
	private inline static var BLOCKING_PENALTY_TIME_TRIGGER: Float = 0.27;
	private var blockingTimeCounter: Float = 0;
	private var perfectBlock: Bool = true;
	
	private var controller: Controller;
	
	private var _maxVelocity: Float;
	
	private var _degree: Int;
	public var degree(get, set): Int;
	
	override function get_maxVelocity():Float {
		return _maxVelocity;
	}
	
	override function get_accelerationValue():Float {
		return 4 / GameManager.FPS;
	}
	
	override function get_animStrikingFrame():Int {
		return 3;
	}
	
	private var particleRenderer: ParticleSystemRenderer;
	
	private var perfectBlockParticle: ParticleSystem;
	private var degreeUpParticle: ParticleSystem;
	private var degreeDownParticle: ParticleSystem;
	
	private var degreeUpSoundInitVolume: Float;
	private var degreeDownSoundInitVolume: Float;
	
	public function new(pController: Controller) 
	{
		super();
		controller = pController;
		
		maxVelocitiesPerDegree = [DEGREE_0_MAX_VELOCITY, DEGREE_1_MAX_VELOCITY, DEGREE_2_MAX_VELOCITY, DEGREE_3_MAX_VELOCITY, DEGREE_4_MAX_VELOCITY];
		scalesPerDegree = [0.8, 0.9, 1.05, 1.2, 1.4];
		
		xVelocity = INIT_X_VELOCITY;
		degree = INIT_DEGREE;
		
		degreeUpSoundInitVolume = SoundManager.getSound("player_degree_up").volume;
		degreeDownSoundInitVolume = SoundManager.getSound("player_degree_down").volume;
		
		initParticles();
	}
	
	private function initParticles(): Void 
	{
		particleRenderer = DefaultParticleRenderer.createInstance();
		addChild(cast particleRenderer);
		
		degreeUpParticle = ParticleLoader.load("assets/particles/playerDegreeUp.pex");
		degreeDownParticle = ParticleLoader.load("assets/particles/playerDegreeDown.pex");
		perfectBlockParticle = ParticleLoader.load("assets/particles/perfectBlock.pex");
		
		perfectBlockParticle.duration = PERFECT_BLOCK_PARTICLE_DURATION;
		
		particleRenderer.addParticleSystem(degreeUpParticle);
		particleRenderer.addParticleSystem(degreeDownParticle);
		particleRenderer.addParticleSystem(perfectBlockParticle);
	}
	
	override public function start(): Void 
	{
		super.start();
		controller.addEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.addEventListener(Controller.INPUT_UP, onInputUp);
	}
	
	private function onInputDown(pEvent:Event):Void 
	{
		if (state == MeleeObject.BASIC_ATTACK || attackTimeCounter < ATTACK_COOLDOWN ||GameManager.isPaused) return;
		
		attackTimeCounter = 0;
		
		var lCurrentFrame: UInt = renderer.currentFrame;
		
		setState(BLOCK);
		
		renderer.gotoAndStop(lCurrentFrame);
	}
	
	private function onInputUp(pEvent:Event):Void 
	{
		if (state != BLOCK || GameManager.isPaused) return;
		
		setState(MeleeObject.BASIC_ATTACK);
		
		perfectBlock = true;
		blockingTimeCounter = 0;
	}
	
	private function get_degree(): Int {
		return _degree;
	}
	
	private function set_degree(pValue: Int): Int
	{	
		if (pValue > MAX_DEGREE || pValue < 0) return _degree;
		
		_degree = pValue;
		
		_maxVelocity = maxVelocitiesPerDegree[degree];
		scaleX = scalesPerDegree[degree];
		scaleY = scalesPerDegree[degree];
		
		return _degree;
	}
	
	private function get_degreeBar(): Int {
		return _degreeBar;
	}
	
	private function set_degreeBar(pValue: Int): Int
	{
		var lPositiveUpdate: Bool = false;
		
		if (pValue > degreeBar)
			lPositiveUpdate = true;
		
		_degreeBar = pValue;
		
		if (degreeBar >= DEGREE_BAR_MAX_VALUE)
		{
			if (degree < MAX_DEGREE)
			{
				_degreeBar = 0;
				
				degree++;
				getDegreeUpParticle().emit(0, 0);
				
				SoundManager.getSound("player_degree_up").volume = 0.5 * degreeUpSoundInitVolume + (0.5 * degreeUpSoundInitVolume * degree / MAX_DEGREE);
				SoundManager.getSound("player_degree_up").start();
			}
			else
			{
				_degreeBar = DEGREE_BAR_MAX_VALUE;
			}
		}
		else if (degreeBar < 0)
		{
			if (degree > 0)
			{
				_degreeBar = DEGREE_BAR_MAX_VALUE + pValue;
				
				degree--;
				getDegreeDownParticle().emit(0, 0);
				
				SoundManager.getSound("player_degree_down").volume = 0.5 * degreeDownSoundInitVolume + (0.5 * degreeDownSoundInitVolume * degree / MAX_DEGREE);
				SoundManager.getSound("player_degree_down").start();
			}
			else if (!lPositiveUpdate)
			{
				_degreeBar = 0;
				Hud.getInstance().updatePentagram(degreeBar, degree, lPositiveUpdate);
				Hud.getInstance().pentaDeath();
				die();
				
				return degreeBar;
			}
		}
		
		Hud.getInstance().updatePentagram(degreeBar, degree, lPositiveUpdate);
		
		return degreeBar;
	}
	
	private function getDegreeUpParticle(): ParticleSystem {
		updateParticles();
		return degreeUpParticle;
	}
	
	private function getDegreeDownParticle(): ParticleSystem {
		updateParticles();
		return degreeDownParticle;
	}
	
	private function updateParticles(): Void {
		cast(particleRenderer, DisplayObject).parent.addChild(cast particleRenderer);
		degreeUpParticle.duration = DEGREE_0_PARTICLE_DURATION * degree;
		degreeDownParticle.duration = DEGREE_0_PARTICLE_DURATION * degree;
	}
	
	private function isBlocking(): Bool {
		return state == BLOCK;
	}
	
	public function takeDamage(pDamage: Int, pDodgeByAttacking: Bool = false): Bool
	{
		var lAttackDodge: Bool;
		
		if (pDodgeByAttacking)
			lAttackDodge = state == MeleeObject.BASIC_ATTACK;
		else
			lAttackDodge = false;
		
		if (isBlocking() || pDodgeByAttacking)
		{
			var lAnimDuration: Float;
			var lAnimAlpha: Float;
			
			if (perfectBlock)
			{
				lAnimDuration = 0.50;
				lAnimAlpha = 0.4;
				
				var lRandom: Int = Math.floor(Math.random() * 2);
				SoundManager.getSound("player_perfect_block" + lRandom).start();
				Hud.getInstance().flyingScore(this, PERFECT_BLOCK_SCORE_VALUE, true);
				GameManager.timer.timeSlow(PERFECT_BLOCK_TIME_SLOW, PERFECT_BLOCK_TIME_SLOW_DURATION);
				perfectBlockParticle.emit(BLOCKING_AXE_X, BLOCKING_AXE_Y);
			}
			else
			{
				lAnimDuration = 0.20;
				lAnimAlpha = 0.25;
			}
			
			Actuate.transform(this, 0.0001, false).color(0xffffff, lAnimAlpha)
												  .onComplete(function () {Actuate.transform(this, lAnimDuration).color(0xffffff, 0).ease(Quad.easeOut); });
			
			return false;
		}
		
		Shake.operate(GameStage.getInstance(), 5, 10, new Point(GameStage.getInstance().x, GameStage.getInstance().y));
		Actuate.transform(this, 0.0001, false).color(0x8a0303, 0.7)
										      .onComplete(function () {Actuate.transform(this, 0.35).color(0x8a0303, 0).ease(Quad.easeOut); });
		degreeBar -= pDamage;
		return true;
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		setState(MeleeObject.RUN);
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		xAcceleration = accelerationValue;
		
		if (state == MeleeObject.RUN)
		{
			attackTimeCounter += GameManager.timer.deltaTime;
			
			if (controller.maintained)
				onInputDown(null);
		}
		else if (state == MeleeObject.BASIC_ATTACK && renderer.currentFrame == animStrikingFrame && !strikeDone)
		{
			strikeDone = true;
			weaponCollision();
		}
		
		if (state == BLOCK)
		{
			blockingTimeCounter += GameManager.timer.deltaTime;
			
			if (blockingTimeCounter >= PERFECT_BLOCK_WINDOW && perfectBlock)
			{
				perfectBlock = false;
				var lRandom: Int = Math.floor(Math.random() * 2);
				SoundManager.getSound("player_raise_axe" + lRandom).start();
			}
			
			if (blockingTimeCounter >= BLOCKING_PENALTY_TIME_TRIGGER)
			{	
				blockingTimeCounter = 0;
				degreeBar--;
			}
		}
	}
	
	override function weaponCollision():Void
	{
		var lObstacle: Obstacle;
		var lEnemy: Enemy;
		var lMissed: Bool = true;
		var lRandomSoundIndex: Int;
		
		var i: Int;
		
		i = Obstacle.list.length - 1;
		while (i > -1)
		{
			lObstacle = Obstacle.list[i];
			
			if (CollisionManager.hasCollision(lObstacle.hitBox, hurtBox, lObstacle.hitBoxes, hurtBoxes))
			{
				lRandomSoundIndex = Math.floor(Math.random() * 2);
				lMissed = false;
				SoundManager.getSound("player_hit_wood" + lRandomSoundIndex).start();
				lObstacle.smash();
			}
			
			i--;
		}
		
		i = Enemy.list.length - 1;
		while (i > -1)
		{
			lEnemy = Enemy.list[i];
			
			if (CollisionManager.hasCollision(lEnemy.hitBox, hurtBox, lEnemy.hitBoxes, hurtBoxes))
			{
				lRandomSoundIndex = Math.floor(Math.random() * 2);
				lMissed = false;
				SoundManager.getSound("player_hit_armor" + lRandomSoundIndex).start();
				lEnemy.die();
				
				degreeBar++;
			}
			
			i--;
		}
		
		if (lMissed == true)
		{
			lRandomSoundIndex = Math.floor(Math.random() * 2);
			SoundManager.getSound("player_miss" + lRandomSoundIndex).start();
		}
	}
	
	override function timedAnim():Void 
	{
		var lNextCountTime: Float = countTime + TimeFlexibleObject.timer.deltaTime;
		
		if (state == MeleeObject.BASIC_ATTACK)
		{
			if (lNextCountTime >= timeBetweenAnimFrame && isAnimEnded)
			{
				countTime = 0;
				strikeDone = false;
				setState(MeleeObject.RUN);
				return;
			}
		}
		
		super.timedAnim();
	}
	
	override function die(): Void
	{
		GameManager.gameEnd();
		
		controller.removeEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.removeEventListener(Controller.INPUT_UP, onInputUp);
		
		xVelocity = 0;
		
		setState("death_back");
		super.die();
	}
	
	override function deathShake(): Void {
		Shake.operate(GameStage.getInstance(), 20, 10, new Point(GameStage.getInstance().x, GameStage.getInstance().y));
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		controller.removeEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.removeEventListener(Controller.INPUT_UP, onInputUp);
		controller = null;
	}

}