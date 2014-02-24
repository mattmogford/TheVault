package vault.managers.display
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import vault.core.State;
	
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
		private static var _context:DisplayObjectContainer;
		
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
		public static function init( context:DisplayObjectContainer, ...stateNames ):void
		{
			if( !_instance )
			{
				_instance = new StateManager( new Singleton() );
				_context = context;
				
				for each( var classObject:* in stateNames )
				{
					if( classObject in _states ) throw new Error( "Duplicate state with the name '" + classObject + "'" );
					else
					{
						trace( "[ StateManager ] Adding state '" + classObject + "'" );
						_states[ classObject ] = classObject;
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
			if( _currentState ) _context.removeChild( _currentState );
			if( !transition )
				_context.addChild( _currentState = new stateClass() );
			else
				_context.addChildAt( _currentState = new stateClass(), _context.numChildren - 1 );
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 */		
		public static function set state( classObject:Class ):void
		{
			trace( "[ StateManager ] Changing state '" + classObject + "'" );
			if( classObject in _states ) changeState( _states[ classObject ] );
			else throw new Error( "A state with the name '" + classObject + "' does not exist" );
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