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
	 * 	var sm:StateManager = new StateManager( displayObj, State1, State2 );<br />
	 * sm.state = State1;
	 * </code>
	 * 
	 * 
	 * * TO CREATE A STATIC VERSION OF THE ABOVE
	 * private static var _stateManager:StateManagerStarling;<br /><br />
	 public function MainStateManager( s:Singleton )<br />
	 {<br />
	 if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );<br />
	 }<br /><br />
	 public static function init( context:DisplayObjectContainer, ...stateNames ):void<br />
	 {<br />
	 _stateManager = new StateManagerStarling( context );<br />
	 for each( var classObject:* in stateNames ) _stateManager.addState( classObject );<br />
	 }<br /><br />
	 public static function set state( classObject:Class ):void<br />
	 {<br />
	 _stateManager.state = classObject;<br />
	 }<br />
	 * 
	 ** Used to make <code>StateManagerStarling</code> a <code>Singleton</code>
	* class Singleton{}
	 * 
	 */
	public class StateManager
	{
		/** _stage : A reference to the current <code>Stage</code> **/
		private var _context:DisplayObjectContainer;
		
		/** _states : A <code>Dictionary</code> of possible states **/
		private var _states:Dictionary = new Dictionary();
		
		/** _currentState : A reference to the current <code>State</code> **/
		private var _currentState:State;
		
		/** verbose : Setting this to <code>true</code>, will enable <code>tracing</code> **/
		public var verbose:Boolean;
		
		/** Constructor - <code>StateManager</code>*/
		public function StateManager( context:DisplayObjectContainer, ...stateNames )
		{
			_context = context;
			
			for each( var classObject:* in stateNames ) addState( classObject );
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 */
		public function addState( classObject:Class ):void
		{
			if( classObject in _states ) throw new Error( "Duplicate state with the name '" + classObject + "'" );
			else
			{
				if( verbose ) trace( "[ StateManager ] Adding state '" + classObject + "'" );
				_states[ classObject ] = classObject;
			}
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 */		
		public function set state( classObject:Class ):void
		{
			if( verbose ) trace( "[ StateManager ] Changing state '" + classObject + "'" );
			if( classObject in _states ) changeState( _states[ classObject ] );
			else throw new Error( "A state with the name '" + classObject + "' does not exist" );
			
			classObject = null;
		}
		
		/** 
		 * @param stateClass - The required <code>State Class</code>
		 * @param transition - If the state change is part of a <code>Transition</code>, this must be set to <code>true</code>.
		 */		
		private function changeState( stateClass:Class, transition:Boolean = false ):void
		{
			if( _currentState ) _context.removeChild( _currentState );
			if( !transition )
				_context.addChild( _currentState = new stateClass() );
			else
				_context.addChildAt( _currentState = new stateClass(), _context.numChildren - 1 );
		}
		
		/**
		 * <code>purge</code> calls the purge function within the current <code>State Class</code> 
		 * @param event 
		 */		
		public function purge(event:Event):void
		{
			_currentState.purge( event );
		}
	}
}