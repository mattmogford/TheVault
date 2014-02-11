package vault.utils
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class JSONLoader extends URLLoader
	{
		private var _metaData:Object;
		
		public function JSONLoader(request:URLRequest=null)
		{
			super(request);
		}

		public function get metaData():Object
		{
			return _metaData;
		}

		public function set metaData(value:Object):void
		{
			_metaData = value;
		}
	}
}