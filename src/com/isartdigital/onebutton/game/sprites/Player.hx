package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.stateObjects.StateObject;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.onebutton.ui.Hud;
import openfl.events.Event;

	
/**
 * ...
 * @author Gabriel Bernabeu
 */
class Player extends MeleeObject 
{
	private inline static var BLOCK: String = "block";
	
	public inline static var INIT_X_VELOCITY: Int = 8;
	public inline static var INIT_X_OFFSET: Int = 300;
	
	public inline static var MAX_DEGREE: Float = 4;
	
	private inline static var DEGREE_0_MAX_VELOCITY: Float = 8;
	private inline static var DEGREE_1_MAX_VELOCITY: Float = 9;
	private inline static var DEGREE_2_MAX_VELOCITY: Float = 12;
	private inline static var DEGREE_3_MAX_VELOCITY: Float = 14;
	private inline static var DEGREE_4_MAX_VELOCITY: Float = 18;
	
	private inline static var INIT_DEGREE: UInt = 1;
	private inline static var DEGREE_0_ANIM_SPEED: Float = 0.08;
	
	private inline static var DEGREE_MAX_VALUE: Int = 4;
	private inline static var DEGREE_BAR_MAX_VALUE: Int = 5;
	
	private var maxVelocitiesPerDegree: Array<Float>;
	public var scalesPerDegree(default, null): Array<Float>;
	
	private var _degreeBar: Int = 0;
	public var degreeBar(get, set): Int;
	
	private inline static var BLOCKING_PENALTY_TIME_TRIGGER: Float = 0.4;
	private var blockingTimeCounter: Float = 0;
	
	private var controller: Controller;
	
	private var _maxVelocity: Float;
	
	private var _degree: Int;
	public var degree(get, set): Int;
	
	override function get_maxVelocity():Float {
		return _maxVelocity;
	}
	
	//@:getter(accelerationValue)
	override function get_accelerationValue():Float {
		return 4 / GameManager.FPS;
	}
	
	override function get_animStrikingFrame():Int {
		return 3;
	}
	
	public function new(pController: Controller) 
	{
		super();
		controller = pController;
		
		maxVelocitiesPerDegree = [DEGREE_0_MAX_VELOCITY, DEGREE_1_MAX_VELOCITY, DEGREE_2_MAX_VELOCITY, DEGREE_3_MAX_VELOCITY, DEGREE_4_MAX_VELOCITY];
		scalesPerDegree = [0.9, 1, 1.1, 1.2, 1.4];
		
		xVelocity = INIT_X_VELOCITY;
		degree = INIT_DEGREE;
	}
	
	override public function start(): Void 
	{
		super.start();
		controller.addEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.addEventListener(Controller.INPUT_UP, onInputUp);
	}
	
	private function onInputDown(pEvent:Event):Void 
	{
		if (state == MeleeObject.HEAVY_ATTACK) return;
		
		var lCurrentFrame: UInt = renderer.currentFrame;
		
		setState(BLOCK);
		
		renderer.gotoAndStop(lCurrentFrame);
	}
	
	private function onInputUp(pEvent:Event):Void 
	{
		if (state != BLOCK) return;
		
		setState(MeleeObject.HEAVY_ATTACK);
	}
	
	private function get_degree(): Int {
		return _degree;
	}
	
	private function set_degree(pValue: Int): Int
	{
		if (pValue < 0 && _degree == 0)
		{
			die();
		}
		
		if (pValue > DEGREE_MAX_VALUE || pValue < 0) return _degree;
		
		_degree = pValue;
		
		if (degree == 0)
			timeBetweenAnimFrame = DEGREE_0_ANIM_SPEED;
		else
			timeBetweenAnimFrame = TimeFlexibleObject.BASE_TIME_BETWEEN_ANIM_FRAME;
		
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
			if (degree < DEGREE_MAX_VALUE)
			{
				_degreeBar = 0;
				degree++;
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
			}
			else
			{
				_degreeBar = 0;
				die();
			}
		}
		
		Hud.getInstance().updatePentagram(degreeBar, degree, lPositiveUpdate);
		
		return degreeBar;
	}
	
	public function isBlocking(): Bool {
		return state == BLOCK;
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		setState(MeleeObject.RUN);
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
		if (state == MeleeObject.HEAVY_ATTACK && renderer.currentFrame == animStrikingFrame && !strikeDone)
		{
			strikeDone = true;
			weaponCollision();
		}
		
		xAcceleration = accelerationValue;
		
		if (state == BLOCK)
		{
			blockingTimeCounter += GameManager.timer.deltaTime;
			
			if (blockingTimeCounter >= BLOCKING_PENALTY_TIME_TRIGGER)
			{
				blockingTimeCounter = 0;
				degreeBar--;
			}
		}
		else
			blockingTimeCounter = 0;
	}
	
	override function weaponCollision():Void
	{
		var lObstacle: Obstacle;
		var lSwordsman: Swordsman;
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
				lObstacle.destroy();
			}
			
			i--;
		}
		
		i = Swordsman.list.length - 1;
		while (i > -1)
		{
			lSwordsman = Swordsman.list[i];
			
			if (CollisionManager.hasCollision(lSwordsman.hitBox, hurtBox, lSwordsman.hitBoxes, hurtBoxes))
			{
				lRandomSoundIndex = Math.floor(Math.random() * 2);
				lMissed = false;
				SoundManager.getSound("player_hit_armor" + lRandomSoundIndex).start();
				lSwordsman.die();
				
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
		
		if (state == MeleeObject.HEAVY_ATTACK)
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
		controller.removeEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.removeEventListener(Controller.INPUT_UP, onInputUp);
		
		xVelocity = 0;
		
		setState("death_back");
		super.die();
	}
	
	override function doActionDie():Void 
	{
		if (!isAnimEnded)
			super.timedAnim();
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