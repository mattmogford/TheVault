package vault.managers.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import vault.transitions.TransitionType;

	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>TransitionManager</code></strong><br /><br />
	 * Used to manage and change the current <code>TransitionType</code>
	 */
	public class TransitionManager
	{
		/** _currentTransition - Current <code>TransitionType</code> */		
		private static var _currentTransition:TransitionType;
		
		/** Constructor */
		public function TransitionManager()
		{
		}
		
		/**
		 * @return TransitionType
		 */		
		public static function transition( from:Bitmap, to:Bitmap, type:Class ):TransitionType
		{
			_currentTransition = new type( from, to );
			_currentTransition.start();
			return _currentTransition;
		}
		
		/** 
		 * @return Bitmap
		 */		
		public static function bitmapDisplayObject( stage:Stage, displayObject:DisplayObject ):Bitmap
		{
			var bmd:BitmapData = new BitmapData( stage.stageWidth, stage.stageHeight );
			bmd.draw( displayObject );
			return new Bitmap( bmd );
		}

		/**
		 * @return TransitionType
		 */		
		public static function get currentTransition():TransitionType
		{
			return _currentTransition;
		}
	}
}