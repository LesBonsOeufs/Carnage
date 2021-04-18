package com.isartdigital.onebutton.game.sprites;

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
		setModeDie();
	}
	
	private function setModeDie(): Void
	{
		doAction = doActionDie;
		
		collider.parent.removeChild(collider);
		collider = null;
	}
	
	private function doActionDie(): Void {}
	
}