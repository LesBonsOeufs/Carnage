package com.isartdigital.onebutton.game;
import com.isartdigital.onebutton.game.layers.Layer;
import com.isartdigital.onebutton.game.layers.scenes.ScrollingForest;
import com.isartdigital.onebutton.game.sprites.Obstacle;
import com.isartdigital.onebutton.game.sprites.enemies.Bowman;
import com.isartdigital.onebutton.game.sprites.enemies.Swordsman;
import com.isartdigital.onebutton.game.sprites.TimeFlexibleObject;
import com.isartdigital.onebutton.game.sprites.enemies.Tank;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import openfl.geom.Point;

/**
 * ...
 * @author Gabriel Bernabeu
 */
typedef Pattern = {
	var difficulty: UInt;
	var content: Array<String>;
}

class PatternManager 
{
	private static inline var FENCE: String = "#";
	private static inline var SWORDSMAN: String = "/";
	private static inline var TANK: String = "@";
	private static inline var BOWMAN: String = "(";
	
	private static inline var MAX_DIFFICULTY: Int = 1;
	
	private static inline var X_BETWEEN_PATTERN: Float = 900;
	private static inline var PATTERNS_BETWEEN_DIFFICULTY_INCREASE: Float = 6;
	
	private static inline var BRICK_X_OFFSET: Int = 200;
	private static inline var BRICK_Y_OFFSET: Int = 200;
	
	private static var file: Array<Pattern>;
	private static var container: Layer;
	
	private static var difficulty: UInt = 0;
	private static var patternsBox: Array<Pattern>;
	
	private static var countXShifting: Float = 0;
	private static var countPatterns: Float = 0;
	
	//Fausse valeur de départ donnée à lastContainerX afin de faire apparaitre + vite le 1er pattern
	private static var lastContainerX: Float = X_BETWEEN_PATTERN / 2;
	
	private static var sawDecor: Bool = false;
	private static var sawSwordsman: Bool = false;
	private static var sawTank: Bool = false;
	private static var sawBowman: Bool = false;

	private function new() {}
	
	public static function init(pLayer: Layer): Void
	{
		patternsBox = new Array<Pattern>();
		
		var lFullFile: Dynamic = Json.parse(GameLoader.getText("assets/levels/leveldesign.json"));
		file = Reflect.field(lFullFile, "levelDesign");
		
		container = pLayer;
		lastContainerX += container.x;
	}
	
	public static function doAction(): Void
	{
		countXShifting += Math.abs(container.x - lastContainerX);
		
		if (countXShifting >= X_BETWEEN_PATTERN)
		{
			countXShifting = 0;
			pickRandomPattern();
			
			if (countPatterns++ >= PATTERNS_BETWEEN_DIFFICULTY_INCREASE)
			{
				countPatterns = 0;
				
				if (difficulty < MAX_DIFFICULTY)
					difficulty++;
			}
		}
		
		lastContainerX = container.x;
	}
	
	private static function pickRandomPattern(): Void
	{
		if (patternsBox.length == 0)
			fillPatternsBox();
		
		var lRandomIndex: Int = Math.floor(Math.random() * patternsBox.length);
		var lPattern: Pattern = patternsBox[lRandomIndex];
		patternsBox.remove(lPattern);
		lPattern = isolate(lPattern);
		
		var lInitPos: Point = new Point(container.screenLimits.right, ScrollingForest.groundY);
		
		var lAddedBricks: Array<StateMovieClip> = new Array<StateMovieClip>();
		var lCurrentBrick: StateMovieClip = null;
		
		var i: Int = 0;
		var j: Int = 0;
		
		for (row in lPattern.content)
		{
			for (char in row.split(""))
			{
				switch char {
					case FENCE: lCurrentBrick = new Obstacle();
					case SWORDSMAN: lCurrentBrick = new Swordsman();
					case TANK: lCurrentBrick = new Tank();
					case BOWMAN: lCurrentBrick = new Bowman();
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
		
		countXShifting -= 113 * lAddedBricks.length;
		countXShifting -= BRICK_Y_OFFSET * lAddedBricks.length - 1;
	}
	
	private static function fillPatternsBox(): Void
	{
		for (pattern in file)
		{
			if (pattern.difficulty == difficulty)
				patternsBox.push(pattern);
		}
	}
	
	/**
	 * Si un élément n'a jamais été vu durant cette session, l'isole.
	 * @param	pPattern
	 * @return
	 */
	private static function isolate(pPattern: Pattern): Pattern
	{
		var lIsolatedPattern: Pattern = {difficulty: pPattern.difficulty, content: []};
		
		if (!sawSwordsman)
		{
			for (row in pPattern.content)
			{
				for (char in row.split(""))
				{
					if (char == SWORDSMAN) 
					{
						lIsolatedPattern.content = [SWORDSMAN];
						sawSwordsman = true;
						return lIsolatedPattern;
					}
				}
			}
		}
		else if (!sawDecor)
		{
			for (row in pPattern.content)
			{
				for (char in row.split(""))
				{
					if (char == FENCE) 
					{
						lIsolatedPattern.content = [FENCE];
						sawDecor = true;
						return lIsolatedPattern;
					}
				}
			}
		}
		else if (!sawTank)
		{
			for (row in pPattern.content)
			{
				for (char in row.split(""))
				{
					if (char == TANK)
					{
						lIsolatedPattern.content = [TANK];
						sawTank = true;
						return lIsolatedPattern;
					}
				}
			}
		}
		else if (!sawBowman)
		{
			for (row in pPattern.content)
			{
				for (char in row.split(""))
				{
					if (char == BOWMAN)
					{
						lIsolatedPattern.content = [BOWMAN];
						sawBowman = true;
						return lIsolatedPattern;
					}
				}
			}
		}
		
		return pPattern;
	}
	
	public static function reset(): Void
	{
		difficulty = 0;
		countXShifting = 0;
		countPatterns = 0;
		file = null;
		container = null;
	}
}