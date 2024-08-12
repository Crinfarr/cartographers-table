package views;

import haxe.io.Bytes;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.containers.dialogs.Dialogs;
import modules.GameDumper;
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
					trace("Created new config");
					final d = new GameDumper(conf.conf.packLoc);
					final msg = Dialogs.messageBox("Injected Cartographer. Please launch the modpack to the main menu, then exit.", "Awaiting item dump",
						MessageBoxType.TYPE_INFO, true, null);
                    msg.buttons = null;
                    msg.closable = false;
                    // msg.showDialog();
					d.injectMod();
					d.waitForDump(() -> {});
                    d.removeMod();
                    for (item in d.getDump()) {
                        //TODO texture logic
                        conf.addItem(item, Bytes.ofHex('00'));
                    }
				});
			case "open-opt":
				ConfigSelector.open((conf) -> {
					trace("Opened config");
				});
			case "export-opt":

			case "testthrow":
				ErrorDialog.fromException(new Exception("Can't do whatever you're doing rn"));
			default:
				throw new Exception("Unknown menu item selected");
		}
	}
}
