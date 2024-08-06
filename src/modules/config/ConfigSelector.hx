package modules.config;

import haxe.io.Path;
import haxe.zip.Uncompress;
import haxe.zip.Compress;
import haxe.ui.containers.dialogs.SaveFileDialog;
import modules.helpers.Bitmask;
import sys.io.File;
import haxe.io.Bytes;
import sys.io.FileInput;
import haxe.ui.containers.dialogs.OpenFileDialog;

class ConfigSelector {
    public static function open(rootpath:String, cb:ConfigInst->Void) {
        final dialog = new OpenFileDialog({
            readAsBinary: true,
            readContents: false,
            title: "Pack Metadata location",
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
        dialog.onDialogClosed = _event -> {
            Main.conf = ConfigInst.createDefault(Path.directory(dialog.fullPath));
        }
    }
}