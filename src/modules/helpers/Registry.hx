package modules.helpers;

import haxe.io.Bytes;
import haxe.Exception;

private enum CallbackType {
    ItemAdded;
    ItemRemoved;
}

class Registry<T> {
    private var callbacks:{added:Array<T->Void>, removed:Array<T->Void>} = {added:[], removed:[]}
	private var keys:{added:Array<String>, removed:Array<String>}
    private var reg:Map<String, T>;
    public var size(default, null):Int;
    public function new() {
        reg = new Map<String, T>();
    }

    public function get(key:String):Null<T> {
        return (reg.exists(key) ? reg[key] : null);
    }

    public function assign(key:String, value:T) {
        if (reg.exists(key)) throw new Exception('Cannot reassign ${key}: Current value is ${reg[key]}');
		reg.set(key, value);
        size++;
        for (cb in this.callbacks.added) {
            cb(value);
        }
    }
    public function unassign(key:String) {
        if (!reg.exists(key)) throw new Exception('Cannot unassign nonexistent key ${key}');
        for (cb in this.callbacks.removed) {
            cb(reg.get(key));
        }
		this.reg.remove(key);
        size--;
	}
    
    public function addCallback(type:CallbackType, callback:T->Void):String {
        final uuid = UUID.v4();
        switch type {
            case ItemAdded:
                this.callbacks.added.push(callback);
                this.keys.added.push(uuid);
                return uuid;
            case ItemRemoved:
                this.callbacks.removed.push(callback);
                this.keys.removed.push(uuid);
            default:
                throw new Exception("Invalid callback type");
        }
        return uuid;
    }
    public function removeCallback(type:CallbackType, key:String) {
        if (!UUID.verify(key, 4)) throw new Exception("Invalid callback key "+key);
        switch type {
            case ItemAdded:
                final idx = this.keys.added.indexOf(key);
                this.keys.added.remove(key);
                this.callbacks.added.splice(idx, 1);
            case ItemRemoved:
                final idx = this.keys.removed.indexOf(key);
                this.keys.removed.remove(key);
                this.callbacks.removed.splice(idx, 1);
            default:
                throw new Exception("Invalid callback type");
        }
    }
    public inline function keyIter():Iterator<String> {
        return this.reg.keys();
    }
    public inline function itemIter():Iterator<T> {
        return this.reg.iterator();
    }
    public inline function iterator():KeyValueIterator<String, T> {
        return this.reg.keyValueIterator();
    }
}