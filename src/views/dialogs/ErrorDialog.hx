package views.dialogs;

import haxe.ui.containers.Frame;
import haxe.Exception;
import haxe.ui.containers.dialogs.Dialog;

@:build(haxe.ui.ComponentBuilder.build('src/assets/views/dialogs/ErrorDialog.xml'))
class ErrorDialog extends Dialog {
	public function new() {
		super();
		// errorblock.collapsed = true;
		buttons = DialogButton.CLOSE;
		closable = false;
	}

	public static function fromException(exc:Exception, preExit:Null<() -> Void> = null) {
		final dia = new ErrorDialog();
		dia.errortype.text = exc.message;
		dia.moreinfo.text = exc.details();
		dia.onDialogClosed = (_) -> {
            if (preExit != null) {
                preExit();
            }
			Sys.exit(1);
		}
		dia.showDialog();
	}
}
