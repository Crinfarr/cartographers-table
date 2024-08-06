package modules.config;

import haxe.io.Input;
import haxe.io.Bytes;

private typedef Mod = {
    name:String,
    version:String,
}
private typedef ConfigOpts = {
	packLoc:String, // Stored as UTF-8 file path relative to this config
	version:String, // Stored as (v&0xff0000).(v&0x00ff00).(v&0x0000ff)
	// PS fuck you mojang for going above 1.16 now I have to use a full byte
    modList:Array<Mod>
}

class ConfigInst {
	private var conf:ConfigOpts;

	private function new() {}

	public static function create(ifl:Input):ConfigInst {
		final rv = new ConfigInst();
		if (ifl.read(10) != Bytes.ofHex("0x02130f00020a0c041300"))
			throw "Invalid file: header check failed";
		final path = ifl.readString(ifl.readByte());
        final version = '${ifl.readByte()}.${ifl.readByte()}.${ifl.readByte}';
        final modList:Array<Mod> = [];
        for (_ in 0...ifl.readByte()) {
            //Mod data logic
            modList.push({
                name: ifl.readString(ifl.readByte()),
                version: ifl.readString(ifl.readByte())
            });
        }
        rv.conf = {
            packLoc: path,
            modList: modList,
            version: version
        }
		return rv;
        // 0x7fffffff
	}
}
