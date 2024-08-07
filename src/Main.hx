package ;

import haxe.io.Bytes;
import haxe.ui.HaxeUIApp;
import modules.Item;
import modules.Registry;
import modules.config.ConfigInst;
import views.MainView;


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