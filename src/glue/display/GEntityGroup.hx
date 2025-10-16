package glue.display;

/**
 * Entity group for automatic management of collections
 * Simplifies common patterns like collision detection and cleanup
 */
class GEntityGroup<T:GEntity>
{
	final entities:Array<T> = [];
	final scene:glue.scene.GViewBase;
	final layerName:String;

	public var length(get, never):Int;

	public function new(scene:glue.scene.GViewBase, layerName:String = "default")
	{
		this.scene = scene;
		this.layerName = layerName;
	}

	// Add entity to group
	public function add(entity:T):T
	{
		entities.push(entity);
		scene.add(entity, layerName);
		return entity;
	}

	// Remove entity from group
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

	// Remove and destroy entity
	public function destroy(entity:T):Void
	{
		remove(entity);
		entity.destroy();
	}

	// Automatically cleanup destroyed entities
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

	// Iterate all entities
	public function forEach(callback:T->Void):Void
	{
		for (entity in entities)
		{
			callback(entity);
		}
	}

	// Filter entities by condition
	public function filter(predicate:T->Bool):Array<T>
	{
		return entities.filter(predicate);
	}

	// Find first matching entity
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

	// Check collision with another entity
	public function collidesWith(other:GEntity):Null<T>
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

	// Check collision between groups
	public function collidesWithGroup<U:GEntity>(other:GEntityGroup<U>, callback:T->U->Void):Void
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

	// Clear all entities
	public function clear():Void
	{
		while (entities.length > 0)
		{
			var entity = entities.pop();
			scene.remove(entity);
			entity.destroy();
		}
	}

	// Array access
	public function get(index:Int):T
	{
		return entities[index];
	}

	inline function get_length():Int
	{
		return entities.length;
	}

	// Iterator support
	public function iterator():Iterator<T>
	{
		return entities.iterator();
	}
}
