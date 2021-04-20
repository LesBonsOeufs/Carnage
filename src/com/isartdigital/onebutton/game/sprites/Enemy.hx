package com.isartdigital.onebutton.game.sprites;
import com.isartdigital.onebutton.game.layers.GameLayer;
import com.isartdigital.utils.effects.Shake;
import com.isartdigital.utils.game.GameStage;
import openfl.geom.Point;
import org.zamedev.particles.ParticleSystem;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class Enemy extends MeleeObject 
{
	private inline static var RETREAT: String = "walkBack";
	private inline static var WALK: String = "walk";
	
	private inline static var RUN_TRIGGER_VALUE: Float = 3.5;
	
	public static var list(default, null): Array<Enemy> = new Array<Enemy>();
	
	private var target: Player;
	
	private var _maxVelocity: Float;
	
	override function get_maxVelocity():Float {
		return _maxVelocity;
	}
	
	override function get_accelerationValue():Float {
		return -3 / GameManager.FPS;
	}
	
	private var size(get, never): Float;
	
	function get_size():Float {
		return 1;
	}
	
	private var damage(get, never): Int;
	
	function get_damage(): Int {
		return 5;
	}

	public function new(?pTarget: Player = null) 
	{
		super();
		
		list.push(this);
		
		scaleX = -size;
		scaleY = size;
		
		if (pTarget == null)
			target = GameManager.player;
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
	
	/**
	 * Renvoie true si l'ennemi se met à fuir.
	 * @return
	 */
	private function fearChance(): Bool {
		return false;
	}
	
	private function setModeAttack(): Void {
		doAction = doActionAttack;
	}
	
	private function doActionAttack(): Void {
		super.timedAnim();
	}
	
	override function die(): Void 
	{
		var lBloodParticle: ParticleSystem = GameManager.getAvailableBloodParticle();
		
		if (lBloodParticle != null)
			lBloodParticle.emit(x, y - collider.height / 2);
		
		super.die();
	}
	
	override function deathShake(): Void {
		Shake.operate(GameStage.getInstance(), 5, 10, new Point(GameStage.getInstance().x, GameStage.getInstance().y));
	}
	
	override function setModeDie(): Void
	{
		if (scaleX < 0)
			setState("death_back");
		else if (scaleX > 0)
			setState("death_belly");
		
		super.setModeDie();
	}
	
	override function doActionDie(): Void
	{
		super.doActionDie();
		
		testOutOfBounds();
	}
	
	private function testOutOfBounds(): Void
	{
		if (x + width / 2 < cast(parent, GameLayer).screenLimits.left)
			destroy();
	}
	
	override function timedAnim():Void 
	{	
		if (xVelocity != 0)
		{
			if (absVelocity() < RUN_TRIGGER_VALUE)
			{
				if (scaleX != -size)
					scaleX = -size;
				
				if (xVelocity > 0)
					setState(RETREAT);
				else
					setState(WALK);
			}
			else 
			{
				if (xVelocity > 0 && scaleX != size)
					scaleX = size;
				
				setState(MeleeObject.RUN);
			}
		}
		
		super.timedAnim();
	}
	
	override public function destroy():Void 
	{
		list.remove(this);
		super.destroy();
	}
	
	public static function reset(): Void 
	{
		var i: Int = list.length - 1;
		
		while (i > -1)
		{
			list[i].destroy();
			i--;
		}
	}
}