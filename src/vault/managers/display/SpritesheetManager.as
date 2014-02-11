package vault.managers.display
{
	import com.greensock.TweenNano;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import vault.dataObjects.SpritesheetLoaderDO;
	import vault.dataObjects.SpritesheetObjectDO;
	import vault.utils.JSONLoader;
	
	[Event(name="COMPLETE", type="flash.events.Event")]
	
	public class SpritesheetManager extends EventDispatcher
	{		
		private static var _instance:SpritesheetManager;
		
		private static var _spritesheetLoaders:Vector.<SpritesheetLoaderDO>;
		private static var _currentSpritesheetLoader:SpritesheetLoaderDO;
		private static var _spritesheetLoadersCompleted:Vector.<SpritesheetLoaderDO>;
		
		private static var _asynchronousDelay:Number;
		private static var _baseLoc:String;
		
		public function SpritesheetManager(s:Singleton)
		{
			if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );
		}
		
		public static function init( spritesheetXMLList:XMLList = null, baseLoc:String = "" ):void
		{
			trace( "[ SpritesheetManager ] init" );
			if( !_instance )
				_instance = new SpritesheetManager( new Singleton() );
			
			_baseLoc = baseLoc;
			
			for each( var spritesheetLoader:SpritesheetLoaderDO in _spritesheetLoadersCompleted )
				spritesheetLoader.purge();
			
			_spritesheetLoaders = new Vector.<SpritesheetLoaderDO>;
			_spritesheetLoadersCompleted = new Vector.<SpritesheetLoaderDO>;
			
			if( spritesheetXMLList ) addSpritesheets( spritesheetXMLList );
		}
		
		public static function addSpritesheets( spritesheetXMLList:XMLList ):void
		{
			for each( var spritesheetXML:XML in spritesheetXMLList )
			{
				if( spritesheetExists( spritesheetXML.@name ) )
					trace( "[ SpritesheetManager ] Spritesheet " + spritesheetXML.@name + " already loaded" );
				else
				{
					_spritesheetLoaders.push( new SpritesheetLoaderDO(
						spritesheetXML.@name,
						new URLRequest( _baseLoc + spritesheetXML.img.@loc ),
						new URLRequest( _baseLoc + spritesheetXML.json.@loc )
					) );
				}
			}
		}
		
		private static function spritesheetExists( name:String ):SpritesheetLoaderDO
		{
			var spritesheet:SpritesheetLoaderDO;
			for each( var spritesheetLoader:SpritesheetLoaderDO in _spritesheetLoadersCompleted ) 
			{
				if( spritesheetLoader.name == name ) spritesheet = spritesheetLoader;
			}
			return spritesheet;
		}
		
		public static function load( asynchronousDelay:Number = 0 ):void
		{
			trace( "[ SpritesheetManager ] load" );
			
			_asynchronousDelay = asynchronousDelay;
			
			if( !_spritesheetLoaders.length )
				_instance.dispatchEvent( new Event( Event.COMPLETE ) );
			else
				TweenNano.delayedCall( _asynchronousDelay, loadNextSpritesheet );
			
			/*for each( var spritesheetLoader:SpritesheetLoaderDO in _spritesheetLoaders ) 
			{
				spritesheetLoader.imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
				spritesheetLoader.imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoadComplete, false, 0, true);
				spritesheetLoader.imgLoader.load( spritesheetLoader.imgUrlRequest );
			}*/			
		}
		
		private static function loadNextSpritesheet():void
		{
			_currentSpritesheetLoader = _spritesheetLoaders.pop();
			_currentSpritesheetLoader.imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
			_currentSpritesheetLoader.imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoadComplete, false, 0, true);
			_currentSpritesheetLoader.imgLoader.load( _currentSpritesheetLoader.imgUrlRequest );
		}
		
		protected static function onImgLoadComplete(event:Event):void
		{
			trace( "[ SpritesheetManager ] onImgLoadComplete" );
			//var spritesheetLoader:SpritesheetLoaderDO = SpritesheetLoaderDO( LoaderInfo( event.currentTarget ).loader.metaData );
			_currentSpritesheetLoader = SpritesheetLoaderDO( LoaderInfo( event.currentTarget ).loader.metaData );
			_currentSpritesheetLoader.imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
			_currentSpritesheetLoader.imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImgLoadComplete, false);
			
			_currentSpritesheetLoader.jsonLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
			_currentSpritesheetLoader.jsonLoader.addEventListener(Event.COMPLETE, onJsonLoadComplete, false, 0, true);
			_currentSpritesheetLoader.jsonLoader.load( _currentSpritesheetLoader.jsonUrlRequest );
		}
		
		protected static function onJsonLoadComplete(event:Event):void
		{
			trace( "[ SpritesheetManager ] onJsonLoadComplete" );
			//var spritesheetLoader:SpritesheetLoaderDO = SpritesheetLoaderDO( JSONLoader( event.currentTarget ).metaData );
			_currentSpritesheetLoader = SpritesheetLoaderDO( JSONLoader( event.currentTarget ).metaData );
			_currentSpritesheetLoader.jsonLoader.removeEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
			_currentSpritesheetLoader.jsonLoader.removeEventListener(Event.COMPLETE, onImgLoadComplete, false);
			
			_spritesheetLoadersCompleted.push( _currentSpritesheetLoader );
			/*_spritesheetLoadersCompleted.push(
				_spritesheetLoaders.splice( _spritesheetLoaders.indexOf( spritesheetLoader ), 1 )[ 0 ]
			);*/
			
			if( !_spritesheetLoaders.length )
				_instance.dispatchEvent( new Event( Event.COMPLETE ) );
			else
				TweenNano.delayedCall( _asynchronousDelay, loadNextSpritesheet );
		}
		
		public static function getObjectByName( spritesheetName:String, name:String, powTwo:Boolean = false, transparent:Boolean = true, cache:Boolean = true, generateMipMaps:Boolean = true ):SpritesheetObjectDO
		{
			trace( "[ SpritesheetManager ] getObjectByName - " + spritesheetName + " - " + name );
			var spritesheet:SpritesheetLoaderDO = spritesheetExists( spritesheetName );
			if( spritesheet )
				return spritesheet.getObject( name, powTwo, transparent, cache, generateMipMaps );
			else
				throw new Error( "A spritesheet object with the name '" + spritesheetName + "' does not exist" );
		}
		
		public static function getRandomObject( spritesheetName:String, powTwo:Boolean = false, transparent:Boolean = true, cache:Boolean = true, generateMipMaps:Boolean = true ):SpritesheetObjectDO
		{
			trace( "[ SpritesheetManager ] getRandomObject - " + spritesheetName + " - " + "random" );
			var spritesheet:SpritesheetLoaderDO = spritesheetExists( spritesheetName );
			if( spritesheet )
				return spritesheet.getObject( "random", powTwo, transparent, cache, generateMipMaps );
			else
				throw new Error( "A spritesheet object with the name '" + spritesheetName + "' does not exist" );
		}
		
		public static function killSpritesheet( spritesheetName:String ):void
		{
			trace( "[ SpritesheetManager ] killSpritesheet - " + spritesheetName );
			var spritesheet:SpritesheetLoaderDO = spritesheetExists( spritesheetName );
			if( spritesheet )
			{
				spritesheet.purge();
				_spritesheetLoadersCompleted.splice( _spritesheetLoadersCompleted.indexOf( spritesheet ), 1 );
			}
			else
				throw new Error( "A spritesheet object with the name '" + spritesheetName + "' does not exist" );
		}
		
		public static function killAll():int
		{
			trace( "[ SpritesheetManager ] killAll" );
			var counter:int = 0;
			for each( var spritesheetLoader:SpritesheetLoaderDO in _spritesheetLoadersCompleted )
			{
				spritesheetLoader.purge();
				counter++;
			}
			_spritesheetLoadersCompleted = new Vector.<SpritesheetLoaderDO>;
			return counter;
		}
		
		public static function getInstance():SpritesheetManager
		{
			return _instance;
		}
	}
}

class Singleton{}