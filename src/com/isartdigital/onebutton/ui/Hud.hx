package com.isartdigital.onebutton.ui;

import com.isartdigital.onebutton.game.GameManager;
import com.isartdigital.onebutton.game.sprites.Player;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.game.stateObjects.StateObject;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import lime.text.UTF8String;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Quad;
import motion.easing.Sine;
import openfl.Vector;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.renderers.ParticleSystemRenderer;

/**
 * ...
 * @author Chadi Husser
 */
class Hud extends Screen 
{
	private inline static var FLYING_SCORE_INIT_Y_OFFSET: Float = 20;
	private inline static var FLYING_SCORE_INIT_SIZE_COEFF: Float = 2;
	private inline static var FLYING_SCORE_SIZE: Float = 5;
	private inline static var FLYING_SCORE_INIT_COLOR = 0xFF0000;
	private inline static var FLYING_SCORE_END_COLOR: Int = 0x8F0000;
	private inline static var FLYING_SCORE_ANIM_DURATION: Float = 1.2;
	
	private static inline var UPDATE_PARTICLE_DURATION: Float = 0.1;
	
	private static inline var SCORE_ANIM_SCALE: Float = 1.5;
	
	private static var instance : Hud;
	
	private var pentagram: DisplayObjectContainer;
	private var pentaText: TextField;
	
	private var btnPause: SimpleButton;
	
	public var scoreContainer: DisplayObjectContainer;
	private var txtScore: TextField;
	public var score(get, set): Int;
	private var _score: Int = 0;
	
	private var pentaPositiveUpdateParticles: Vector<ParticleSystem>;
	private var pentaNegativeUpdateParticles: Vector<ParticleSystem>;
	private var pentaSignParticles: Vector<ParticleSystem>;
	private var pentaSummits: Vector<DisplayObject>;
	
	private var pentaScalesPerDegree(default, null): Array<Float> = [0.8, 1, 1.3, 1.7, 2];
	
	private function get_score(): Int {
		return _score;
	}
	
	private function set_score(pValue: Int): Int 
	{
		_score = pValue;
		txtScore.text = '$_score';
		//Actuate.tween(this, 0.5, {_score: pValue}, false).ease(Cubic.easeIn).onUpdate(function () {txtScore.text = '$_score'; }).snapping();
		
		scoreContainer.scaleX = SCORE_ANIM_SCALE;
		scoreContainer.scaleY = SCORE_ANIM_SCALE;
		Actuate.tween(scoreContainer, 0.5, {scaleX: 1, scaleY: 1});
		
		return _score;
	}
	
	public static function getInstance() : Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}
	
	public function new() 
	{
		super();
		
		var lTopCenter: DisplayObjectContainer = cast(content.getChildByName("mcTopCenter"), DisplayObjectContainer);
		var lTopRight: DisplayObjectContainer = cast(content.getChildByName("mcTopRight"), DisplayObjectContainer);
		var lBottomCenter: DisplayObjectContainer = cast(content.getChildByName("mcBottomCenter"), DisplayObjectContainer);
		
		var lPositionnable:UIPositionable;
		lPositionnable = { item:lTopCenter, align:AlignType.TOP};
		positionables.push(lPositionnable);
		//lPositionnable = { item:content.getChildByName("mcTopLeft"), align:AlignType.TOP_LEFT};
		//positionables.push(lPositionnable);
		lPositionnable = { item:lTopRight, align:AlignType.TOP_RIGHT};
		positionables.push(lPositionnable);
		lPositionnable = { item:lBottomCenter, align:AlignType.BOTTOM};
		positionables.push(lPositionnable);
		
		btnPause = cast(lTopRight.getChildByName("btnPause"), SimpleButton);
		btnPause.addEventListener(MouseEvent.CLICK, onPause);
		
		pentagram = cast(lTopCenter.getChildByName("mcPentagram"), DisplayObjectContainer);
		pentagram.scaleX = pentaScalesPerDegree[Player.INIT_DEGREE];
		pentagram.scaleY = pentaScalesPerDegree[Player.INIT_DEGREE];
		
		pentaText = cast(pentagram.getChildByName("txtText"), TextField);
		pentaText.text = toRomanNumerals(Player.INIT_DEGREE + 1);
		
		scoreContainer = cast(lBottomCenter.getChildByName("mcTextContainer"), DisplayObjectContainer);
		txtScore = cast(scoreContainer.getChildByName("txtScore"), TextField);
		
		txtScore.text = '$_score';
	}
	
	override function init(pEvent:Event):Void 
	{
		super.init(pEvent);
		
		var lParticleRenderer: ParticleSystemRenderer = DefaultParticleRenderer.createInstance();
		pentagram.addChild(cast lParticleRenderer);
		
		pentaPositiveUpdateParticles = new Vector(3);
		pentaNegativeUpdateParticles = new Vector(3);
		pentaSignParticles = new Vector(5);
		pentaSummits = new Vector(5);
		
		var lSignParticle: ParticleSystem;
		var lPositiveUpdateParticle: ParticleSystem;
		var lNegativeUpdateParticle: ParticleSystem;
		
		for (i in 0...pentaSignParticles.length)
		{
			lSignParticle = ParticleLoader.load("assets/particles/pentaSignParticle.pex");
			lParticleRenderer.addParticleSystem(lSignParticle);
			pentaSignParticles[i] = lSignParticle;
			
			pentaSummits[i] = pentagram.getChildByName("mcTop" + i);
			pentaSummits[i].visible = false;
			
			lPositiveUpdateParticle = ParticleLoader.load("assets/particles/pentaPositiveUpdateParticle.pex");
			lPositiveUpdateParticle.duration = UPDATE_PARTICLE_DURATION;
			lParticleRenderer.addParticleSystem(lPositiveUpdateParticle);
			pentaPositiveUpdateParticles[i] = lPositiveUpdateParticle;
			
			lNegativeUpdateParticle = ParticleLoader.load("assets/particles/pentaNegativeUpdateParticle.pex");
			lNegativeUpdateParticle.duration = UPDATE_PARTICLE_DURATION;
			lParticleRenderer.addParticleSystem(lNegativeUpdateParticle);
			pentaNegativeUpdateParticles[i] = lNegativeUpdateParticle;
		}
	}
	
	private function onPause(pEvent:MouseEvent) : Void 
	{
		if (GameManager.isPaused || GameManager.countWinFrames != 0) return;
		
		GameManager.pauseScreen();
		SoundManager.getSound("click").start();
	}
	
	public function updatePentagram(pDegreeBar: Int, pDegree: Int, pPositiveUpdate: Bool): Void
	{
		var lTweenCoeff: Float;
		
		if (pPositiveUpdate)
		{
			lTweenCoeff = 1.15;
			getAvailablePositiveUpdateParticle().emit(0, 0);
		}
		else
		{
			lTweenCoeff = 0.85;
			getAvailableNegativeUpdateParticle().emit(0, 0);
		}
		
		var lTop: DisplayObject;
		
		for (i in 0...pentaSignParticles.length)
		{
			if (i > pDegreeBar - 1) {
				for (j in i...pentaSignParticles.length) {
					pentaSignParticles[j].stop();
				}
				
				break;
			}
			
			lTop = pentaSummits[i];
			pentaSignParticles[i].emit(lTop.x, lTop.y);
		}
		
		var lScale: Float = pentaScalesPerDegree[pDegree];

		if (pentagram.scaleX != lScale)
			Actuate.tween(pentagram, 0.4, {scaleX: lScale, scaleY: lScale}).ease(Back.easeOut);
		else
			Actuate.tween(pentagram, 0.3, {scaleX: lScale * lTweenCoeff, scaleY: lScale * lTweenCoeff}).reverse().ease(Quad.easeOut);
		
		pentaText.text = toRomanNumerals(pDegree + 1);
	}
	
	private function getAvailablePositiveUpdateParticle(): ParticleSystem
	{
		for (particle in pentaPositiveUpdateParticles)
		{
			if (particle.active) continue;
			
			return particle;
		}
		
		return null;
	}
	
	private function getAvailableNegativeUpdateParticle(): ParticleSystem
	{
		for (particle in pentaNegativeUpdateParticles)
		{
			if (particle.active) continue;
			
			return particle;
		}
		
		return null;
	}
	
	private function toRomanNumerals(pNumber: Int): String {
		switch pNumber {
			case 1: return "|";
			case 2: return "||";
			case 3: return "|||";
			case 4: return "|V";
			case 5: return "V";
		}
		
		return "";
	}
	
	public function pentaDeath(): Void
	{
		pentaText.text = "";
		Actuate.tween(pentagram, GameManager.WIN_DELAY_IN_SECONDS, {scaleX: 0, scaleY: 0}).ease(Quad.easeIn);
	}
	
	public function flyingScore(pGameObject: StateMovieClip, pScore: Int): Void
	{
		var lScoreContainerLocalPosOnHud: Point = globalToLocal(scoreContainer.parent.localToGlobal(new Point(scoreContainer.x, scoreContainer.y)));
		var lLocalPosOnHud: Point = globalToLocal(pGameObject.parent.localToGlobal(new Point(pGameObject.x, pGameObject.y)));
		
		var lFlyingScore: TextField = new TextField();
		var lFlyingScoreContainer: DisplayObjectContainer = new DisplayObjectContainer();
		lFlyingScore.setTextFormat(FontAndLoca.currentFont);
		lFlyingScore.textColor = FLYING_SCORE_INIT_COLOR;
		lFlyingScore.text = '+ $pScore';
		lFlyingScore.autoSize = TextFieldAutoSize.CENTER;
		lFlyingScoreContainer.addChild(lFlyingScore);
		lFlyingScore.y = - lFlyingScore.height / 2;
		lFlyingScore.x = - lFlyingScore.width / 2;
		
		lFlyingScoreContainer.scaleX = FLYING_SCORE_SIZE * FLYING_SCORE_INIT_SIZE_COEFF;
		lFlyingScoreContainer.scaleY = FLYING_SCORE_SIZE * FLYING_SCORE_INIT_SIZE_COEFF;
		lFlyingScoreContainer.x = lLocalPosOnHud.x;
		lFlyingScoreContainer.y = lLocalPosOnHud.y - pGameObject.collider.height - FLYING_SCORE_INIT_Y_OFFSET;
		
		addChild(lFlyingScoreContainer);
		
		Actuate.tween(lFlyingScoreContainer, FLYING_SCORE_ANIM_DURATION * 0.5, {scaleX: FLYING_SCORE_SIZE, scaleY: FLYING_SCORE_SIZE});
		Actuate.transform(lFlyingScore, FLYING_SCORE_ANIM_DURATION * 0.5, false).color(FLYING_SCORE_END_COLOR)
			   .onComplete(function () {Actuate.tween(lFlyingScoreContainer, FLYING_SCORE_ANIM_DURATION * 0.5, {x: lScoreContainerLocalPosOnHud.x, y: lScoreContainerLocalPosOnHud.y})
											   .ease(Sine.easeOut).onComplete(function() {score += pScore; removeChild(lFlyingScoreContainer); }); } );
	}
	
	override public function destroy():Void 
	{
		btnPause.removeEventListener(MouseEvent.CLICK, onPause);
		instance = null;
		
		super.destroy();
	}
}