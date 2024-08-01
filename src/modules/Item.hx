package modules;

import haxe.io.Bytes;
import haxe.Exception;

class Item {
	public var category(get, never):Null<String>;
	public var modid(get, never):String;
	public var name(get, never):String;
    public var literal:String;
    public var sprite:Bytes;

	public function new(str:String) {
		literal = str;
	}

	private function get_category():Null<String> {
		final re = ~/(?<=:).+?(?=\/)/gm;
		if (!re.match(literal))
			return null;
		return re.matched(0);
	}
	private function get_modid():String {
		final re = ~/^.+?(?=:)/gm;
		if (!re.match(literal))
			throw new Exception('Cannot detect MODID of $literal');
		return re.matched(0);
	}
	private function get_name():String {
		final re = new EReg('(?<=${literal.indexOf('/') == -1 ? ':' : '/'}).+?', "gm");
		if (!re.match(literal))
			throw new Exception('Cannot detect name of $literal');
		return re.matched(0);
	}
}
