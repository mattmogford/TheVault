package vault.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>State</code></strong> is a base display class used by the <code>StateManager Class</code>.<br /><br />
	 * Should be used as a replacement for extending <code>Sprite</code>
	 */	
	public class State extends Sprite
	{		
		/** Constructor */
		public function State()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * <code>onAddedToStage</code><br /><br />
		 * Wait until the state is added to the stage before continuing
		 */
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			this.addEventListener( Event.REMOVED_FROM_STAGE, purge );
		}
		
		/**
		 * <code>onEnterFrame</code><br /><br />
		 * Wait until the state is completely ready before onReady is called
		 */
		protected function onEnterFrame(e:Event):void
		{
			this.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			onReady();
		}
		
		/**
		 * <code>onReady</code><br /><br />
		 * Override this function to begin <strong>AFTER</strong> the state has been added to the stage.
		 */
		protected function onReady():void
		{
		}
		
		/** 
		 * <code>Purge</code> is only allowed after onReady() has been fired.<br /><br />
		 * Override this to remove listeners etc. When the state is to be purged.
		 */
		public function purge(e:Event):void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE, purge );
		}
	}
}