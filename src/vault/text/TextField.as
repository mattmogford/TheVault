package vault.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import starling.text.TextField;
	
	public class TextField extends starling.text.TextField
	{
		private var _multiline:Boolean;
		private var _wordWrap:Boolean;
		
		public function TextField(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0x0, bold:Boolean=false, multiline:Boolean = true )
		{
			_multiline = multiline;
			
			super(width, height, text, fontName, fontSize, color, bold);
		}
		
		override protected function formatText(textField:flash.text.TextField, textFormat:TextFormat):void
		{
			textField.multiline = _multiline;
			textField.wordWrap = _multiline;
			
			super.formatText(textField, textFormat);
		}
	}
}