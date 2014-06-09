package vault.dataObjects
{
	import starling.utils.AssetManager;

	public class ButtonBaseTheme
	{		
		private var _starlingAssetManager:AssetManager;
		
		private var _topCorner:String;
		private var _bottomCorner:String;
		private var _verticalStretcher:String;
		private var _horizontalStretcherTop:String;
		private var _horizontalStretcherMid:String;
		private var _horizontalStretcherBottom:String;
		private var _highlightMid:String;
		private var _highlightCurve:String;
		
		public var fontName:String;
		public var textColor:uint;
		public var hAlign:String;
		public var bold:Boolean;
		
		public function ButtonBaseTheme(
			starlingAssetManager:AssetManager,
			topCorner:String,
			bottomCorner:String,
			verticalStretcher:String,
			horizontalStretcherTop:String,
			horizontalStretcherMid:String,
			horizontalStretcherBottom:String,
			highlightMid:String = null,
			highlightCurve:String = null
		)
		{
			_starlingAssetManager = starlingAssetManager;
			_topCorner = topCorner;
			_bottomCorner = bottomCorner;
			_verticalStretcher = verticalStretcher;
			_horizontalStretcherTop = horizontalStretcherTop;
			_horizontalStretcherMid = horizontalStretcherMid;
			_horizontalStretcherBottom = horizontalStretcherBottom;
			_highlightMid = highlightMid;
			_highlightCurve = highlightCurve;
		}
		
		public function get starlingAssetManager():AssetManager
		{
			return _starlingAssetManager;
		}
		public function get topCorner():String
		{
			return _topCorner;
		}
		public function get bottomCorner():String
		{
			return _bottomCorner;
		}
		public function get verticalStretcher():String
		{
			return _verticalStretcher;
		}
		public function get horizontalStretcherTop():String
		{
			return _horizontalStretcherTop;
		}
		public function get horizontalStretcherMid():String
		{
			return _horizontalStretcherMid;
		}
		public function get horizontalStretcherBottom():String
		{
			return _horizontalStretcherBottom;
		}
		public function get highlightMid():String
		{
			return _highlightMid;
		}
		public function get highlightCurve():String
		{
			return _highlightCurve;
		}
	}
}