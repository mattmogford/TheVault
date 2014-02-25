package vault.managers.display
{
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	import vault.core.StateStarling;
	
	/**
	 * @author Matthew Mogford - mattmogford.com<br /><br />
	 * 
	 * <strong><code>StateManagerStarling</code></strong><br /><br />
	 * Used to manage and change the current state<br /><br />
	 * 
	 * <strong>Simple Usage</strong><br />
	 * <code>
	 * 	var sm:StateManagerStarling = new StateManagerStarling( displayObj, State1, State2 );<br />
	 * sm.state = State1;
	 * </code>
	 * 
	 * 
	 * TO CREATE A STATIC VERSION OF THE ABOVE
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
	public class StateManagerStarling
	{
		/** _stage : A reference to the current <code>Stage</code> **/
		private var _context:DisplayObjectContainer;
		
		/** _states : A <code>Dictionary</code> of possible states **/
		private var _states:Dictionary = new Dictionary();
		
		/** _currentState : A reference to the current <code>State</code> **/
		private var _currentState:StateStarling;
		
		/** verbose : Setting this to <code>true</code>, will enable <code>tracing</code> **/
		public var verbose:Boolean;
		
		/** Constructor - <code>StateManagerStarling</code>*/
		public function StateManagerStarling( context:DisplayObjectContainer, ...stateNames )
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
				if( verbose ) trace( "[ StateManagerStarling ] Adding state '" + classObject + "'" );
				_states[ classObject ] = classObject;
			}
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 */
		public function set state( classObject:Class ):void
		{
			if( verbose ) trace( "[ StateManagerStarling ] Changing state '" + classObject + "'" );
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
			if( _currentState ) 
			{
				_context.removeChild( _currentState );
				_currentState.dispose();
				_currentState = null;
			}
			if( !transition )
				_context.addChild( _currentState = new stateClass() );
			else
				_context.addChildAt( _currentState = new stateClass(), _context.numChildren - 1 );
		}
		
		/** 
		 * @param classObject - The required <code>State Class</code>
		 * @param transitionType - The required Transition type. The <code>Class</code> must extend <code>TransitionType</code>
		 */		
		//public function stateTransition( classObject:Class, transitionType:Class ):void
		/*public function stateTransition( classObject:Class ):void
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
		/*protected function transitionComplete():void
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
		public function purge(event:Event):void
		{
			_currentState.purge( event );
		}
	}
}