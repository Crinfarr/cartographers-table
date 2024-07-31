package modules;

import haxe.Exception;

abstract Item(String) from String to String {
	public var category(get, never):Null<String>;
	public var modid(get, never):String;
	public var name(get, never):String;
    public var literal(get, never):String;

	public function new(str:String) {
		this = str;
	}

	private function get_category():Null<String> {
		final re = ~/(?<=:).+?(?=\/)/gm;
		if (!re.match(this))
			return null;
		return re.matched(0);
	}

	private function get_modid():String {
		final re = ~/^.+?(?=:)/gm;
		if (!re.match(this))
			throw new Exception('Cannot detect MODID of $this');
		return re.matched(0);
	}

	private function get_name():String {
		final re = new EReg('(?<=${this.indexOf('/') == -1 ? ':' : '/'}).+?', gm);
		if (!re.match(this))
			throw new Exception('Cannot detect name of $this');
		return re.matched(0);
	}
    @:to(String)
    private function get_literal():String {
        return this;
    }
}
