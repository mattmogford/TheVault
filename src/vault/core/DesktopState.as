package vault.core
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class DesktopState extends State
	{
		public function DesktopState()
		{
			super();
		}
		
		override protected function onReady():void
		{
			trace( "[ DesktopState ] onReady" );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyDown );
		}
		
		protected function handleKeyDown(e:KeyboardEvent):void
		{
			trace( "[ DesktopState ] handleKeyDown - " + e.keyCode );
			e.preventDefault();
			
			switch( e.keyCode )
			{
				case Keyboard.BACK:				
				case Keyboard.SEARCH:
				case Keyboard.MENU:
					e.preventDefault();
					break;
			}
		}
	}
}