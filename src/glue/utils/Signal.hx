package glue.utils;

/**
 * Type-safe signal system for event handling
 * Replaces Dynamic callbacks with strongly-typed function references
 * @author Jerson La Torre
 */

/**
 * Signal with no parameters
 */
class Signal0
{
	final listeners:Array<()->Void> = [];

	public function new() {}

	public function add(listener:()->Void):Void
	{
		if (listener != null && listeners.indexOf(listener) == -1)
		{
			listeners.push(listener);
		}
	}

	public function remove(listener:()->Void):Void
	{
		listeners.remove(listener);
	}

	public function dispatch():Void
	{
		for (listener in listeners)
		{
			listener();
		}
	}

	public function clear():Void
	{
		#if (haxe_ver >= 4.2)
		listeners.resize(0);
		#else
		while (listeners.length > 0) listeners.pop();
		#end
	}

	public function hasListeners():Bool
	{
		return listeners.length > 0;
	}
}

/**
 * Signal with one parameter
 */
class Signal1<T>
{
	final listeners:Array<T->Void> = [];

	public function new() {}

	public function add(listener:T->Void):Void
	{
		if (listener != null && listeners.indexOf(listener) == -1)
		{
			listeners.push(listener);
		}
	}

	public function remove(listener:T->Void):Void
	{
		listeners.remove(listener);
	}

	public function dispatch(value:T):Void
	{
		for (listener in listeners)
		{
			listener(value);
		}
	}

	public function clear():Void
	{
		#if (haxe_ver >= 4.2)
		listeners.resize(0);
		#else
		while (listeners.length > 0) listeners.pop();
		#end
	}

	public function hasListeners():Bool
	{
		return listeners.length > 0;
	}
}

/**
 * Signal with two parameters
 */
class Signal2<T1, T2>
{
	final listeners:Array<T1->T2->Void> = [];

	public function new() {}

	public function add(listener:T1->T2->Void):Void
	{
		if (listener != null && listeners.indexOf(listener) == -1)
		{
			listeners.push(listener);
		}
	}

	public function remove(listener:T1->T2->Void):Void
	{
		listeners.remove(listener);
	}

	public function dispatch(value1:T1, value2:T2):Void
	{
		for (listener in listeners)
		{
			listener(value1, value2);
		}
	}

	public function clear():Void
	{
		#if (haxe_ver >= 4.2)
		listeners.resize(0);
		#else
		while (listeners.length > 0) listeners.pop();
		#end
	}

	public function hasListeners():Bool
	{
		return listeners.length > 0;
	}
}
