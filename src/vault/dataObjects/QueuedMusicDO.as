package vault.dataObjects
{
	public class QueuedMusicDO
	{
		public var sound:Class;
		public var vol:Number;
		public var loops:int;
		
		public function QueuedMusicDO( s:Class, v:Number, l:int )
		{
			sound = s;
			vol = v;
			loops = l;
		}
	}
}