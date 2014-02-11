package vault.managers.data
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;

	[Event(name="COMPLETE", type="flash.events.Event")]
	
	public class SettingsManager extends EventDispatcher
	{		
		private static var _instance:SettingsManager;

		private static var _xmlLoader:XMLLoader;
		public static var xml:XML;
		private static var _sharedObject:SharedObject;
		
		public function SettingsManager(s:Singleton)
		{
			if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );
		}
		
		public static function init( loc:String ):void
		{
			if( !_instance )
			{
				_instance = new SettingsManager( new Singleton() );
				
				_xmlLoader = new XMLLoader( loc );
			}
		}
		
		public static function load():void
		{
			_xmlLoader.addEventListener( LoaderEvent.COMPLETE, onLoadComplete );
			_xmlLoader.load();
		}
		
		protected static function onLoadComplete(event:LoaderEvent):void
		{
			_xmlLoader.removeEventListener( LoaderEvent.COMPLETE, onLoadComplete );
			
			xml = XML( event.target.content );
			setupSharedObject();
			_instance.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private static function setupSharedObject():void
		{
			_sharedObject = SharedObject.getLocal( "settingsData" );
			if( _sharedObject.data[ "settings" ] == null )
			{
				var settings:Object = _sharedObject.data[ "settings" ] = new Object;
				settings[ "toggle" ] = new Object;
				settings[ "string" ] = new Object;
				
				for each( var so:XML in xml.sharedObjects.* )
					_sharedObject.data[ "settings" ][ so.@type.toString() ][ so.localName() ] = so.toString();
				
				_sharedObject.flush();
			}
		}
		
		/***********************************************************/
		
		public static function getToggle( name:String ):Boolean
		{			
			if( _sharedObject.data[ "settings" ][ "toggle" ][ name ] == "1" )
				return true;
			else
				return false;			
		}
		
		public static function setToggle( name:String, value:Boolean ):void
		{
			if( value )
				_sharedObject.data[ "settings" ][ "toggle" ][ name ] = "1";
			else
				_sharedObject.data[ "settings" ][ "toggle" ][ name ] = "0";
			
			_sharedObject.flush();
		}
		
		public static function getString( name:String ):String
		{			
			return _sharedObject.data[ "settings" ][ "string" ][ name ];
		}
		
		public static function setString( name:String, value:String ):void
		{
			_sharedObject.data[ "settings" ][ "string" ][ name ] = value;			
			_sharedObject.flush();
		}
		
		/***********************************************************/
		
		public static function getInstance():SettingsManager
		{
			return _instance;
		}
	}
}

class Singleton{}