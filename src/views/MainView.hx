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
	private var packfilemeta:FileOutput;

	private inline static final header = "0x433100005A534D50";
	private static inline final ver:String = Compiler.getDefine("version");

    private var modsPath:String;

    override public function new() {
		super();
	}

	@:bind(topbar, MenuEvent.MENU_SELECTED)
	private function handleFileMenu(_e:haxe.ui.events.MenuEvent) {
        trace(_e.menuItem.id);
		switch (_e.menuItem.id) {
			case 'new-opt':
                trace('New clicked');
				final sfd = new SaveFileDialog({
					writeAsBinary: true,
					title: ".packmeta",
					extensions: [
						{
							extension: "zsmp",
							label: "ZenScript Modpack"
						}
					]
				});
				sfd.onDialogClosed = (_e) -> {
					this.packfilemeta = File.write(sfd.fullPath);
					this.packfilemeta.write(Bytes.ofHex(header));
				}
				sfd.show();
			case 'open-opt':
                trace('Open clicked');
				final ofd = new OpenFileDialog({
					readAsBinary: true,
					title: ".packmeta",
					multiple: false,
					extensions: [
						{
							extension: "zsmp",
							label: "ZenScript Modpack"
						}
					],
				});
				ofd.onDialogClosed = (_e) -> {
					final rstream = File.read(ofd.selectedFiles[0].fullPath);
                    final ver = readHeader(rstream);
                    if (ver == null)
                        throw new Exception("Invalid modpack data file");
                        //TODO anything other than throwing
					Main.app.title = '${Main.app.title} ${ver}';
				}
				ofd.show();
			default:
				throw new Exception("Could not parse MenuEvent");
		}
	}

	/**
	 * @param ipt input file stream
	 * @return Int -1 if invalid file, else version of the file
	 */
	private static function readHeader(ipt:FileInput, seekToPos:Int=0x09):Null<String> {
		ipt.seek(0, SeekBegin);
		if (ipt.readString(2) != "C1")
			return null;
		final filever = [ipt.readByte(), ipt.readByte(), ipt.readByte()];//I think 255^3 is probably enough versions
		if (ipt.readString(4) != "ZSMP")
			return null;
        if (filever.join('.') != ver)
            return null;
		ipt.seek(seekToPos, SeekBegin);//Seek past the header if unspecified
        return filever.join(".");
	}
}
