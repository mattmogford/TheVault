package vault.managers.data
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="COMPLETE", type="flash.events.Event")]
	[Event(name="ERROR", type="com.greensock.events.LoaderEvent")]
	[Event(name="FAIL", type="com.greensock.events.LoaderEvent")]
	
	public class XMLManager extends EventDispatcher
	{
		private var _xmlLoader:XMLLoader;
		public var xml:XML;
		
		public function XMLManager( loc:String )
		{
			_xmlLoader = new XMLLoader( loc );
		}
		
		public function load():void
		{
			_xmlLoader.addEventListener( LoaderEvent.COMPLETE, onLoadComplete );
			_xmlLoader.addEventListener( LoaderEvent.ERROR, onLoadError );
			_xmlLoader.addEventListener( LoaderEvent.FAIL, onLoadError );
			_xmlLoader.load();
		}
		
		protected function onLoadComplete(event:LoaderEvent):void
		{
			xml = XML( event.target.content );
			dispose();
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function onLoadError(event:LoaderEvent):void
		{
			dispose();
			this.dispatchEvent( event );
		}
		
		private function dispose():void
		{
			_xmlLoader.removeEventListener( LoaderEvent.COMPLETE, onLoadComplete );
			_xmlLoader.removeEventListener( LoaderEvent.ERROR, onLoadError );
			_xmlLoader.removeEventListener( LoaderEvent.FAIL, onLoadError );
			
			_xmlLoader.dispose( true );
			_xmlLoader = null;
		}
	}
}