package com.gabrielbernabeu.utils.game.stateObjects.colliders;

import com.gabrielbernabeu.utils.game.stateObjects.colliders.Collider;

/**
 * @author Chadi Husser
 */
typedef ColliderData =
{
	var x:Float;	
	var y:Float;	
	var type:Collider;	
	@optional var radius:Float;
	@optional var width:Float;
	@optional var height:Float;
}