package vault.events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const READY:String = "READY";
		public static const STARTED:String = "STARTED";
		public static const COMPLETE:String = "COMPLETE";
		public static const FAILED:String = "FAILED";
		
		public function GameEvent( type:String )
		{
			super( type );
		}
	}
}