package com.isartdigital.onebutton.game;
import com.isartdigital.onebutton.game.layers.Layer;
import com.isartdigital.onebutton.game.layers.scenes.ScrollingForest;
import com.isartdigital.onebutton.game.sprites.Obstacle;
import com.isartdigital.onebutton.game.sprites.TimeFlexibleObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import openfl.geom.Point;
import openfl.display.DisplayObjectContainer;

/**
 * ...
 * @author Gabriel Bernabeu
 */
enum PatternBrick {
    OBSTACLE;
	HOUSE;
	WELL;
	SWORDSMAN;
}

class PatternManager 
{
	private static inline var X_BETWEEN_PATTERN: Float = 1200;
	
	private static inline var BRICK_X_OFFSET: Int = 20;
	private static inline var BRICK_Y_OFFSET: Int = 20;
	
	private static var file: Array<Array<String>>;
	private static var container: Layer;
	
	private static var countXShifting: Float = 0;
	
	//Fausse valeur de départ donnée à lastContainerX afin de faire apparaitre + vite le 1er pattern
	private static var lastContainerX: Float = X_BETWEEN_PATTERN / 2;

	private function new() {}
	
	public static function init(pLayer: Layer): Void
	{
		var lFullFile: Dynamic = Json.parse(GameLoader.getText("assets/levels/leveldesign.json"));
		file = Reflect.field(lFullFile, "levelDesign");
		
		trace(file);
		
		container = pLayer;
		lastContainerX += container.x;
	}
	
	public static function doAction(): Void
	{
		countXShifting += container.x - lastContainerX;
		
		if (Math.abs(countXShifting) >= X_BETWEEN_PATTERN)
		{
			countXShifting = 0;
			pickRandomPattern();
		}
		
		lastContainerX = container.x;
	}
	
	private static function pickRandomPattern(): Void
	{
		var lRandomIndex: Int = Math.floor(Math.random() * file.length);
		var lPattern: Array<String> = file[lRandomIndex];
		
		var lInitPos: Point = new Point(container.screenLimits.right, ScrollingForest.groundY);
		
		var lAddedBricks: Array<TimeFlexibleObject> = new Array<TimeFlexibleObject>();
		var lCurrentBrick: TimeFlexibleObject = null;
		
		var i: Int = 0;
		var j: Int = 0;
		
		for (row in lPattern)
		{
			for (char in row.split(""))
			{
				switch char {
					case "#": lCurrentBrick = new Obstacle();
					//case "@": lCurrentBrick = SWORDSMAN;
					//case "^": lCurrentBrick = HOUSE;
				}
				
				if (lCurrentBrick == null) continue;
				
				lCurrentBrick.x = lInitPos.x + lCurrentBrick.width / 2 +  BRICK_X_OFFSET * j;
				lCurrentBrick.y = lInitPos.y + BRICK_Y_OFFSET * i;
				
				container.addChild(lCurrentBrick);
				lCurrentBrick.start();
				
				lAddedBricks.push(lCurrentBrick);
				
				lCurrentBrick = null;
				j++;
			}
			
			j = 0;
			i++;
		}
		
		for (brick in lAddedBricks) {
			countXShifting -= brick.width;
		}
		
		trace(lAddedBricks.length);
	}
}