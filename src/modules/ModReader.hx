package modules;

import haxe.io.Bytes;
import haxe.zip.Entry;
import sys.io.File;
import haxe.zip.Reader;

class ModReader extends Reader {
	private var entries(get, never):List<Entry>;
    private var texRegistry:Map<String, Map<String, Bytes>> = new Map<String, Map<String, Bytes>>();
    private final re_textype = ~/(?<=\/textures\/).+?(?=\/)/gm;
    private final re_itemname = ~//gm;
    //TODO extract item list from mod

	public function new(path:String) {
        super(File.read(path));
        for (entry in this.entries) {
			if (~/(?<=\/textures\/).+(\.json|\.png)/gm.match(entry.fileName)) {
                
                re_textype.match(entry.fileName);
                final texType = re_textype.matched(0);

                //Compat step in case this isn't declared yet
                if (!texRegistry.exists(texType)) texRegistry.set(texType, new Map<String, Bytes>());
                
                if (~/\.json$/gm.match(entry.fileName)) {
                }
                else {
                }
            }
        }
    }
    private function get_entries():List<Entry> {
        return this.read();
    }
}