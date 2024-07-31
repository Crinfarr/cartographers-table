package modules;

import haxe.io.Bytes;
using StringTools;

class UUID {
    public static function v4() {
        return '${
            Math.round(Math.random()*0xffffffff).hex()
        }-${
            Math.round(Math.random()*0xffff).hex()
        }-4${
            (Math.round(Math.random()*0xfff)).hex()
        }-${
            (Math.round(Math.random()*0xffff)&0x1fff).hex()
        }-${
            Math.round(Math.random()*0xffffff)}${Math.round(Math.random()*0xffffff)
        }';
    }

    private static final hexchars = "[0-9A-Fa-f]";
    public static function verify(test:String, version:Int=4) {
        final reg = new EReg('$hexchars{8}-$hexchars{4}-$version$hexchars{3}-$hexchars{4}-$hexchars{12}', "g");
        return reg.match(test);
    }
}