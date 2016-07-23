package com.glue.data;
import com.glue.data.GLoaderManager;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

/**
 * ...
 * @author uno
 */

class GSoundManager
{
	static var _callback:Dynamic;
	static var _currentFileIndex:Int = 0;
	static var _files:Array<Dynamic> = new Array<Dynamic>();
	static var _sounds:Map<String, Sound> = new Map<String, Sound>();
	
	static var _embededSounds:Map<String, Sound> = new Map<String, Sound>();
	
	static var _soundChannels:Map<String, SoundChannel> = new Map<String, SoundChannel>();
	static var _groups:Map<String, Array<Sound>> = new Map<String, Array<Sound>>();
	
	// pause
	// groups
	
	static public function addFile(url:String, id:String, groupName:String = "default"):Void
	{
		if (GEngine.isEmbedded)
		{
			var array:Array<Sound> = _groups.get(groupName);
			
			if (array == null)
			{
				array = new Array<Sound>();
				_groups.set(groupName, array);
			}
			
			var sound:Sound = Assets.getSound(url);
			
			array.push(sound);
			_sounds.set(id, sound);
		}
		else
		{
			var sound:Sound = new Sound();
			_files.push( { id: id, url: url, groupName: groupName, sound:sound } );
		}	
	}
	
	static public function startDownload(callback:Dynamic):Void
	{
		_callback = callback;
		
		downloadFile();
	}
	
	static function downloadFile(e:Event = null):Void 
	{	
		if (_currentFileIndex > 0)
		{
			_files[_currentFileIndex - 1].sound.removeEventListener(Event.COMPLETE, downloadFile);
			_files[_currentFileIndex - 1].sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		
			var array:Array<Sound> = _groups.get(_files[_currentFileIndex - 1].groupName);
			
			if (array == null)
			{
				array = new Array<Sound>();
				_groups.set(_files[_currentFileIndex - 1].groupName, array);
			}
			
			array.push(_files[_currentFileIndex - 1].sound);
			
			_sounds.set(_files[_currentFileIndex - 1].id, _files[_currentFileIndex - 1].sound);
		}
		
		if (_currentFileIndex == _files.length)
		{
			onLoadComplete();
			return;
		}
		
		GLoaderManager.downladedFiles++;
		_currentFileIndex++;
		
		trace("\tsound: " + _files[_currentFileIndex - 1].id);
		
		_files[_currentFileIndex - 1].sound.addEventListener(Event.COMPLETE, downloadFile);
		_files[_currentFileIndex - 1].sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_files[_currentFileIndex - 1].sound.load(new URLRequest(_files[_currentFileIndex - 1].url));
	}
	
	static function onError(e:IOErrorEvent):Void
	{
		trace("Error Downloading " + _files[_currentFileIndex - 2].id);
	}
	
	static function onLoadComplete():Void 
	{
		_callback();
	}
	
	static public function play(id:String):Void
	{
		if (_sounds.exists(id))
		{
			var soundChannel:SoundChannel = _sounds.get(id).play(0, 1);
			_soundChannels.set(id, soundChannel);
		}
		else
		{
			trace("There is no a sound with id: " + id);
		}
	}
	
	static public function loop(id:String):Void
	{
		if (_sounds.exists(id))
		{
			var soundChannel:SoundChannel = _sounds.get(id).play(0, 999999);
			_soundChannels.set(id, soundChannel);
		}
		else
		{
			trace("There is no a sound with id: " + id);
		}
	}
	
	static public function stop(id:String):Void
	{
		if (_soundChannels.exists(id))
		{
			_soundChannels.get(id).stop();
		}
	}
}