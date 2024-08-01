package views;

import haxe.macro.Compiler;
import haxe.Json;
import sys.io.FileInput;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.io.BytesData;
import haxe.io.Bytes;
import sys.io.File;
import sys.io.FileOutput;
import haxe.ui.containers.dialogs.SaveFileDialog;
import haxe.Exception;
import haxe.ui.events.MenuEvent;
import haxe.ui.containers.VBox;


@:build(haxe.ui.ComponentBuilder.build('src/assets/views/main-view.xml'))
class MainView extends VBox {
    override public function new() {
		super();
	}

	@:bind(topbar, MenuEvent.MENU_SELECTED)
	private function handleFileMenu(_e:haxe.ui.events.MenuEvent) {
        trace(_e.menuItem.id);
        switch (_e.menuItem.id) {
            case "new-opt":
                //TODO block for file reading with modal dialog
            case "open-opt":

            default:
                throw new Exception("Unknown menu item selected");
        }
    }
}
