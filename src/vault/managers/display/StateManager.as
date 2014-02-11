package vault.managers.display
{
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import vault.core.State;
	import vault.utils.removeClassPrefix;
		
	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>StateManager</code></strong><br /><br />
	 * Used to manage and change the current state<br /><br />
	 * 
	 * <strong>Simple Usage</strong><br />
	 * <code>
	 * 	StateManager.init( stage, State1, State2 );<br />
	 * 	StateManager.state = State1;
	 * </code>
	 * 
	 */
	public class StateManager
	{
		/** _instance : An instance of <code>StateManager</code> **/
		private static var _instance:StateManager;
		
		/** _stage : A reference to the current <code>Stage</code> **/
		private static var _stage:Stage;
		
		/** _states : A <code>Dictionary</code> of possible states **/
		private static var _states:Dictionary = new Dictionary();
		
		/** _currentState : A reference to the current <code>State</code> **/
		private static var _currentState:State;
		
		/** Constructor - <code>StateManager</code> can not be instantiated - It is a <code>Singleton Class</code>*/
		public function StateManager(s:Singleton)
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
				_instance = new StateManager( new Singleton() );
				_stage = stage;
				
				for each( var classObject:* in stateNames )
				{
					var stateName:String = removeClassPrefix( classObject );
					if( stateName in _states ) throw new Error( "Duplicate state with the name '" + stateName + "'" );
					else
					{
						trace( "[ StateManager ] Adding state '" + stateName + "'" );
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
			trace( "[ StateManager ] Changing state '" + stateName + "'" );
			if( stateName in _states ) changeState( _states[ stateName ] );
			else throw new Error( "A state with the name '" + stateName + "' does not exist" );
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 * @param transitionType - The required Transition type. The <code>Class</code> must extend <code>TransitionType</code>
		 */		
		public static function stateTransition( classObject:Class, transitionType:Class ):void
		{
			var stateName:String = removeClassPrefix( classObject );
			trace( "[ StateManager ] Changing state '" + stateName + "'" );
			
			if( stateName in _states )
			{
				var bmp1:Bitmap = TransitionManager.bitmapDisplayObject( _stage, _currentState );
				var bmp2:Bitmap;
				
				_stage.addChild( bmp1 );
				changeState( classObject, true );
				bmp2 = TransitionManager.bitmapDisplayObject( _stage, _currentState );
				_stage.addChild( bmp2 );
				
				_currentState.mouseChildren = false;
				_currentState.alpha = 0;
				TransitionManager.transition( bmp1, bmp2, transitionType ).addEventListener( Event.COMPLETE, transitionComplete );
			}
			else throw new Error( "A state with the name '" + stateName + "' does not exist" );
		}
		
		/**
		 * <code>transitionComplete</code> Cleans up the Transition
		 * @param event
		 */		
		protected static function transitionComplete(event:Event):void
		{
			_currentState.mouseChildren = true;
			_currentState.alpha = 1;
			
			var bmp1:Bitmap = _stage.getChildAt( _stage.numChildren - 1 ) as Bitmap;
			bmp1.bitmapData.dispose();
			_stage.removeChildAt( _stage.numChildren - 1 );
			
			var bmp2:Bitmap = _stage.getChildAt( _stage.numChildren - 1 ) as Bitmap;
			bmp2.bitmapData.dispose();
			_stage.removeChildAt( _stage.numChildren - 1 );
		}
		
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
 * Used to make <code>StateManager</code> a <code>Singleton</code>
 */
class Singleton{}