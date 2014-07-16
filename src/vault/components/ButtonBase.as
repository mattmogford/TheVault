package vault.components
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	import vault.core.StateStarlingClickable;
	import vault.dataObjects.ButtonBaseTheme;
	import vault.text.TextField;
	
	
	public class ButtonBase extends StateStarlingClickable
	{
		private var _scaleFactor:Number;
		
		private var _theme:ButtonBaseTheme;		
		private var _iconTex:Texture;
		private var _fontSize:Number;
		private var _mainText:String;
		private var _multiline:Boolean;
		private var _curvePos:Number;
		
		protected var _topCornerTex:Texture;
		protected var _vStretcherTex:Texture;
		protected var _bottomCornerTex:Texture;
		protected var _hStretcherTopTex:Texture;
		protected var _hStretcherMidTex:Texture;
		protected var _hStretcherBottomTex:Texture;
		protected var _highlightMidTex:Texture;
		protected var _highlightCurveTex:Texture;

		private var _topLeftCorner:Image;
		private var _topRightCorner:Image;
		private var _bottomLeftCorner:Image;
		private var _bottomRightCorner:Image;
		private var _vStretcherLeft:Image;
		private var _vStretcherRight:Image;
		private var _hStretcherTopLeft:Image;
		private var _hStretcherTopRight:Image;
		private var _hStretcherMidLeft:Image;
		private var _hStretcherMidRight:Image;
		private var _hStretcherBottomLeft:Image;
		private var _hStretcherBottomRight:Image;
		private var _highlightMid:Image;
		private var _highlightCurve:Image;
		
		private var _mainTF:TextField;
		private var _icon:Image;
		
		public function ButtonBase( w:Number, h:Number, scaleFactor:Number, theme:ButtonBaseTheme, iconTex:Texture = null, mainText:String = null, fontSize:Number = 0, multiline:Boolean = true, curvePos:Number = 0.35 )
		{
			super();
			
			_scaleFactor = scaleFactor;
			
			_theme = theme;
			_iconTex = iconTex;
			_mainText = mainText;
			_fontSize = fontSize;
			_multiline = multiline;
			_curvePos = curvePos;
			
			buildTextures();
			buildContent( w, h );
			
			if( _topCornerTex.height + _bottomCornerTex.height >= ( h - 2 ) )
			{
				trace( "Corner Textures are too big, shrink them to allow at least 2 pixels for the _vStretcherTex" );
			}
		}
		
		protected function buildTextures():void
		{
			//Corner Textures
			_topCornerTex = _theme.starlingAssetManager.getTexture( _theme.topCorner );
			_bottomCornerTex = _theme.starlingAssetManager.getTexture( _theme.bottomCorner );
			
			//Vertical Stretcher
			_vStretcherTex = _theme.starlingAssetManager.getTexture( _theme.verticalStretcher );
			
			//Horizontal Stretchers
			_hStretcherTopTex = _theme.starlingAssetManager.getTexture( _theme.horizontalStretcherTop );
			_hStretcherMidTex = _theme.starlingAssetManager.getTexture( _theme.horizontalStretcherMid );
			_hStretcherBottomTex = _theme.starlingAssetManager.getTexture( _theme.horizontalStretcherBottom );
			
			//Highlights
			_highlightMidTex = _theme.starlingAssetManager.getTexture( _theme.highlightMid );
			_highlightCurveTex = _theme.starlingAssetManager.getTexture( _theme.highlightCurve );
		}
		
		private function buildContent( w:Number, h:Number ):void
		{
			var pivotXPercent:Number = ( pivotX ) ? ( pivotX / width ) : 0;
			var pivotYPercent:Number = ( pivotY ) ? ( pivotY / height ) : 0;
			
			removeContent( true );
			
			//CORNERS
			if( _topCornerTex )
			{
				_topLeftCorner = new Image( _topCornerTex );
				_topLeftCorner.smoothing = TextureSmoothing.NONE;
				this.addChild( _topLeftCorner );
				
				_topRightCorner = new Image( _topCornerTex );
				_topRightCorner.smoothing = TextureSmoothing.NONE;
				_topRightCorner.scaleX = - _topRightCorner.scaleX;
				_topRightCorner.x = w * _scaleFactor;
				this.addChild( _topRightCorner );
			}
			
			if( _bottomCornerTex )
			{
				_bottomLeftCorner = new Image( _bottomCornerTex );
				_bottomLeftCorner.smoothing = TextureSmoothing.NONE;
				_bottomLeftCorner.y = ( h  * _scaleFactor ) - _bottomLeftCorner.height;
				this.addChild( _bottomLeftCorner );
				
				_bottomRightCorner = new Image( _bottomCornerTex );
				_bottomRightCorner .smoothing = TextureSmoothing.NONE;
				_bottomRightCorner.scaleX = - _bottomRightCorner.scaleX;
				_bottomRightCorner.x = w * _scaleFactor;
				_bottomRightCorner.y = _bottomLeftCorner.y;
				this.addChild( _bottomRightCorner );
			}
			
			
			//VERTICAL-STRETCHERS
			if( _vStretcherTex )
			{
				_vStretcherLeft = new Image( _vStretcherTex );
				_vStretcherLeft.smoothing = TextureSmoothing.NONE;
				_vStretcherLeft.height = _bottomLeftCorner.bounds.top - _topLeftCorner.bounds.bottom;
				_vStretcherLeft.y = _topLeftCorner.bounds.bottom;
				this.addChild( _vStretcherLeft );
				
				_vStretcherRight = new Image( _vStretcherTex );
				_vStretcherRight.smoothing = TextureSmoothing.NONE;
				_vStretcherRight.height = _bottomRightCorner.bounds.top - _topRightCorner.bounds.bottom;
				_vStretcherRight.scaleX = - _vStretcherRight.scaleX;
				_vStretcherRight.x = w * _scaleFactor;
				_vStretcherRight.y = _topRightCorner.bounds.bottom;
				this.addChild( _vStretcherRight );
			}
			
			
			
			
			if( _hStretcherTopTex )
			{
				_hStretcherTopLeft = new Image( _hStretcherTopTex );
				_hStretcherTopLeft.smoothing = TextureSmoothing.NONE;
				_hStretcherTopLeft.x = _topLeftCorner.bounds.right;
				_hStretcherTopLeft.width = ( ( _topRightCorner.bounds.left - _topLeftCorner.bounds.right ) / 2 );
				this.addChild( _hStretcherTopLeft );
				
				_hStretcherTopRight = new Image( _hStretcherTopTex );
				_hStretcherTopRight.smoothing = TextureSmoothing.NONE;
				_hStretcherTopRight.width = _hStretcherTopLeft.width;
				_hStretcherTopRight.scaleX = - _hStretcherTopRight.scaleX;
				_hStretcherTopRight.x = _hStretcherTopLeft.bounds.right + _hStretcherTopRight.width;
				this.addChild( _hStretcherTopRight );
			}
			
			
			if( _hStretcherMidTex )
			{
				_hStretcherMidLeft = new Image( _hStretcherMidTex );
				_hStretcherMidLeft.smoothing = TextureSmoothing.NONE;
				_hStretcherMidLeft.x = _vStretcherLeft.bounds.right;
				_hStretcherMidLeft.y = _vStretcherLeft.y;
				_hStretcherMidLeft.width = ( _vStretcherRight.bounds.left - _vStretcherLeft.bounds.right ) / 2;
				_hStretcherMidLeft.height = _bottomLeftCorner.bounds.top - _topLeftCorner.bounds.bottom;
				this.addChild( _hStretcherMidLeft );
				
				_hStretcherMidRight = new Image( _hStretcherMidTex );
				_hStretcherMidRight.smoothing = TextureSmoothing.NONE;
				_hStretcherMidRight.width = _hStretcherMidLeft.width;
				_hStretcherMidRight.height = _hStretcherMidLeft.height;
				_hStretcherMidRight.scaleX = - _hStretcherMidRight.scaleX;
				_hStretcherMidRight.x = _hStretcherMidLeft.bounds.right + _hStretcherMidRight.width;
				_hStretcherMidRight.y = _hStretcherMidLeft.y;
				this.addChild( _hStretcherMidRight );
			}
			
			
			if( _hStretcherBottomTex )
			{
				_hStretcherBottomLeft = new Image( _hStretcherBottomTex );
				_hStretcherBottomLeft.smoothing = TextureSmoothing.NONE;
				_hStretcherBottomLeft.x = _bottomLeftCorner.bounds.right;
				_hStretcherBottomLeft.y = _bottomLeftCorner.y;
				_hStretcherBottomLeft.width = ( ( w  * _scaleFactor ) - ( _bottomLeftCorner.width * 2 ) ) / 2;
				this.addChild( _hStretcherBottomLeft );
				
				_hStretcherBottomRight = new Image( _hStretcherBottomTex );
				_hStretcherBottomRight.smoothing = TextureSmoothing.NONE;
				_hStretcherBottomRight.width = _hStretcherBottomLeft.width;
				_hStretcherBottomRight.scaleX = - _hStretcherBottomRight.scaleX;
				_hStretcherBottomRight.x = _hStretcherBottomLeft.bounds.right + _hStretcherBottomRight.width;
				_hStretcherBottomRight.y = _hStretcherBottomLeft.y;
				this.addChild( _hStretcherBottomRight );
			}
			
			
			
			if( _highlightMidTex )
			{
				_highlightMid = new Image( _highlightMidTex );
				_highlightMid.smoothing = TextureSmoothing.NONE;
				_highlightMid.y = _topLeftCorner.bounds.bottom;
				_highlightMid.width = w * _scaleFactor;
				_highlightMid.height = ( _vStretcherLeft.height * _curvePos );
				this.addChild( _highlightMid );
			}
			
			if( _highlightCurveTex )
			{
				_highlightCurve = new Image( _highlightCurveTex );
				_highlightCurve.smoothing = TextureSmoothing.NONE;
				_highlightCurve.y = _highlightMid.bounds.bottom;
				_highlightCurve.width = w * _scaleFactor;
				this.addChild( _highlightCurve );
				
				//Check if curve is too low - squash it if so
				if( _highlightCurve.bounds.bottom > ( height - _bottomLeftCorner.height ) )
					_highlightCurve.height -= ( _highlightCurve.bounds.bottom - ( ( h * _scaleFactor ) - _bottomLeftCorner.height ) );
			}
			
			
			if( _mainText ) addMainTextField();
			if( _iconTex ) addIcon();
			
			
			this.pivotX = width * pivotXPercent;
			this.pivotY = height * pivotYPercent;
		}
		
		private function addMainTextField():void
		{
			//_mainTF = new TextField( width - ( 10 * _scaleFactor ), height - ( 10 * _scaleFactor ), _mainText, _theme.fontName, height - ( 6 * _scaleFactor ), _theme.textColor, _theme.bold, _multiline );
			_mainTF = new TextField( width - ( 10 * _scaleFactor ), height - ( 10 * _scaleFactor ), _mainText, _theme.fontName, _fontSize, _theme.textColor, _theme.bold, _multiline );
			_mainTF.hAlign = _theme.hAlign;
			_mainTF.autoScale = true;
			_mainTF.border = false;
			_mainTF.touchable = false;
			_mainTF.x = ( 5 * _scaleFactor );
			_mainTF.y = ( 5 * _scaleFactor );
			this.addChild( _mainTF );
		}
		
		private function addIcon():void
		{
			_icon = new Image( _iconTex );
			_icon.alignPivot();
			_icon.smoothing = TextureSmoothing.TRILINEAR;
			_icon.width = ( height * 0.6 );
			_icon.scaleY = _icon.scaleX;
			_icon.x = ( width / 2 );
			_icon.y = ( height / 2 );
			this.addChild( _icon );
		}
		
		
		public function get size():Point
		{
			return new Point( width, height );
		}
		public function set size(value:Point):void
		{
			buildContent( value.x, value.y );
			//super.height = value;
		}
		
		override public function set width(value:Number):void
		{
			buildContent( value, height );
			//super.height = value;
		}
		
		override public function set height(value:Number):void
		{
			buildContent( width, value );
			//super.height = value;
		}
		
		public function set text( value:String ):void
		{
			_mainText = value;
			buildContent( width, height );
		}
		
		
		public function get curvePos():Number
		{
			return _curvePos;
		}
		public function set curvePos(value:Number):void
		{
			if( value > 1 ) value = 1;
			if( value < 0 ) value = 0;
			
			_curvePos = value;
			
			buildContent( width, height );
		}
		
		override protected function onReady():void
		{
			super.onReady();
		}
		
		private function removeContent( toDispose:Boolean ):void
		{
			if( _topLeftCorner ) _topLeftCorner.removeFromParent( toDispose );
			if( _topRightCorner ) _topRightCorner.removeFromParent( toDispose );
			if( _bottomLeftCorner ) _bottomLeftCorner.removeFromParent( toDispose );
			if( _bottomRightCorner ) _bottomRightCorner.removeFromParent( toDispose );
			if( _vStretcherLeft ) _vStretcherLeft.removeFromParent( toDispose );
			if( _vStretcherRight ) _vStretcherRight.removeFromParent( toDispose );
			if( _hStretcherTopLeft ) _hStretcherTopLeft.removeFromParent( toDispose );
			if( _hStretcherTopRight ) _hStretcherTopRight.removeFromParent( toDispose );
			if( _hStretcherMidLeft ) _hStretcherMidLeft.removeFromParent( toDispose );
			if( _hStretcherMidRight ) _hStretcherMidRight.removeFromParent( toDispose );
			if( _hStretcherBottomLeft ) _hStretcherBottomLeft.removeFromParent( toDispose );
			if( _hStretcherBottomRight ) _hStretcherBottomRight.removeFromParent( toDispose );
			if( _highlightMid ) _highlightMid.removeFromParent( toDispose );
			if( _highlightCurve ) _highlightCurve.removeFromParent( toDispose );
			
			if( _mainTF ) _mainTF.removeFromParent( toDispose );
			if( _icon ) _icon.removeFromParent( toDispose );
		}
		
		override public function purge(e:Event):void
		{
			removeContent( true );
			
			if( _iconTex ) _iconTex.dispose();
			
			if( _topCornerTex ) _topCornerTex.dispose();
			if( _vStretcherTex ) _vStretcherTex.dispose();
			if( _bottomCornerTex ) _bottomCornerTex.dispose();
			if( _hStretcherTopTex ) _hStretcherTopTex.dispose();
			if( _hStretcherMidTex ) _hStretcherMidTex.dispose();
			if( _hStretcherBottomTex ) _hStretcherBottomTex.dispose();
			if( _highlightMidTex ) _highlightMidTex.dispose();
			if( _highlightCurveTex ) _highlightCurveTex.dispose();
			
			super.purge(e);
		}		
	}
}