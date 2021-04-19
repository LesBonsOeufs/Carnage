package com.isartdigital.onebutton.ui;

import com.isartdigital.onebutton.game.GameManager;
import com.isartdigital.onebutton.game.sprites.Player;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Quad;
import openfl.Vector;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
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
	private static inline var UPDATE_PARTICLE_DURATION: Float = 0.1;
	
	private static var instance : Hud;
	
	private var pentagram: DisplayObjectContainer;
	private var btnPause: SimpleButton;
	
	private var pentaPositiveUpdateParticles: Vector<ParticleSystem>;
	private var pentaNegativeUpdateParticles: Vector<ParticleSystem>;
	private var pentaSignParticles: Vector<ParticleSystem>;
	private var pentaSummits: Vector<DisplayObject>;
	
	private var pentaScalesPerDegree(default, null): Array<Float> = [0.8, 1, 1.3, 1.7, 2];
	
	public static function getInstance() : Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}
	
	public function new() 
	{
		super();
		
		var lPositionnable:UIPositionable;
		lPositionnable = { item:content.getChildByName("mcTopCenter"), align:AlignType.TOP};
		positionables.push(lPositionnable);
		lPositionnable = { item:content.getChildByName("mcTopLeft"), align:AlignType.TOP_LEFT};
		positionables.push(lPositionnable);
		lPositionnable = { item:content.getChildByName("mcTopRight"), align:AlignType.TOP_RIGHT};
		positionables.push(lPositionnable);
		
		btnPause = cast(cast(content.getChildByName("mcTopRight"), DisplayObjectContainer).getChildByName("btnPause"), SimpleButton);
		btnPause.addEventListener(MouseEvent.CLICK, onPause);
		
		pentagram = cast(cast(content.getChildByName("mcTopLeft"), DisplayObjectContainer).getChildByName("mcPentagram"), DisplayObjectContainer);
		pentagram.scaleX = pentaScalesPerDegree[Player.INIT_DEGREE];
		pentagram.scaleY = pentaScalesPerDegree[Player.INIT_DEGREE];
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
		if (GameManager.isPaused) return;
		
		GameManager.pauseScreen();
		SoundManager.getSound("click").start();
	}
	
	public function updatePentagram(pDegreeBar: Int, pDegree: Int, pPositiveUpdate: Bool): Void
	{
		var lTweenCoeff: Float;
		
		if (pPositiveUpdate)
		{
			lTweenCoeff = 1.1;
			getAvailablePositiveUpdateParticle().emit(0, 0);
		}
		else
		{
			lTweenCoeff = 0.9;
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
	
	override public function destroy():Void 
	{
		btnPause.removeEventListener(MouseEvent.CLICK, onPause);
		instance = null;
		
		super.destroy();
	}
}