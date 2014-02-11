package vault.managers.display
{
	public class ImageManager
	{
		private static var _originalImages:Vector.<String>;
		private static var _availableImages:Vector.<String>;
		
		public function ImageManager()
		{
		}
		
		/**
		 * 
		 * @param imagesXMLList  - e.g. &lt;img name="image_1.jpg"/&gt;
		 * 
		 */		
		public static function init( imagesXMLList:XMLList ):void
		{
			_originalImages = new Vector.<String>;
			
			for each( var img:XML in imagesXMLList )
				_originalImages.push( img.@name );
			
			populateAvailableImages();
		}
		
		private static function populateAvailableImages():void
		{
			_availableImages = new Vector.<String>;
			for each( var imgName:String in _originalImages ) 
				_availableImages.push( imgName );
		}
		
		public static function getRandomImage():String
		{
			var imgName:String = _availableImages.splice( int( ( Math.random() * _availableImages.length ) ), 1 )[ 0 ];
			if( !_availableImages.length ) populateAvailableImages();
			return imgName;
		}
	}
}