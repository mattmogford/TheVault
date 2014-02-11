package vault.utils
{
	public class StringFormat
	{
		public function StringFormat()
		{
		}
		
		public static function filename( path:String ):String
		{
			var urlArray:Array = path.split( "/" );
			var f:String = urlArray[ urlArray.length - 1 ];
			var filenameArray:Array = f.split( "." );
			return filenameArray[ 0 ];
		}
	}
}