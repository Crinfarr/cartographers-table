package ;

import modules.config.ConfigInst;
import modules.Registry;
import modules.Item;
import haxe.ui.HaxeUIApp;
import views.MainView;
import haxe.io.Bytes;


class Main {
	public static var app:HaxeUIApp;
    public static var ItemRegistry = new Registry<Item>();
    public static var TextureRegistry = new Registry<Registry<Bytes>>();
	public static var conf:ConfigInst;
    static function main() {
		app = new HaxeUIApp();
        app.ready(() -> {
            app.title = 'Cartographer\'s Table';
            app.addComponent(new MainView());
        });
        app.start();
    }
}