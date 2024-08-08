package modules.config;

import haxe.Exception;
import haxe.io.Path;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.containers.dialogs.SaveFileDialog;
import sys.FileSystem;
import sys.io.File;
import views.dialogs.ErrorDialog;

class ConfigSelector {
    public static function open(cb:ConfigInst->Void) {
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
        dialog.onDialogClosed = _event -> {
            if (_event.button.toString() == "{{cancel}}")
                return;
            Main.conf = ConfigInst.create(File.read(dialog.selectedFiles[0].fullPath));
            cb(Main.conf);
        }
		dialog.show();
    }
    public static function create(cb:ConfigInst->Void) {
        final dialog = new SaveFileDialog({
            writeAsBinary: true,
            title: "Create Pack Metadata",
            extensions: [
                {
                    extension: "ctpmeta",
                    label: "Cartographer Pack Metadata"
                }
            ],
        });
        dialog.onDialogClosed = _event -> {
			if (_event.button.toString() == "{{cancel}}")
				return;
			final mcfolder = Path.directory(dialog.fullPath);
            if (!FileSystem.exists('$mcfolder/mods') || !FileSystem.isDirectory('$mcfolder/mods')) {
                ErrorDialog.fromException(new Exception("Could not locate mods folder"));
                return;
            }
            Main.conf = ConfigInst.createDefault(mcfolder);
			File.saveBytes('${dialog.fullPath}.ctpmeta', Main.conf.toBytes());
			cb(Main.conf);
        }
        dialog.show();
    }
}