package modules.helpers;

import haxe.io.BytesBuffer;
import haxe.io.Bytes;
import haxe.io.Input;

class ByteStream extends Input {
    private final _bytes:Bytes;
    private var _idx:Int = 0;
    public function new(ibytes:Bytes) {
        this._bytes = ibytes;
    }
    override function read(nbytes:Int):Bytes {
        final r = this._bytes.sub(_idx, nbytes);
        this._idx += nbytes;
        return r;
    }
    override function readByte():Int {
        return read(1).get(1);
    }
    override function readAll(?bufsize:Int):Bytes {
        return super.readAll(bufsize);
    }
    override function readUntil(end:Int):String {
        final r = new BytesBuffer();
        var lb:Int;
        do {
            lb = this.readByte();
            r.addByte(lb);
        } while (lb != end);
        return r.getBytes().toString();
    }
    override function close() {
        throw 'Not a real stream, cannot close';
    }
}