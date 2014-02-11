package vault.core
{
	import flash.desktop.NativeApplication;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>MobileState</code></strong> is a base display class used by the <code>StateManager Class</code>.<br /><br />
	 * Should be used as a replacement for extending <code>Sprite</code>
	 */	
	public class MobileState extends State
	{
		/** Constructor */
		public function MobileState()
		{
			super();
		}
		
		/**
		 * <code>onAddedToStage</code><br /><br />
		 * Wait until the state is added to the stage before continuing
		 */
		protected function onAddedToStage(e:Event):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			this.addEventListener( Event.REMOVED_FROM_STAGE, purge );	
			stage.addEventListener( Event.RESIZE, resizeStarted );
		}
		
		/**
		 * <code>resizeStarted</code><br /><br />
		 * Wait until the device has worked out orientation before continuing
		 */
		protected function resizeStarted(e:Event):void
		{
			if( stage.orientation == StageOrientation.ROTATED_RIGHT || stage.orientation == StageOrientation.ROTATED_LEFT )	
			{
				if( stage.stageWidth > stage.stageHeight )resizeComplete( "landscape" );
				else resizeComplete( "portrait" );	
			}
			else	
			{
				if( stage.stageHeight > stage.stageWidth ) resizeComplete( "portrait" );
				else resizeComplete( "landscape" );	
			}
		}
		
		/**
		 * <code>resizeStarted</code><br /><br />
		 * The device has worked out the orientation
		 */
		protected function resizeComplete( orientation:String ):void
		{
			stage.removeEventListener( Event.RESIZE, resizeStarted );			
			stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/**
		 * <code>onEnterFrame</code><br /><br />
		 * Wait until the state is completely ready before onReady is called
		 */
		override protected function onEnterFrame(e:Event):void
		{
			super.onEnterFrame(e);
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyDown );
		}
		
		/**
		 * <code>handleKeyDown</code><br /><br />
		 * Handles whenever a physical key is pressed on the device
		 */
		protected function handleKeyDown(e:KeyboardEvent):void
		{
			e.preventDefault();
			
			switch( e.keyCode )
			{
				case Keyboard.BACK:
					NativeApplication.nativeApplication.exit();
					break;
				
				case Keyboard.SEARCH:
				case Keyboard.MENU:
					e.preventDefault();
					break;
			}
		}
	}
}