package ;

import haxe.ui.HaxeUIApp;
import views.MainView;

class Main {
	public static var app:HaxeUIApp;

    static function main() {
		app = new HaxeUIApp();
        app.ready(() -> {
            app.title = 'Cartographer\'s Table';
            app.addComponent(new MainView());
        });
        app.start();
    }
}