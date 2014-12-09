package vault.managers.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import vault.dataObjects.SWFLoaderDO;

	[Event(name="COMPLETE", type="flash.events.Event")]
	
	public class SWFAssetsManager extends EventDispatcher
	{		
		private static var _instance:SWFAssetsManager;
		
		private static var _swfLoaders:Vector.<SWFLoaderDO>;
		private static var _swfLoadersCompleted:Vector.<SWFLoaderDO>;
		
		private static var _baseLoc:String;
		
		public function SWFAssetsManager(s:Singleton)
		{
			if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );
		}
		
		public static function init( swfXMLList:XMLList, baseLoc:String = "" ):void
		{
			trace( "[ SWFAssetsManager ] init" );
			if( !_instance )
			{
				_instance = new SWFAssetsManager( new Singleton() );
				
				_baseLoc = baseLoc;
				
				_swfLoaders = new Vector.<SWFLoaderDO>;
				_swfLoadersCompleted = new Vector.<SWFLoaderDO>;
					
				for each( var swfXML:XML in swfXMLList )
				{
					_swfLoaders.push( new SWFLoaderDO(
						new URLRequest( _baseLoc + swfXML.@loc )
					) );
				}
			}
		}
		
		public static function load():void
		{
			trace( "[ SWFAssetsManager ] load" );
			if( !_swfLoaders.length )
			{
				_instance.dispatchEvent( new Event( Event.COMPLETE ) );
				return;
			}
			
			for each( var swfLoader:SWFLoaderDO in _swfLoaders ) 
			{
				swfLoader.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
				swfLoader.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
				var _lc:LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain, null );
				swfLoader.loader.load( swfLoader.urlRequest, _lc );
			}
		}
		
		protected static function onLoadComplete(event:Event):void
		{
			trace( "[ SWFAssetsManager ] onLoadComplete" );
			var loader:Loader = LoaderInfo( event.currentTarget ).loader;
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete, false);
			
			for( var i:int = 0; i < _swfLoaders.length; i++ ) 
			{
				if( loader === _swfLoaders[ i ].loader )
				{
					_swfLoadersCompleted.push(
						_swfLoaders.splice( _swfLoaders.indexOf( _swfLoaders[ i ] ), 1 )[ 0 ]
					);
				}
			}
			
			if( !_swfLoaders.length )
				_instance.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public static function getMC( assetsName:String, name:String ):MovieClip
		{
			trace( "[ SWFAssetsManager ] getMC - " + assetsName + " - " + name );
			var assetsSwf:ApplicationDomain;
			for each( var swfLoader:SWFLoaderDO in _swfLoadersCompleted ) 
			{
				if( swfLoader.name == assetsName ) assetsSwf = swfLoader.assetsSwf;
			}
			
			var C:Class = assetsSwf.getDefinition( name ) as Class;
			return new C as MovieClip;
		}
		
		public static function getBitmap( assetsName:String, name:String ):Bitmap
		{
			trace( "[ SWFAssetsManager ] getBitmap - " + assetsName + " - " + name );
			var assetsSwf:ApplicationDomain;
			for each( var swfLoader:SWFLoaderDO in _swfLoadersCompleted ) 
			{
				if( swfLoader.name == assetsName ) assetsSwf = swfLoader.assetsSwf;
			}
			
			var v:Vector.<String> = assetsSwf.getQualifiedDefinitionNames();
			
			var C:Class = assetsSwf.getDefinition( name ) as Class;
			var mc:MovieClip = new C as MovieClip;
			var bmd:BitmapData = new BitmapData( mc.width, mc.height, true, 0 );
			bmd.draw( mc );
			return new Bitmap( bmd );
		}
		
		public static function getInstance():SWFAssetsManager
		{
			return _instance;
		}
	}
}

class Singleton{}