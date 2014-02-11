package vault.transitions
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>TransitionType</code></strong> is a base transition class used by the <code>TransitionManager Class</code>.<br /><br />
	 * Should be extended from when creating a custion <code>TransitionType</code>.
	 */
	public class TransitionType extends EventDispatcher
	{
		/** _from : From <code>Bitmap</code> **/
		protected var _from:Bitmap;
		
		/** _to : To <code>Bitmap</code> **/
		protected var _to:Bitmap;
		
		/** 
		 * @param from - Bitmapped version of the current <code>State</code>
		 * @param to - Bitmapped version of the new <code>State</code>
		 */		
		public function TransitionType( from:Bitmap, to:Bitmap )
		{
			_from = from;
			_to = to;
			
			_from.smoothing = _to.smoothing = true;
		}
		
		/**
		 * Override <code>start</code> to start the animation.
		 */
		public function start():void {}
		
		/**
		 * Override <code>stop</code> to stop the animation.
		 */
		public function stop():void
		{
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}