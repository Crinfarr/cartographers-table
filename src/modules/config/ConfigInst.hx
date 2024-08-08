package modules.config;

import haxe.macro.Compiler;
import haxe.Exception;
#if !test_mod_list import views.dialogs.ErrorDialog; #end
import haxe.zip.Entry;
import haxe.zip.Tools;
import sys.io.File;
import haxe.zip.Reader;
import haxe.zip.Uncompress;
import haxe.zip.Compress;
import haxe.io.Path;
import sys.FileSystem;
import haxe.io.BytesBuffer;
import haxe.io.Input;
import haxe.io.Bytes;

using StringTools;
using haxe.zip.Tools;

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
		if (ifl.read(10) != Bytes.ofHex("02130f00020a0c041300"))//FIXME this doesn't work at all 
			throw "Invalid file: header check failed";
		final path = ifl.readString(ifl.readByte());
		final version = '${ifl.readByte()}.${ifl.readByte()}.${ifl.readByte}';
		final modList:Array<Mod> = [];
		for (_ in 0...ifl.readByte()) {
			// Mod data logic
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

	private static function makeModList(modFolder:String):Array<Mod> {
		final mods:Array<Path> = [
			for (itm in FileSystem.readDirectory(modFolder).filter(f -> f.endsWith('.jar')))
				new Path('$modFolder/$itm')
		];
		final returns:Array<Mod> = [];
		for (mod in mods) {
			final entries = Reader.readZip(File.read(mod.toString()));
			var metadata:Null<String> = null;
			for (entry in entries) {
				if (entry.fileName == "META-INF/mods.toml") {
					trace('$mod :: ${entry.fileName}');
					entry.uncompress();
					metadata = entry.data.toString();
					break;
				}
			}
			#if !test_mod_list
			if (metadata == null)
                ErrorDialog.fromException(new Exception('Could not find mod metadata for $mod'));
			#end
			final reVersion = ~/(?:^[ \t]*version ?= ?")(.+)(?:")/gm;
			var version:String = '';
			var reName = ~/(?:^[ \t]*displayName ?= ?")(.+)(?:")/gm;
			var name:String = '';
			if (reVersion.match(metadata.toString()))
				trace("Found version");
            else
                trace("could not find version");
			if (reName.match(metadata.toString()))
				trace("Found name");
			else
				trace("could not find name");
			trace('Found ${reName.matched(1)} v/${reVersion.matched(1)}');
			version = reVersion.matched(1);
			name = reName.matched(1);
			if (version == "${file.jarVersion}") {
                final reManifest = ~/(?:^[ \t]*Implementation-Version: ?)(.+)/gm;
                trace("Reading jar metadata");
                for (entry in entries) {
                    if (entry.fileName == "META-INF/MANIFEST.MF") {
                        entry.uncompress();
                        metadata = entry.data.toString();
                        if (reManifest.match(metadata))
                            trace('Found manifest version')
                        else
                            trace(metadata);
                        version = reManifest.matched(1);
                        trace('Detected manifest version as $version');
                    }
                }
            }
			
			returns.push({
				name: name,
				version: version
			});
		}

		return returns;
	}

	public static function createDefault(path:String):ConfigInst {
		trace('Creating default pack');
		final rv = new ConfigInst();
		rv.conf = {
			packLoc: ".",
			modList: makeModList('$path/mods'),
			version: Compiler.getDefine("version")
		}
		return rv;
	}

	@:to(Bytes)
	public function toBytes() {
		final b = new BytesBuffer();
		// File header
		b.add(Bytes.ofHex("02130f00020a0c041300"));
		// Path
		b.addByte(this.conf.packLoc.length);
		b.addString(this.conf.packLoc);
		// Version
		final varr = this.conf.version.split('.');
		/*major*/ b.addByte(Std.parseInt(varr[0]));
		/*minor*/ b.addByte(Std.parseInt(varr[1]));
		/*patch*/ b.addByte(Std.parseInt(varr[2]));
		// Modlist
		b.addByte(this.conf.modList.length);
		for (mod in this.conf.modList) {
			b.addByte(mod.name.length);
			b.addString(mod.name);
			b.addByte(mod.version.length);
			b.addString(mod.version);
		}
		return b.getBytes();
	}

	public function addMod(mod:Mod) {
		this.conf.modList.push(mod);
	}
}
