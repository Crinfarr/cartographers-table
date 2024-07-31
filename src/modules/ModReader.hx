package modules;

import haxe.io.Bytes;
import haxe.zip.Entry;
import sys.io.File;
import haxe.zip.Reader;

class ModReader extends Reader {
	private var entries(get, never):List<Entry>;
    private final re_textype = ~/(?<=\/textures\/).+?(?=\/)/gm;

	public function new(path:String) {
        super(File.read(path));
        for (entry in this.entries) {
			//TODO
        }
    }
    private function get_entries():List<Entry> {
        return this.read();
    }
}