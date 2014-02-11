package vault.dataObjects
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	import vault.utils.StringFormat;

	public class SWFLoaderDO
	{
		private var _name:String;
		private var _urlRequest:URLRequest;
		private var _loader:Loader;
		
		public function SWFLoaderDO( u:URLRequest )
		{			
			_name = StringFormat.filename( u.url );			
			_urlRequest = u;
			_loader = new Loader;
			
			_loader.metaData = this;
		}
		
		public function get name():String
		{
			return _name;
		}

		public function get urlRequest():URLRequest
		{
			return _urlRequest;
		}

		public function get loader():Loader
		{
			return _loader;
		}
		
		public function get assetsSwf():ApplicationDomain
		{
			return LoaderInfo( loader.contentLoaderInfo ).applicationDomain;
		}
		
		public function get classNames():Vector.<String>
		{
			return assetsSwf.getQualifiedDefinitionNames();
		}
	}
}