package com.glue.data;
import com.glue.data.GDataManager;
import com.glue.data.GImageManager;
import flash.events.Event;

/**
 * ...
 * @author uno
 *
 */

class GLoaderManager
{
	static var _callback:Dynamic;
	
	static public var totalFiles:Int = 0;
	static public var downladedFiles:Int = 0;
	
	static public function addImage(url:String, id:String):Void
	{
		GImageManager.addFile(url, id);
		totalFiles++;
	}
	
	static public function addData(url:String, id:String):Void
	{
		GDataManager.addFile(url, id);
		totalFiles++;
	}
	
	static public function addSound(url:String, id:String, groupName:String = "default"):Void
	{
		GSoundManager.addFile(url, id, groupName);
		totalFiles++;
	}
	
	static public function startDownload(callback:Dynamic):Void
	{
		trace("[ start download... ]");
		_callback = callback;
		
		GImageManager.startDownload(onAssetsLoaderEnd);
	}
	
	static function onAssetsLoaderEnd():Void 
	{
		GDataManager.startDownload(onDataLoaderEnd);
	}
	
	static function onDataLoaderEnd():Void 
	{
		GSoundManager.startDownload(onSoundsLoaderEnd);
	}
	
	static function onSoundsLoaderEnd():Void 
	{
		trace("[ ...finish download ]");
		_callback();
	}
}
