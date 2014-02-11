package vault.utils
{
	import flash.media.Sound;

	public class S
	{		
		public function S()
		{
		}
		
		public static function get( soundClass:Class ):Sound 
		{
			var sound:Sound = new soundClass() as Sound;
			
			return sound;
		}
	}
}