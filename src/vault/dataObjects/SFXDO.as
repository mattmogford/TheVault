package vault.dataObjects
{
	public class SFXDO
	{
		public var soundName:String;
		public var frameNo:int;
		public var volume:Number;
		public var loop:Boolean;
		
		public function SFXDO( s:String, f:int, v:Number, l:Boolean )
		{
			soundName = s;
			frameNo = f;
			volume = v;
			loop = l;
		}
	}
}