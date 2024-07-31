package modules;

import sys.thread.Lock;
import haxe.io.Bytes;
import haxe.Timer;
import haxe.Exception;
import haxe.Resource;
import haxe.macro.Compiler;
import sys.io.File;
import haxe.display.Display.Package;
import eval.luv.File.FileSymlinkFlag;
import sys.io.FileSeek;
import sys.FileSystem;

class GameDumper {
    private final instPath:String;
    private var isInjected:Bool = false;
    public function new(instPath:String) {
        this.instPath = instPath;
    }
    public function injectMod() {
		if (FileSystem.exists('$instPath/mods') && FileSystem.isDirectory('$instPath/mods')) {
			File.saveBytes('$instPath/mods/cartographersmod.jar', Resource.getBytes('modjar'));
            isInjected = true;
		} else {
            trace(instPath);
            if (!FileSystem.exists('$instPath/mods'))
                throw new Exception('Mods folder `$instPath/mods` does not exist');
            if (!FileSystem.isDirectory('$instPath/mods'))
                throw new Exception('$instPath/mods is not a directory');
        }
    }
    public function removeMod() {
        if (!isInjected) return;
        FileSystem.deleteFile('$instPath/mods/cartographersmod.jar');
        isInjected = false;
    }
    public function waitForDump(tick:()->Void) {
		while (!FileSystem.exists('$instPath/cartographyMap.dump')) {
            tick();
        }
        while (FileSystem.stat('$instPath/cartographyMap.dump').size <= 1000) {
            tick();
        }
    }
    public function getDump():Array<String> {
        if (!FileSystem.exists('$instPath/cartographyMap.dump')) throw new Exception('Cannot parse nonexistent dump');
        final ipt = File.read('$instPath/cartographyMap.dump');
        final ret = [];
        try {
            while (true) {
                ret.push(ipt.read(ipt.readByte()).toString());
            }
        } catch (e) {
            if (e.message != "Eof")
                throw e
            else {
				trace('EoF: ${ipt.eof()}');
                ipt.close();
				return ret;
            }
        }
    }
}