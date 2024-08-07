package ;

#if test_jar_reader
import modules.ModReader;
import modules.Registry;
#end
#if test_dumper
import haxe.Timer;
import modules.GameDumper;
#end
#if test_mod_list
import modules.config.ConfigInst;
#end
class Test {
    static function main() {
        #if test_jar_reader
        final itemRegistry = new Registry<String>();
		final testreader = new ModReader('/home/crinfarr/Downloads/packmods/Botania-1.20.1-445-FORGE.jar');
        #end
        #if test_dumper
        final dumper = new GameDumper('/home/crinfarr/.local/share/multimc/instances/modpack/.minecraft');
        trace("Injecting mod");
        dumper.injectMod();
        var tickcount = 0;
        var lastStamp = Timer.stamp();
        dumper.waitForDump(() -> {
            Sys.print('Waiting for dump... [${++tickcount}] {${Timer.stamp()-lastStamp}}\r');
            lastStamp = Timer.stamp();
        });
        trace("Dump found");
        trace("Removing mod");
		dumper.removeMod();
        trace("Dump:");
		trace(dumper.getDump());
        #end
        #if test_mod_list
        final modlist = ConfigInst.createDefault('/home/crinfarr/.local/share/multimc/instances/modpack/.minecraft');
        trace(modlist);
        #end
    }
}