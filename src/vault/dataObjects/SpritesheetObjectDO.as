package vault.dataObjects
{
	import flash.display.Bitmap;
	
	import starling.textures.Texture;
	
	public class SpritesheetObjectDO
	{
		private var _bmp:Bitmap;
		private var _data:Object;
		private var _name:String;
		
		public var generateMipMaps:Boolean;
		
		public function SpritesheetObjectDO( bmp:Bitmap, data:Object, name:String, _generateMipMaps:Boolean = true )
		{
			_bmp = bmp;
			_data = data;
			_name = name;
			generateMipMaps = _generateMipMaps;
		}
		
		public function get bitmap():Bitmap
		{
			return _bmp;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get texture():Texture
		{
			var t:Texture = Texture.fromBitmap( _bmp, generateMipMaps );
			_bmp.bitmapData.dispose();
			_data = null;
			_name = null;
			return t;
		}
	}
}