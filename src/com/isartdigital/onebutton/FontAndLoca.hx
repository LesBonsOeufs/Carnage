package com.isartdigital.onebutton;

import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.SimpleButton;
import openfl.text.TextField;
import openfl.text.TextFormat;

typedef Translation = 
{
    var en: String;
    var fr: String;
}

/**
 * ...
 * @author Gabriel Bernabeu
 */
class FontAndLoca 
{
	static private inline var ENGLISH: UInt = 0;
	static private inline var FRANCAIS: UInt = 1;
	
	static private var currentTranslation: UInt;
	static private var file: Dynamic;

	private function new() { }
	
	static public function initTranslationFile(): Void
	{
		file = Json.parse(GameLoader.getText("assets/localization.json"));
		currentTranslation = ENGLISH;
	}
	
	static public function switchLanguage(): Void
	{
		if (currentTranslation == ENGLISH)
			currentTranslation = FRANCAIS;
		else if (currentTranslation == FRANCAIS)
			currentTranslation = ENGLISH;
	}
	
	static public function setUpTextFields(pParent: DisplayObject): Void
	{
		var lTextFields: Array<TextField> = findTextFields(pParent);
		var lContent: String;
		
		var lTextFormat: TextFormat = new TextFormat(GameLoader.getFont("assets/fonts/OldLondon.ttf").fontName);
		
		for (textField in lTextFields)
		{
			textField.setTextFormat(lTextFormat);
			lContent = textField.text;
			
			if (lContent.charAt(0) == "*") lContent = lContent.substr(1);
			
			// comportement étrange du TextField qui ajoute un saut de ligne à la fin des chaines, pour la comparaison on le supprime
			if (lContent.charAt(lContent.length - 1).charCodeAt(0) == 10)
				lContent = lContent.substr(0, lContent.length - 1);
			
			lContent = getTranslatedText(lContent);
			textField.text = lContent;
		}
	}
	
	static private function findTextFields(pParent:DisplayObject): Array<TextField> 
	{
		var lChild:DisplayObject;
		
		var lTextFields:Array<TextField> = new Array<TextField>();
		
		if (!Std.is(pParent, DisplayObjectContainer)) return lTextFields;
		
		var lContainer: DisplayObjectContainer = cast(pParent, DisplayObjectContainer);
		
		if (lContainer.numChildren == 0) return lTextFields;
		
		for (i in 0...lContainer.numChildren) 
		{
			lChild = lContainer.getChildAt(i);
			
			if (Std.is(lChild, TextField))
			{
				lTextFields.push(cast(lChild, TextField));
				continue;
			}
			else if (Std.is(lChild, SimpleButton))
				lTextFields = lTextFields.concat(getButtonTexts(cast(lChild, SimpleButton)));
			
			lTextFields = lTextFields.concat(findTextFields(lChild));
		}
		
		return lTextFields;
	}
	
	static private function getTranslatedText(pString: String): String
	{
		var lUppedString: String = pString.toUpperCase();
		var lTextTranslation: Translation = Reflect.field(file, lUppedString);
		
		if (lTextTranslation == null) return lUppedString;
		
		if (currentTranslation == ENGLISH)
			return lTextTranslation.en;
		else if (currentTranslation == FRANCAIS)
			return lTextTranslation.fr;
		
		return null;
	}
	
	static private function getButtonTexts(pButton: SimpleButton): Array<TextField>
	{
		var lTextFields: Array<TextField> = new Array<TextField>();
		
		lTextFields = lTextFields.concat(findTextFields(pButton.upState));
		lTextFields = lTextFields.concat(findTextFields(pButton.overState));
		lTextFields = lTextFields.concat(findTextFields(pButton.downState));
		
		return lTextFields;
	}
	
}