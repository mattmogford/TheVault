package vault.managers.sound
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import vault.dataObjects.QueuedMusicDO;
	import vault.utils.S;
	import vault.utils.removeClassPrefix;

	public class SoundManager
	{
		private static var _instance:SoundManager;
		
		private static var _musicChannel:SoundChannel = new SoundChannel();
		private static var _musicSoundTransform:SoundTransform= new SoundTransform();
		private static var _currentPlayingMusic:QueuedMusicDO;

		private static var _musicVol:Number;
		private static var _musicMuted:Boolean;
		
		private static var _queue:Vector.<QueuedMusicDO> = new Vector.<QueuedMusicDO>();
		private static var _queuePos:int = 0;
		
		private static var _sfxDictionary:Dictionary = new Dictionary();
		private static var _sfxChannel:SoundChannel = new SoundChannel();
		private static var _loopSfxChannel:SoundChannel = new SoundChannel();
		private static var _continuous:Boolean;
		
		private static var _currentLoopingSFX:Class;
		
		public function SoundManager(s:Singleton)
		{
			if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );
		}
		
		public static function getInstance():SoundManager
		{
			if( !_instance )
				return _instance = new SoundManager( new Singleton() );
			else
				return _instance;
		}
		
		/****************************************************************************************/
		
		public static function addSFX( ...sfxClasses ):void
		{
			for each( var sfxClass:Class in sfxClasses ) 
			{
				var sfxClassName:String = removeClassPrefix( sfxClass );
				if( sfxClass in _sfxDictionary )
					trace( "[SoundManager] SFX '" + sfxClassName + " already added"  );
				else
				{
					trace( "[SoundManager] Adding SFX '" + sfxClassName );
					_sfxDictionary[ sfxClassName ] = sfxClass;
				}
			}
		}
		
		public static function playSFX( soundClass:Class, vol:Number = 1, loop:Boolean = false ):SoundChannel
		{
			trace("SoundManager.playSFX(soundClass, vol, loop)");
			
			var sfxClassName:String = removeClassPrefix( soundClass );
			playSFXByName( sfxClassName, vol, loop );
			
			return _sfxChannel;
		}
		
		public static function playSFXByName( sfxClassName:String, vol:Number = 1, loop:Boolean = false ):SoundChannel
		{
			if( sfxClassName in _sfxDictionary )
			{
				trace( "[SoundManager] Playing SFX '" + sfxClassName + "'" );
				var sndTransform:SoundTransform = new SoundTransform();
				sndTransform.volume = vol;					
				if( loop )
				{
					_loopSfxChannel = S.get( _sfxDictionary[ sfxClassName ] ).play( 0, 1, sndTransform );
					_currentLoopingSFX = _sfxDictionary[ sfxClassName ];
					_loopSfxChannel.addEventListener( Event.SOUND_COMPLETE, loopSFX );
				}
				else
					_sfxChannel = S.get( _sfxDictionary[ sfxClassName ] ).play( 0, 1, sndTransform );
			}
			else
				throw new Error( "A SFX with the name '" + sfxClassName + "' does not exist" );
			
			return _sfxChannel;
		}
		
		private static function loopSFX(event:Event):void
		{
			if( _sfxChannel )
			{
				_loopSfxChannel.removeEventListener(Event.SOUND_COMPLETE, loopSFX );
				var sc:SoundChannel = event.target as SoundChannel;
				playSFX( _currentLoopingSFX, sc.soundTransform.volume, true );
			}
		}
		
		public static function stopSFX():void
		{
			_sfxChannel.stop();
			if( _loopSfxChannel ) _loopSfxChannel.stop();
		}
		
		public static function stopLoopingSFX():void
		{
			
			if( _loopSfxChannel.hasEventListener( Event.SOUND_COMPLETE ) )
				_loopSfxChannel.removeEventListener(Event.SOUND_COMPLETE, loopSFX );
			
			stopSFX();
		}
		
		/****************************************************************************************/
		
		public static function enqueue( quedSound:QueuedMusicDO ):void
		{
			trace( "[SoundManager] Adding Music '" + quedSound.sound + "' To Queue" );
			_queue.push( quedSound );
		}
		
		private static function clearQueue():void
		{
			_queue = new Vector.<QueuedMusicDO>;
			_queuePos = 0;
		}
		
		public static function playQueue( continuous:Boolean = true ):void
		{
			trace( "[SoundManager] Start Music Queue" );
			_continuous = continuous;
			playMusic( _queue[ _queuePos ] );
		}
		
		public static function advanceQueue(event:Event = null):void
		{
			trace( "[SoundManager] Advance Through Queue '" + _queue[ _queuePos ].sound + "'" );
			_queuePos++;
			playMusic( _queue[ _queuePos ] );
		}
		
		public static function playMusic( quedSound:QueuedMusicDO ):void
		{
			if( _currentPlayingMusic && quedSound.sound == _currentPlayingMusic.sound ) return;
			trace( "[SoundManager] Playing Music '" + quedSound.sound + "'" );
			stopMusic();
			_currentPlayingMusic = quedSound;
			
			musicVol = quedSound.vol;
			_musicChannel = S.get( quedSound.sound ).play( 0, quedSound.loops, _musicSoundTransform );
			
			if( _continuous ) _musicChannel.addEventListener( Event.SOUND_COMPLETE, advanceQueue );
		}
		
		public static function stopMusic():void
		{
			trace( "[SoundManager] Stopping Music" );
			_musicChannel.stop();
			_currentPlayingMusic = null;
		}
		
		/****************************************************************************************/
		
		public static function muteMusic():void
		{
			musicVol = 0;
			_musicMuted = true;
		}
		
		public static function unmuteMusic():void
		{
			_musicMuted = false;
			if( _currentPlayingMusic ) musicVol = _currentPlayingMusic.vol;
		}

		private static function set musicVol(value:Number):void
		{
			if( !_musicMuted )
			{
				_musicVol = _musicSoundTransform.volume = value;
				_musicChannel.soundTransform = _musicSoundTransform;
			}
		}

		public static function get musicMuted():Boolean
		{
			return _musicMuted;
		}
		
		/****************************************************************************************/
	}
}

class Singleton{}