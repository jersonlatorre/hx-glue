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
	
	@:allow(glue.assets.GLoader.handleFileComplete)
	static function addSound(id:String, sound:Sound, group:String)
	{
		var soundInfo = { sound: sound, channel: null, group: group };
		sound.play(0, 0, new SoundTransform(0));
		_sounds.set(id, soundInfo);
	}

	static public  function play(id:String, times:Int = 1)
	{
		if (times == 0) times = 999999999;
		_sounds.get(id).channel = _sounds.get(id).sound.play(0, times);
	}

	static public function loop(id:String)
	{
		_sounds.get(id).channel = _sounds.get(id).sound.play(0, 0x7FFFFFFF);
	}
	
	static public function stop(id:String)
	{
		if (_sounds.get(id).channel != null) _sounds.get(id).channel.stop();
	}

	static public function stopAll()
	{
		for (sound in _sounds)
		{
			if (sound.channel != null) sound.channel.stop();
		}
	}

	static public function muteAll()
	{
		for (sound in _sounds)
		{
			if (sound.channel != null) sound.channel.soundTransform = new SoundTransform(0);
		}
	}

	static public function unmuteAll()
	{
		for (sound in _sounds)
		{
			if (sound.channel != null) sound.channel.soundTransform = new SoundTransform(1);
		}
	}
}
