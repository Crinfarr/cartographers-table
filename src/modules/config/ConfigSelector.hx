package modules.config;

import haxe.ui.containers.dialogs.SaveFileDialog;
import modules.helpers.Bitmask;
import sys.io.File;
import haxe.io.Bytes;
import sys.io.FileInput;
import haxe.ui.containers.dialogs.OpenFileDialog;

class ConfigSelector {
    // public static final configs:Map<String, Bitmask<ConfigOpts>> = [];

    public static function open(rootpath:String, cb:ConfigInst->Void) {
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
            cb(ConfigInst.create(File.read(dialog.selectedFiles[0].fullPath)));
        }
    }
    public static function create(rootpath:String, cb:ConfigInst->Void) {
        final dialog = new SaveFileDialog({
            writeAsBinary: true,
            extensions: [
                {
                    extension: "ctpmeta",
                    label: "Cartographer Pack Metadata"
                }
            ],
        });
    }
}