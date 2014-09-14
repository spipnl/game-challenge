package spipnl;

import haxe.xml.Fast;
import openfl.Assets;

class Settings {
	public static var settings:Map<String, String>;
	
	public static function loadXml(fileName:String):Void
	{
		var xmlFast:Fast = new Fast(Xml.parse(Assets.getText(fileName)).firstElement());
		
		settings = new Map();
		for (setting in xmlFast.nodes.setting) {
			settings.set(setting.att.key, setting.att.value);
		}
	}
}