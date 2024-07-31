package ;

import modules.Registry;
import modules.Item;
import haxe.ui.HaxeUIApp;
import views.MainView;


class Main {
	public static var app:HaxeUIApp;
    public static var ItemRegistry = new Registry<Item>();
    static function main() {
		app = new HaxeUIApp();
        app.ready(() -> {
            app.title = 'Cartographer\'s Table';
            app.addComponent(new MainView());
        });
        app.start();
    }
}