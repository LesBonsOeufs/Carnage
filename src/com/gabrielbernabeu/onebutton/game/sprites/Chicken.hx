package com.gabrielbernabeu.onebutton.game.sprites;

import com.gabrielbernabeu.onebutton.ui.Hud;
import com.gabrielbernabeu.onebutton.game.layers.GameLayer;
import com.gabrielbernabeu.utils.effects.Shake;
import com.gabrielbernabeu.utils.game.GameStage;
import openfl.geom.Point;
import org.zamedev.particles.ParticleSystem;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Chicken extends MovingObject 
{
	public static inline var DEGREE_VALUE: Int = 5;
	
	public static var list(default, null): Array<Chicken> = new Array<Chicken>();
	
	private var scoreValue(get, never): Int;
	private var speed: Int = 25;
	
	/**
	 * A override avec les bonnes values.
	 * @return
	 */
	private function get_scoreValue(): Int {
		return 300;
	}
	
	override function get_maxVelocity():Float {
		return -speed;
	}

	public function new() 
	{
		super();
		loop = false;
		list.push(this);
	}
	
	static public function doActions(): Void
	{
		var i: Int = list.length - 1;
		while (i > -1)
		{
			list[i].doAction();
			i--;
		}
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		trace(renderer.currentFrame);
		testOutOfBounds();
	}
	
	override function move():Void 
	{
		x += maxVelocity * GameManager.timeBasedCoeff;
	}
	
	private function testOutOfBounds(): Void
	{
		if (x + width / 2 < cast(parent, GameLayer).screenLimits.left)
			destroy();
	}
	
	static public function reset(): Void
	{
		var i: Int = list.length - 1;
		
		while (i > -1)
		{
			list[i].destroy();
			i--;
		}
	}
	
	public function die(): Void
	{
		Shake.operate(GameStage.getInstance(), 5, 10, new Point(GameStage.getInstance().x, GameStage.getInstance().y));
		
		var lBloodExplosionParticle: ParticleSystem = GameManager.getAvailableBloodParticle();
		
		if (lBloodExplosionParticle != null)
			lBloodExplosionParticle.emit(x, y - collider.height / 2);
		
		Hud.getInstance().flyingScore(this, scoreValue);
		destroy();
	}
	
	override public function destroy():Void 
	{	
		list.remove(this);
		super.destroy();
	}
}