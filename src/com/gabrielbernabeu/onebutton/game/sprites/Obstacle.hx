package com.gabrielbernabeu.onebutton.game.sprites;

import com.gabrielbernabeu.onebutton.game.GameManager;
import com.gabrielbernabeu.onebutton.game.layers.GameLayer;
import com.gabrielbernabeu.utils.effects.Shake;
import com.gabrielbernabeu.utils.game.CollisionManager;
import com.gabrielbernabeu.utils.game.GameStage;
import com.gabrielbernabeu.utils.game.stateObjects.StateMovieClip;
import openfl.geom.Point;
import org.zamedev.particles.ParticleSystem;
import com.gabrielbernabeu.onebutton.ui.Hud;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Obstacle extends StateMovieClip
{
	public static var list(default, null): Array<Obstacle> = new Array<Obstacle>();
	
	private var scoreValue(get, never): Int;
	
	/**
	 * A override avec les bonnes values.
	 * @return
	 */
	private function get_scoreValue(): Int {
		return 20;
	}

	public function new() 
	{
		super();
		
		list.push(this);
		
		renderer.cacheAsBitmap = true;
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
		
		var lPlayer: Player = GameManager.player;
		
		//if (CollisionManager.hasCollision(hitBox, lPlayer.hitBox, hitBoxes, lPlayer.getGlobalHitPoints()))
			//trace("ok");
		
		testOutOfBounds();
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
	
	public function smash(): Void
	{
		Shake.operate(GameStage.getInstance(), 5, 10, new Point(GameStage.getInstance().x, GameStage.getInstance().y));
		
		var lWoodParticle: ParticleSystem = GameManager.getAvailableWoodParticle();
		
		if (lWoodParticle != null)
			lWoodParticle.emit(x, y - collider.height / 2);
		
		Hud.getInstance().flyingScore(this, scoreValue);
		destroy();
	}
	
	override public function destroy():Void 
	{	
		list.remove(this);
		super.destroy();
	}
}