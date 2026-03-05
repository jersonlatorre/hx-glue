package glue.audio;

import glue.assets.Loader;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * Simplified audio system.
 *
 * Usage:
 *   // Load in scene
 *   Glue.load.sound("jump", "assets/jump.mp3");
 *   Glue.load.sound("music", "assets/music.mp3", "music");
 *
 *   // Play
 *   Audio.play("jump");
 *   Audio.play("music", true);  // loop
 *
 *   // Control
 *   Audio.setVolume(0.5);
 *   Audio.setGroupVolume("music", 0.3);
 *   Audio.mute();
 *   Audio.stop("music");
 */
class Audio
{
	static var _channels:Map<String, SoundChannel> = new Map();
	static var _groups:Map<String, Array<String>> = new Map();
	static var _groupVolumes:Map<String, Float> = new Map();
	static var _masterVolume:Float = 1.0;
	static var _isMuted:Bool = false;
	static var _mutedVolume:Float = 1.0;

	/**
	 * Play a sound
	 * @param id Sound asset ID
	 * @param loop Whether to loop
	 * @param volume Volume (0-1)
	 * @return SoundChannel for additional control
	 */
	public static function play(id:String, loop:Bool = false, volume:Float = 1.0):SoundChannel
	{
		var sound:Sound = Loader.getSound(id);
		if (sound == null) return null;

		// Stop existing if looping
		if (loop && _channels.exists(id))
		{
			_channels.get(id).stop();
		}

		var finalVolume = volume * _masterVolume * (_isMuted ? 0 : 1);

		// Check group volume
		for (group => ids in _groups)
		{
			if (ids.indexOf(id) != -1)
			{
				var groupVol = _groupVolumes.exists(group) ? _groupVolumes.get(group) : 1.0;
				finalVolume *= groupVol;
				break;
			}
		}

		var transform = new SoundTransform(finalVolume);
		var channel = sound.play(0, loop ? 999999 : 0, transform);

		if (channel != null)
		{
			_channels.set(id, channel);
		}

		return channel;
	}

	/**
	 * Play with random pitch variation
	 */
	public static function playVaried(id:String, pitchRange:Float = 0.1, volume:Float = 1.0):SoundChannel
	{
		// Note: OpenFL doesn't support pitch, so we just play normally
		// This is a placeholder for future implementation
		return play(id, false, volume);
	}

	/**
	 * Stop a specific sound
	 */
	public static function stop(id:String):Void
	{
		if (_channels.exists(id))
		{
			_channels.get(id).stop();
			_channels.remove(id);
		}
	}

	/**
	 * Stop all sounds
	 */
	public static function stopAll():Void
	{
		for (channel in _channels)
		{
			channel.stop();
		}
		_channels.clear();
	}

	/**
	 * Pause a sound
	 */
	public static function pause(id:String):Void
	{
		if (_channels.exists(id))
		{
			var channel = _channels.get(id);
			channel.stop();
		}
	}

	/**
	 * Set master volume
	 */
	public static function setVolume(volume:Float):Void
	{
		_masterVolume = Math.max(0, Math.min(1, volume));
		updateAllVolumes();
	}

	/**
	 * Get master volume
	 */
	public static function getVolume():Float
	{
		return _masterVolume;
	}

	/**
	 * Set volume for a sound group
	 */
	public static function setGroupVolume(group:String, volume:Float):Void
	{
		_groupVolumes.set(group, Math.max(0, Math.min(1, volume)));
		updateAllVolumes();
	}

	/**
	 * Register a sound to a group
	 */
	public static function addToGroup(id:String, group:String):Void
	{
		if (!_groups.exists(group))
		{
			_groups.set(group, []);
		}
		var ids = _groups.get(group);
		if (ids.indexOf(id) == -1)
		{
			ids.push(id);
		}
	}

	/**
	 * Mute all audio
	 */
	public static function mute():Void
	{
		if (!_isMuted)
		{
			_mutedVolume = _masterVolume;
			_isMuted = true;
			updateAllVolumes();
		}
	}

	/**
	 * Unmute all audio
	 */
	public static function unmute():Void
	{
		if (_isMuted)
		{
			_isMuted = false;
			updateAllVolumes();
		}
	}

	/**
	 * Toggle mute
	 */
	public static function toggleMute():Bool
	{
		if (_isMuted)
		{
			unmute();
		}
		else
		{
			mute();
		}
		return _isMuted;
	}

	/**
	 * Check if muted
	 */
	public static var isMuted(get, never):Bool;

	static function get_isMuted():Bool
	{
		return _isMuted;
	}

	/**
	 * Fade volume over time
	 */
	public static function fade(id:String, targetVolume:Float, duration:Float):Void
	{
		if (!_channels.exists(id)) return;

		var channel = _channels.get(id);
		var startVolume = channel.soundTransform.volume;
		var elapsed:Float = 0;

		var onFrame:Dynamic->Void = null;
		onFrame = function(_)
		{
			elapsed += 1 / 60; // Approximate
			var progress = Math.min(1, elapsed / duration);
			var volume = startVolume + (targetVolume - startVolume) * progress;

			channel.soundTransform = new SoundTransform(volume);

			if (progress >= 1)
			{
				openfl.Lib.current.removeEventListener(openfl.events.Event.ENTER_FRAME, onFrame);
				if (targetVolume <= 0)
				{
					stop(id);
				}
			}
		};

		openfl.Lib.current.addEventListener(openfl.events.Event.ENTER_FRAME, onFrame);
	}

	/**
	 * Crossfade between two sounds
	 */
	public static function crossfade(fromId:String, toId:String, duration:Float):Void
	{
		fade(fromId, 0, duration);
		play(toId, true, 0);

		var elapsed:Float = 0;
		var onFrame:Dynamic->Void = null;
		onFrame = function(_)
		{
			elapsed += 1 / 60;
			var progress = Math.min(1, elapsed / duration);

			if (_channels.exists(toId))
			{
				var channel = _channels.get(toId);
				channel.soundTransform = new SoundTransform(progress * _masterVolume);
			}

			if (progress >= 1)
			{
				openfl.Lib.current.removeEventListener(openfl.events.Event.ENTER_FRAME, onFrame);
			}
		};

		openfl.Lib.current.addEventListener(openfl.events.Event.ENTER_FRAME, onFrame);
	}

	static function updateAllVolumes():Void
	{
		var effectiveVolume = _isMuted ? 0 : _masterVolume;

		for (id => channel in _channels)
		{
			var volume = effectiveVolume;

			// Apply group volume
			for (group => ids in _groups)
			{
				if (ids.indexOf(id) != -1)
				{
					var groupVol = _groupVolumes.exists(group) ? _groupVolumes.get(group) : 1.0;
					volume *= groupVol;
					break;
				}
			}

			channel.soundTransform = new SoundTransform(volume);
		}
	}
}
