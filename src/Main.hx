package ;

import haxe.ui.HaxeUIApp;
import views.MainView;

class Main {
	public static final app:HaxeUIApp = new HaxeUIApp();

    static function main() {
        app.ready(() -> {
            app.title = 'Cartographer\'s Table';
            app.addComponent(new MainView());
        });
        app.start();
    }
}