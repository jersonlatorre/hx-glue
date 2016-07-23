package com.glue.data;

import haxe.Json;
import openfl.Assets;
import openfl.display.Loader;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

/**
 * ...
 * @author uno
 */

class GDataManager
{
	static var _callback:Dynamic;
	static var _currentFileIndex:Int = 0;
	static var _files:Array<Dynamic> = new Array<Dynamic>();
	static var _datas:Map<String, Dynamic> = new Map<String, Dynamic>();
	
	static var _embeddedData:Map<String, Dynamic> = new Map<String, Dynamic>();
	
	static public function addFile(url:String, id:String):Void
	{
		if (GEngine.isEmbedded)
		{
			try
			{
				#if flash
				var data:String = Assets.getBytes(url).toString();
				#else
				var data:String = Assets.getText(url);
				#end
				
				_embeddedData.set(id, data);
			}
			catch (e:Error)
			{
				trace("GAssetsManager :: La codificación JSON no está en UTF8");
			}
		}
		else
		{
			var loader:URLLoader = new URLLoader();
			_files.push( { id: id, url: url, loader:loader } );
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
			_files[_currentFileIndex - 1].loader.removeEventListener(Event.COMPLETE, downloadFile);
			_files[_currentFileIndex - 1].loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			var data = _files[_currentFileIndex - 1].loader.data;
			_datas.set(_files[_currentFileIndex - 1].id, data);
		}
		
		if (_currentFileIndex == _files.length)
		{
			onLoadComplete();
			return;
		}
		
		trace("\t data: " + _files[_currentFileIndex].id);
		
		_files[_currentFileIndex].loader.load(new URLRequest(_files[_currentFileIndex].url));
		_files[_currentFileIndex].loader.addEventListener(Event.COMPLETE, downloadFile);
		_files[_currentFileIndex].loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		
		GLoaderManager.downladedFiles++;
		
		_currentFileIndex++;
	}
	
	static function onError(e:IOErrorEvent)
	{
		trace("Error Downloading " + _files[_currentFileIndex - 1].id);
	}
	
	static function onLoadComplete():Void 
	{
		_callback();
	}
	
	static public function getJson(id:String):Dynamic
	{
		if (GEngine.isEmbedded)
		{
			if(_embeddedData.exists(id))
			{
				try
				{
					return Json.parse(_embeddedData.get(id));
				}
				catch (e:Error)
				{
					trace(e.message);
				}
			}
			else
			{
				throw "Data id: " + id + " not found";
			}
			
			return null;
		}
		else
		{
			if(_datas.exists(id))
			{
				var data:Dynamic = _datas.get(id);
				
				try
				{
					var data:String = data.toString();
					return Json.parse(data);
				}
				catch (e:Error)
				{
					trace("La codificación JSON no está en UTF8");
				}
			}
			else
			{
				throw "Data id: " + id + " not found";
			}
			
			return null;
		}
	}
	
	static public function getText(id:String):Dynamic
	{
		if (GEngine.isEmbedded)
		{
			if(_embeddedData.exists(id))
			{
				return Std.string(_embeddedData.get(id));
			}
			else
			{
				throw "Data id: " + id + " not found";
			}
			
			return null;
		}
		else
		{
			if(_datas.exists(id))
			{
				var data:Dynamic = _datas.get(id);
				
				try
				{
					var data:String = data.toString();
					return data;
				}
				catch (e:Error)
				{
					trace("La codificación JSON no está en UTF8");
				}
			}
			else
			{
				throw "Data id: " + id + " not found";
			}
			
			return null;
		}
	}
}