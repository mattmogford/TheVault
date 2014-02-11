package vault.core
{	
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>State</code></strong> is a base display class used by the <code>StateManager Class</code>.<br /><br />
	 * Should be used as a replacement for extending <code>Sprite</code>
	 */	
	public class StateStarling extends Sprite
	{
		/** Constructor */
		public function StateStarling()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * <code>onAddedToStage</code><br /><br />
		 * Wait until the state is added to the stage before continuing
		 */
		protected function onAddedToStage(e:Event):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			this.addEventListener( Event.REMOVED_FROM_STAGE, purge );
		}
		
		/**
		 * <code>onEnterFrame</code><br /><br />
		 * Used to wait until the state is completely ready before onReady is called
		 */
		private function onEnterFrame(event:Event):void
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
		 * Override this to remove listeners etc. When the state is to be purged. (Changed)
		 */
		public function purge(e:Event):void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE, purge );
		}
	}
}