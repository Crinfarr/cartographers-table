package modules;

import sys.io.File;
import haxe.io.Bytes;
import sys.io.FileInput;
import haxe.ui.containers.dialogs.OpenFileDialog;

private typedef Config = {
    
}

class ConfigSelector {
    private static function decodeFile(ipt:FileInput):Config {
        throw new haxe.exceptions.NotImplementedException();
    }
    public static function decodeBytes(configbytes:Bytes):Config {
        throw new haxe.exceptions.NotImplementedException();
    }

    public static function open(rootpath:String, cb:Config->Void) {
        final dialog = new OpenFileDialog({
            readAsBinary: true,
            readContents: false,
            extensions: [
                {
                    extension: "ctpmeta",
                    label: "Cartographer Pack Metadata"
                }
            ],
        });
        dialog.show();
        dialog.onDialogClosed = _event -> {
            cb(decodeBytes(dialog.selectedFiles[0].bytes));
        }
    }
}