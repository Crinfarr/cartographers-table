package views;

import sys.io.File;
import haxe.ui.containers.dialogs.Dialog;
import haxe.Exception;
import haxe.ui.containers.VBox;
import haxe.ui.events.MenuEvent;
import modules.config.ConfigSelector;
import views.dialogs.ErrorDialog;


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
                ConfigSelector.create((conf) -> {
                    Main.conf = conf;
                    final saver = File.write()
                });
            case "open-opt":
                ConfigSelector.open((conf) -> {
                    Main.conf = conf;
                });

            case "export-opt":
                
            case "testthrow":
                ErrorDialog.fromException(new Exception("Can't do whatever you're doing rn"));
            default:
                throw new Exception("Unknown menu item selected");
        }
    }
}
