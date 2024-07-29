package ;
#if test_jar_reader
import modules.ModReader;
#end
class Test {
    static function main() {
        #if test_jar_reader
		final testreader = new ModReader('/home/crinfarr/Downloads/packmods/Botania-1.20.1-445-FORGE.jar');
        #end
    }
}