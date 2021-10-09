package com.gabrielbernabeu.onebutton.game.sprites;

/**
 * ...
 * @author Gabriel Bernabeu
 */
class KillableObject extends MovingObject 
{

	public function new() 
	{
		super();
		
	}
	
	public function die(): Void {
		deathShake();
		setModeDie();
	}
	
	private function deathShake(): Void {}
	
	private function setModeDie(): Void
	{
		doAction = doActionDie;
		
		collider.parent.removeChild(collider);
		collider = null;
	}
	
	private function doActionDie(): Void 
	{
		if (!isAnimEnded)
			super.timedAnim();
	}
	
}