package vault.managers.data
{
	import com.greensock.loading.XMLLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import vault.dataObjects.LanguageDO;
	
	[Event(name="COMPLETE", type="flash.events.Event")]
	
	public class LanguageManager extends EventDispatcher
	{
		private static var _instance:LanguageManager;
		
		private static var _defaultLang:String;
		
		private static var _languageLoaders:Vector.<XMLLoader>;
		private static var _languageLoadersCompleted:Vector.<XMLLoader>;
		
		private static var _languages:Dictionary = new Dictionary();
		private static var _currentLanguage:LanguageDO;
		private static var _baseLoc:String;
		
		public function LanguageManager(s:Singleton)
		{
			if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );
		}
		
		public static function init( defaultLang:String = "", baseLoc:String = "" ):void
		{
			_defaultLang = defaultLang;
			_baseLoc = baseLoc;
			if( !SettingsManager.getString( "language" ) )
				SettingsManager.setString( "language", defaultLang );
		}
		
		/********************************************************/
		
		public static function loadLanguagesFromFile( langLocsXMLList:XMLList ):void
		{
			_languageLoaders = new Vector.<XMLLoader>;
			_languageLoadersCompleted = new Vector.<XMLLoader>;
			
			for( var i:int = 0; i < langLocsXMLList.*.length(); i++ )
				_languageLoaders.push( new XMLLoader( _baseLoc + langLocsXMLList.*[ i ].@loc ) );
				
			load();
		}
		
		protected static function load():void
		{
			trace( "[ LanguageManager ] load" );
			for each( var langLoader:XMLLoader in _languageLoaders ) 
			{
				langLoader.addEventListener(Event.COMPLETE, onLangLoadComplete, false, 0, true);
				langLoader.load();
			}
		}
		
		protected static function onLangLoadComplete(event:Event):void
		{
			trace( "[ LanguageManager ] onLangLoadComplete" );
			var langLoader:XMLLoader = XMLLoader( event.target );
			langLoader.removeEventListener(Event.COMPLETE, onLangLoadComplete, false );
			
			_languageLoadersCompleted.push(
				_languageLoaders.splice( _languageLoaders.indexOf( langLoader ), 1 )[ 0 ]
			);
			
			addLanguage( langLoader.content );
			
			if( !_languageLoaders.length )
			{
				/*** SET DEFAULT LANGUAGE ***/
				if( _defaultLang == "" ) language = LanguageDO( _languages[ 0 ] ).id;
				else language = _defaultLang;
				
				_instance.dispatchEvent( new Event( Event.COMPLETE ) );				
			}
		}
		
		/********************************************************/
		
		private static function addLanguage( langXML:XML ):void
		{
			var lang:LanguageDO = new LanguageDO( XML( langXML.language ) );
			if( lang.id in _languages ) throw new Error( "Duplicate language with the id '" + lang.id + "'" );
			else
			{
				trace( "[ LanguageManager ] Adding language '" + lang.id + "'" );
				_languages[ lang.id ] = lang;
			}
		}
		
		public static function set language( id:String ):void
		{
			trace( "[ LanguageManager ] Changing language '" + id + "'" );
			if( id in _languages ) _currentLanguage = _languages[ id ];
			else throw new Error( "A language with the id '" + id + "' does not exist" );
		}
		
		public static function get currentLanguage():LanguageDO
		{
			if( _currentLanguage) return _currentLanguage;
			else throw new Error( "[ LanguageManager ] No languages have been added" );
		}
		
		private static function count(o:*):int
		{
			var c:int = 0;
			for( var k:Object in o ) c++;
			return c;
		}
		
		public static function getInstance():LanguageManager
		{
			if( !_instance ) _instance = new LanguageManager( new Singleton() );
			return _instance;
		}
	}
}

class Singleton{}