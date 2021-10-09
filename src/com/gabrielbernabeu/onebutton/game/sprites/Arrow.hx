package com.gabrielbernabeu.onebutton.game.sprites;

import com.gabrielbernabeu.onebutton.game.GameManager;
import com.gabrielbernabeu.onebutton.game.layers.GameLayer;
import com.gabrielbernabeu.onebutton.game.layers.scenes.ScrollingForest;
import com.gabrielbernabeu.utils.effects.Trail;
import com.gabrielbernabeu.utils.game.CollisionManager;
import com.gabrielbernabeu.utils.game.stateObjects.StateMovieClip;
import com.gabrielbernabeu.utils.sound.SoundManager;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Arrow extends StateMovieClip 
{
	private inline static var SPEED: Int = 25;
	private inline static var DAMAGE: Int = 5;
	
	private static var list(default, null): Array<Arrow> = new Array<Arrow>();
	
	private var target: Player;
	private var trail: Trail;

	public function new(?pTarget: Player = null) 
	{
		super();
		
		list.push(this);
		
		renderer.stop();
		
		scaleX = -1;
		scaleY /= 2;
		
		if (pTarget == null)
			target = GameManager.player;
		
		//initTrail();
	}
	
	private function initTrail(): Void
	{
		var lTrailIndicator: DisplayObject = renderer.getChildByName("mcIndicator");
		
		trail = new Trail();
		trail.x = lTrailIndicator.x * scaleX;
		trail.y = lTrailIndicator.y * scaleX;
		trail.init(this, 10, 7, 150);
		trail.color = 0xffffff;
		trail.persistence = 0.6;
		
		renderer.removeChild(lTrailIndicator);
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
		//trail.draw();
		
		super.doActionNormal();
		
		if (CollisionManager.hasCollision(target.hitBox, hitBox, target.hitBoxes, hitBoxes))
		{
			hit();
			return;
		}
		
		x += SPEED * scaleX * GameManager.timeBasedCoeff;
		
		testOutOfBounds();
	}
	
	private function testOutOfBounds(): Void
	{
		if (x + width / 2 < cast(parent, GameLayer).screenLimits.left)
			destroy();
	}
	
	private function hit(): Void
	{
		var lRandomSoundIndex: Int = Math.floor(Math.random() * 2);
			
		if (target.takeDamage(DAMAGE))
			SoundManager.getSound("swordsman_hit" + lRandomSoundIndex).start();
		else
			SoundManager.getSound("player_block" + lRandomSoundIndex).start();
		
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
	
	override public function destroy():Void 
	{
		//trail.clear();
		//trail.destroy();
		
		list.remove(this);
		super.destroy();
	}
}