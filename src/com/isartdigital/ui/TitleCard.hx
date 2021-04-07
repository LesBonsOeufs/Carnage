package com.isartdigital.ui;

import com.isartdigital.game.GameManager;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.media.Sound;
import openfl.utils.Assets;

/**
 * ...
 * @author Chadi Husser
 */
class TitleCard extends Screen 
{
	private static var instance : TitleCard;
	
	private function new() 
	{
		super();
		content.getChildByName("btnPlay").addEventListener(MouseEvent.CLICK, onClick);
		
		
		var lPositionnable:UIPositionable = { item:content.getChildByName("btnPlay"), align:AlignType.BOTTOM, offsetY:450};
		positionables.push(lPositionnable);
		lPositionnable = { item:content.getChildByName("background"), align:AlignType.FIT_SCREEN};
		positionables.push(lPositionnable);
	}
	
	public static function getInstance() : TitleCard {
		if (instance == null) instance = new TitleCard();
		return instance;
	}
	
	private function onClick(pEvent:MouseEvent) : Void {
		GameManager.start();
		//SoundManager.getSound("click").start();
		
		pEvent.stopPropagation();
	}
	
	override public function destroy():Void 
	{
		content.getChildByName("btnPlay").removeEventListener(MouseEvent.CLICK, onClick);
		super.destroy();
	}
}