package glue.assets;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * ...
 * @author Jerson La Torre
 */

typedef SoundData =
{
	sound: Sound,
	channel: SoundChannel,
	group: String
}

@:final class GSound
{
	static var _sounds:Map<String, SoundData> = new Map<String, SoundData>();
	
	@:allow(glue.assets.GLoader.handleFileComplete, glue.assets.GAssetPipeline)
	static function addSound(id:String, sound:Sound, group:String)
	{
		var soundInfo = { sound: sound, channel: null, group: group };
		sound.play(0, 0, new SoundTransform(0));
		_sounds.set(id, soundInfo);
	}

	static public function play(id:String, times:Int = 1)
	{
		var data = _sounds.get(id);
		if (data == null) throw 'Sound \'${ id }\' is not registered.';

		var loops = 0;
		if (times <= 0)
		{
			loops = 0x7FFFFFFF;
		}
		else
		{
			loops = Std.int(Math.max(0, times - 1));
		}

		data.channel = data.sound.play(0, loops);
		_sounds.set(id, data);
	}

	static public function loop(id:String)
	{
		var data = _sounds.get(id);
		if (data == null) throw 'Sound \'${ id }\' is not registered.';

		data.channel = data.sound.play(0, 0x7FFFFFFF);
		_sounds.set(id, data);
	}
	
	static public function stop(id:String)
	{
		var data = _sounds.get(id);
		if (data != null && data.channel != null)
		{
			data.channel.stop();
			data.channel = null;
			_sounds.set(id, data);
		}
	}

	static public function stopAll()
	{
		for (id in _sounds.keys())
		{
			var data = _sounds.get(id);
			if (data != null && data.channel != null)
			{
				data.channel.stop();
				data.channel = null;
				_sounds.set(id, data);
			}
		}
	}

	static public function muteAll()
	{
		for (id in _sounds.keys())
		{
			var data = _sounds.get(id);
			if (data != null && data.channel != null)
			{
				data.channel.soundTransform = new SoundTransform(0);
			}
		}
	}

	static public function unmuteAll()
	{
		for (id in _sounds.keys())
		{
			var data = _sounds.get(id);
			if (data != null && data.channel != null)
			{
				data.channel.soundTransform = new SoundTransform(1);
			}
		}
	}
}
