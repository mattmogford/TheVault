package vault.transitions.slide
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import vault.transitions.TransitionType;

	public class Transition_SlideLeft extends TransitionType
	{
		private var _centreX:Number;
		
		private var _fromSprite:Sprite;
		private var _toSprite:Sprite;
		
		public function Transition_SlideLeft( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			var scaleDownTo:Number = 0.5;
			
			_fromSprite = new Sprite;
			_from.parent.addChild( _fromSprite );
			_from.x = -( _from.width >> 1 );
			_from.y = -( _from.height >> 1 );
			_fromSprite.addChild( _from );
			_fromSprite.x = _fromSprite.width >> 1;
			_fromSprite.y = _fromSprite.height >> 1;
			
			_centreX = _fromSprite.width >> 1;
			
			_toSprite = new Sprite;
			_to.parent.addChild( _toSprite );
			_to.x = -( _to.width >> 1 );
			_to.y = -( _to.height >> 1 );
			_toSprite.addChild( _to );
			
			_toSprite.scaleX = _toSprite.scaleY = scaleDownTo;
			_toSprite.x = _fromSprite.width + ( _toSprite.width >> 1 );
			_toSprite.y = _fromSprite.height >> 1;
			
			var tl:TimelineLite = new TimelineLite();
			tl.append( new TweenLite( _fromSprite, 0.5, { scaleX : scaleDownTo, scaleY : scaleDownTo, onComplete : startToAnim } ) );
			tl.append( new TweenLite( _fromSprite, 1, { x : -( ( _fromSprite.width >> 1 ) * scaleDownTo ) } ) );
		}
		
		private function startToAnim():void
		{
			var tl:TimelineLite = new TimelineLite( { onComplete : resetBitmaps } );
			tl.append( new TweenLite( _toSprite, 1, { x : _centreX } ) );
			tl.append( new TweenLite( _toSprite, 0.5, { scaleX : 1, scaleY : 1 } ) );
		}
		
		private function resetBitmaps():void
		{
			_from.x =_from.y = 0;
			_fromSprite.parent.addChild( _from );
			_fromSprite.parent.removeChild( _fromSprite );
			
			_to.x =_to.y = 0;
			_toSprite.parent.addChild( _to );
			_toSprite.parent.removeChild( _toSprite );
			
			stop();
		}
	}
}