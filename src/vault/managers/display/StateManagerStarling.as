package vault.managers.display
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import starling.display.Stage;
	import starling.events.Event;
	
	import vault.core.StateStarling;
	import vault.utils.removeClassPrefix;
	
	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>StateManagerStarling</code></strong><br /><br />
	 * Used to manage and change the current state<br /><br />
	 * 
	 * <strong>Simple Usage</strong><br />
	 * <code>
	 * 	StateManagerStarling.init( stage, State1, State2 );<br />
	 * 	StateManagerStarling.state = State1;
	 * </code>
	 * 
	 */
	public class StateManagerStarling
	{
		/** _instance : An instance of <code>StateManagerStarling</code> **/
		private static var _instance:StateManagerStarling;
		
		/** _stage : A reference to the current <code>Stage</code> **/
		private static var _stage:Stage;
		
		/** _states : A <code>Dictionary</code> of possible states **/
		private static var _states:Dictionary = new Dictionary();
		
		/** _currentState : A reference to the current <code>State</code> **/
		private static var _currentState:StateStarling;
		
		/** Constructor - <code>StateManagerStarling</code> can not be instantiated - It is a <code>Singleton Class</code>*/
		public function StateManagerStarling(s:Singleton)
		{
			if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );
		}
		
		/**
		 * @param stage - A reference to the current stage
		 * @param stateNames - An <code>Array</code> of possible states 
		 */		
		public static function init( stage:Stage, ...stateNames ):void
		{
			if( !_instance )
			{
				_instance = new StateManagerStarling( new Singleton() );
				_stage = stage;
				
				for each( var classObject:* in stateNames )
				{
					var stateName:String = removeClassPrefix( classObject );
					if( stateName in _states ) throw new Error( "Duplicate state with the name '" + stateName + "'" );
					else
					{
						trace( "[ StateManagerStarling ] Adding state '" + stateName + "'" );
						_states[ stateName ] = classObject;
					}
				}
			}
		}
		
		/** 
		 * @param stateClass - The required <code>State Class</code>
		 * @param transition - If the state change is part of a <code>Transition</code>, this must be set to <code>true</code>.
		 */		
		private static function changeState( stateClass:Class, transition:Boolean = false ):void
		{
			if( _currentState ) _stage.removeChild( _currentState );
			if( !transition )
				_stage.addChild( _currentState = new stateClass() );
			else
				_stage.addChildAt( _currentState = new stateClass(), _stage.numChildren - 1 );
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 */		
		public static function set state( classObject:Class ):void
		{
			var stateName:String = removeClassPrefix( classObject );
			trace( "[ StateManagerStarling ] Changing state '" + stateName + "'" );
			if( stateName in _states ) changeState( _states[ stateName ] );
			else throw new Error( "A state with the name '" + stateName + "' does not exist" );
			
			stateName = null;
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 * @param transitionType - The required Transition type. The <code>Class</code> must extend <code>TransitionType</code>
		 */		
		//public static function stateTransition( classObject:Class, transitionType:Class ):void
		/*public static function stateTransition( classObject:Class ):void
		{
			var stateName:String = removeClassPrefix( classObject );
			trace( "[ StateManager ] Changing state '" + stateName + "'" );
			
			if( stateName in _states )
			{
				var rendTex1:RenderTexture = new RenderTexture( _stage.stageWidth, _stage.stageHeight, false );
				rendTex1.draw( _currentState );
				var img1:Image = new Image( rendTex1 );
				
				var img2:Image;
				
				_stage.addChild( img1 );
				changeState( classObject, true );
				
				var rendTex2:RenderTexture = new RenderTexture( _stage.stageWidth, _stage.stageHeight, false );
				rendTex2.draw( _currentState );
				img2 = new Image( rendTex2 );
				
				_stage.addChild( img2 );
				_currentState.alpha = 0;
				
				TweenMax.to( img1, 0.5, { y : img1.height } );
				
				img2.y = -img2.height;
				TweenMax.to( img2, 0.5, { y : 0, onComplete : transitionComplete } );
			}
			else throw new Error( "A state with the name '" + stateName + "' does not exist" );
		}*/
		
		/**
		 * <code>transitionComplete</code> Cleans up the Transition
		 * @param event
		 */		
		/*protected static function transitionComplete():void
		{
			_currentState.alpha = 1;
			
			var bmp1:Image = _stage.getChildAt( _stage.numChildren - 1 ) as Image;
			_stage.removeChildAt( _stage.numChildren - 1 );
			bmp1.texture.base.dispose();
			bmp1.dispose();
			bmp1 = null;
			
			var bmp2:Image = _stage.getChildAt( _stage.numChildren - 1 ) as Image;
			_stage.removeChildAt( _stage.numChildren - 1 );
			bmp2.texture.base.dispose();
			bmp2.dispose();
			bmp2 = null;
		}*/
		
		/**
		 * <code>purge</code> calls the purge function within the current <code>State Class</code> 
		 * @param event 
		 */		
		public static function purge(event:Event):void
		{
			_currentState.purge( event );
		}
	}
}


/**
 * Used to make <code>StateManagerStarling</code> a <code>Singleton</code>
 */
class Singleton{}