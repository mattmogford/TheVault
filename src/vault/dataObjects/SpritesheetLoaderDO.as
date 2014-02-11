package vault.dataObjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import vault.utils.JSONLoader;
	
	public class SpritesheetLoaderDO
	{
		private var _name:String;
		private var _imgUrlRequest:URLRequest;
		private var _imgLoader:Loader;
		private var _jsonUrlRequest:URLRequest;
		private var _jsonLoader:JSONLoader;
		
		private var _spritesheetBMP:Bitmap;
		private var _spritesheetJSON:Object;
		
		//private var loadedSpritesheetObjects:Dictionary = new Dictionary;
		
		public function SpritesheetLoaderDO( name:String, imgU:URLRequest, jsonU:URLRequest )
		{			
			_name = name;
			
			_imgUrlRequest = imgU;
			_imgLoader = new Loader;
			_imgLoader.metaData = this;
			
			_jsonUrlRequest = jsonU;
			_jsonLoader = new JSONLoader;
			_jsonLoader.metaData = this;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get imgUrlRequest():URLRequest
		{
			return _imgUrlRequest;
		}
		
		public function get imgLoader():Loader
		{
			return _imgLoader;
		}
		
		public function get jsonUrlRequest():URLRequest
		{
			return _jsonUrlRequest;
		}
		
		public function get jsonLoader():URLLoader
		{
			return _jsonLoader;
		}
		
		public function getObject( objName:String, powTwo:Boolean = false, transparent:Boolean = true, cache:Boolean = true, generateMipMaps:Boolean = true ):SpritesheetObjectDO
		{
			if( !_spritesheetBMP ) _spritesheetBMP = Bitmap( _imgLoader.content );
			if( !_spritesheetJSON ) _spritesheetJSON = JSON.parse( jsonLoader.data as String );
			
			if( objName in _spritesheetJSON.frames )
			{			
				/*if( objName in loadedSpritesheetObjects )
					return loadedSpritesheetObjects[ objName ];
				else
				{*/
					var data:Object = _spritesheetJSON.frames[ objName ];
					var bmd:BitmapData;
					
					if( !powTwo )
						bmd = new BitmapData( data.frame.w, data.frame.h, transparent, 0 );
					else
						bmd = new BitmapData( nearest_pow( data.frame.w, true ), nearest_pow( data.frame.h, true ), transparent, 0 );
					
					var bmdRect:Rectangle = new Rectangle( data.frame.x, data.frame.y, data.frame.w, data.frame.h );
					bmd.copyPixels( 
						_spritesheetBMP.bitmapData,
						bmdRect,
						new Point( ( bmd.width >> 1 ) - ( bmdRect.width >> 1 ), bmd.height - bmdRect.height )
					);
					
					/*if( cache )
						return loadedSpritesheetObjects[ objName ] = new SpritesheetObjectDO( new Bitmap( bmd ), data, objName, generateMipMaps );
					else*/
						return new SpritesheetObjectDO( new Bitmap( bmd ), data, objName, generateMipMaps );
				//}
			}
			else
			{
				if( objName == "random" )
					return getObject( rand, powTwo, transparent, cache, generateMipMaps );
				else
					throw new Error( "A spritesheet object with the name '" + objName + "' does not exist in " + this.name );
			}
		}
		
		private function nearest_pow( the_num:int, forceUp:Boolean = false ):int
		{
			var the_log2:Number = Math.log( Math.abs( the_num ) );
			var power_amount:int;
			var closest_power:int;
			
			if( forceUp )
			{
				power_amount = Math.ceil( the_log2 * Math.LOG2E );
				closest_power = ( the_num > 0 )? Math.pow( 2, power_amount ) : -Math.pow( 2, power_amount );
			}
			else
			{			
				power_amount = Math.round( the_log2 * Math.LOG2E );
				closest_power = ( the_num > 0 )? Math.pow( 2, power_amount ) : -Math.pow( 2, power_amount );
			}			
			
			return closest_power;
		}
		
		private function get length():uint
		{				
			var len:uint = 0;
			for( var s:* in _spritesheetJSON.frames ) len++;
			return len;
		}
		
		private function get rand():*
		{				
			var randPos:uint = Math.floor( Math.random() * length );
			var len:uint = 0;
			for( var s:* in _spritesheetJSON.frames )
			{
				if( len == randPos )
					return s;
				else
					len++;
			}
		}
		
		public function purge():void
		{
			/*for each( var sso:SpritesheetObjectDO in loadedSpritesheetObjects )
				sso.bitmap.bitmapData.dispose();*/
			
			if( _imgLoader ) Bitmap( _imgLoader.content ).bitmapData.dispose();
			
			_imgUrlRequest = null;
			_imgLoader = null;
			_jsonUrlRequest = null;
			_jsonLoader = null;
			if( _spritesheetBMP ) _spritesheetBMP.bitmapData.dispose();
			_spritesheetJSON = null;
		}
	}
}