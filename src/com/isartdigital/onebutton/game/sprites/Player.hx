package com.isartdigital.onebutton.game.sprites;

import com.isartdigital.onebutton.game.Controller;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.stateObjects.StateObject;
import com.isartdigital.utils.sound.SoundManager;
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
	
	private inline static var DEGREE_0_MAX_VELOCITY: UInt = 8;
	private inline static var DEGREE_1_MAX_VELOCITY: UInt = 9;
	private inline static var DEGREE_2_MAX_VELOCITY: UInt = 12;
	private inline static var DEGREE_3_MAX_VELOCITY: UInt = 14;
	private inline static var DEGREE_4_MAX_VELOCITY: UInt = 18;
	
	private inline static var INIT_DEGREE: UInt = 1;
	private inline static var DEGREE_0_ANIM_SPEED: Float = 0.08;
	
	private inline static var DEGREE_BAR_MAX_VALUE: Int = 5;
	private var _degreeBar: Int = 0;
	public var degreeBar(get, set): Int;
	
	private inline static var BLOCKING_PENALTY_TIME_TRIGGER: Float = 0.5;
	private var blockingTimeCounter: Float = 0;
	
	private var controller: Controller;
	
	private var _maxVelocity: Float;
	
	private var _degree: Int;
	private var degree(get, set): Int;
	
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
			GameManager.pauseGame();
		}
		
		if (pValue > 4 || pValue < 0) return _degree;
		
		_degree = pValue;
		
		if (degree == 0)
		{
			_maxVelocity = DEGREE_0_MAX_VELOCITY;
			timeBetweenAnimFrame = DEGREE_0_ANIM_SPEED;
			scaleX = 0.9; scaleY = 0.9;
		}
		else
		{
			timeBetweenAnimFrame = TimeFlexibleObject.BASE_TIME_BETWEEN_ANIM_FRAME;
			
			if (_degree == 1)
			{
				_maxVelocity = DEGREE_1_MAX_VELOCITY;
				scaleX = 1; scaleY = 1;
			}
			else if (_degree == 2)
			{
				_maxVelocity = DEGREE_2_MAX_VELOCITY;
				scaleX = 1.1; scaleY = 1.1;
			}
			else if (_degree == 3)
			{
				_maxVelocity = DEGREE_3_MAX_VELOCITY;
				scaleX = 1.2; scaleY = 1.2;
			}
			else if (_degree == 4)
			{
				_maxVelocity = DEGREE_4_MAX_VELOCITY;
				scaleX = 1.4; scaleY = 1.4;
			}
		}
		
		return _degree;
	}
	
	private function get_degreeBar(): Int {
		return _degreeBar;
	}
	
	private function set_degreeBar(pValue: Int): Int
	{
		_degreeBar = pValue;
		
		if (degreeBar >= DEGREE_BAR_MAX_VALUE)
		{
			_degreeBar = 0;
			degree++;
		}
		else if (degreeBar < 0)
		{
			_degreeBar = DEGREE_BAR_MAX_VALUE + pValue;
			degree--;
		}
		
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
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		controller.removeEventListener(Controller.INPUT_DOWN, onInputDown);
		controller.removeEventListener(Controller.INPUT_UP, onInputUp);
		controller = null;
	}

}