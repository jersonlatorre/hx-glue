package glue.display;

/**
 * Group for automatic management of collections
 * Simplifies common patterns like collision detection and cleanup
 */
class Group<T:Entity>
{
	final entities:Array<T> = [];
	final scene:glue.scene.ViewBase;
	final layerName:String;

	public var length(get, never):Int;

	public function new(scene:glue.scene.ViewBase, layerName:String = "default")
	{
		this.scene = scene;
		this.layerName = layerName;
	}

	public function add(entity:T):T
	{
		entities.push(entity);
		scene.add(entity, layerName);
		return entity;
	}

	public function remove(entity:T):T
	{
		var index = entities.indexOf(entity);
		if (index >= 0)
		{
			entities.splice(index, 1);
			scene.remove(entity);
		}
		return entity;
	}

	public function destroy(entity:T):Void
	{
		remove(entity);
		entity.destroy();
	}

	public function cleanup():Void
	{
		var i = entities.length - 1;
		while (i >= 0)
		{
			if (entities[i].destroyed)
			{
				entities.splice(i, 1);
			}
			i--;
		}
	}

	public function forEach(callback:T->Void):Void
	{
		for (entity in entities)
		{
			callback(entity);
		}
	}

	public function filter(predicate:T->Bool):Array<T>
	{
		return entities.filter(predicate);
	}

	public function find(predicate:T->Bool):Null<T>
	{
		for (entity in entities)
		{
			if (predicate(entity))
			{
				return entity;
			}
		}
		return null;
	}

	public function collidesWith(other:Entity):Null<T>
	{
		for (entity in entities)
		{
			if (entity.collideWith(other))
			{
				return entity;
			}
		}
		return null;
	}

	public function collidesWithGroup<U:Entity>(other:Group<U>, callback:T->U->Void):Void
	{
		for (entity in entities)
		{
			for (otherEntity in other.entities)
			{
				if (entity.collideWith(otherEntity))
				{
					callback(entity, otherEntity);
				}
			}
		}
	}

	public function clear():Void
	{
		while (entities.length > 0)
		{
			var entity = entities.pop();
			scene.remove(entity);
			entity.destroy();
		}
	}

	public function get(index:Int):T
	{
		return entities[index];
	}

	inline function get_length():Int
	{
		return entities.length;
	}

	public function iterator():Iterator<T>
	{
		return entities.iterator();
	}
}
