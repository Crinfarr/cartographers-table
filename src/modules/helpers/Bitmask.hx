package modules.helpers;

/**
 * Intended use is with Enums but you can technically use whatever you feel like
 */
class Bitmask<T> {
	private final mvals:Array<T>;
	private final maxval:Int;

	public function new(mask:Array<T>) {
		this.mvals = mask;
		this.maxval = 1 << mask.length;
	}

	public function mask(val:Int):Array<T> {
		if (val > maxval)
			throw 'Value $val is larger than max value $maxval';
		var returns:Array<T> = [];
		for (idx in 0...mvals.length) {
			if (val & (idx << 1) == 1)
				returns.push(mvals[idx]);
		}
		return returns;
	}
    public function getMask(vals:Array<T>):Null<Int> {
        var rv = 0;
        for (itm in vals) {
			if (!mvals.contains(itm))
				return null;
            rv |= (1<<(mvals.indexOf(itm)));
        }
        return rv;
    }
}
