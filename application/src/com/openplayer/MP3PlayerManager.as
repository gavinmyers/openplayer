package com.openplayer
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class MP3PlayerManager extends EventDispatcher
	{
	
		private static var _MP3PlayerManager:MP3PlayerManager;
		
		private static var _MP3Players:ArrayCollection = new ArrayCollection();
		
		private static var _MP3Player:MP3Player;
		
		public static function getInstance():MP3PlayerManager {
			if(_MP3PlayerManager == null) {
				_MP3PlayerManager = new MP3PlayerManager();
			}
			return _MP3PlayerManager;
		}
		//Generic Listener
		public static function listen(type:String, listener:Function):void {
			MP3PlayerManager.getInstance().addEventListener(type, listener);
		}
		
		//Generic Unlistener
		public static function ignore(type:String, listener:Function):void {
			MP3PlayerManager.getInstance().removeEventListener(type, listener);
		}
		
		public static function register(mp3:MP3Player) {
			MP3PlayerManager.getInstance().register(mp3);	
		}
		
		public function register(mp3:MP3Player) {
			MP3PlayerManager._MP3Players.addItem(mp3);
		}
		
		public static function unregister(mp3:MP3Player) {
			MP3PlayerManager.getInstance().unregister(mp3);	
		}
		
		public function unregister(mp3:MP3Player) {
			MP3PlayerManager._MP3Players.removeItemAt(MP3PlayerManager._MP3Players.getItemIndex(mp3));
		}
		
		public static function stop() {
			MP3PlayerManager.getInstance().stop();
			
		}		
		public function stop() {
			if(MP3PlayerManager._MP3Player != null) {
				MP3PlayerManager._MP3Player.stop();
				MP3PlayerManager._MP3Player.dispatchEvent(new Event("STOP"));
				MP3PlayerManager._MP3Player._FileResult.dispatchEvent(new Event("STOP"));
			}
			this.dispatchEvent(new Event("STOP"));

		}
		
		public static function play(file:FileResult):MP3Player {
			
			var mp3:MP3Player = new MP3Player();
			mp3._FileResult = file;
			mp3.url = file.url;
			MP3PlayerManager.register(mp3);
			MP3PlayerManager.getInstance().play(mp3);
			return mp3;
			
		}
		
		public static function playAt(mp3:MP3Player, v:Number):MP3Player {
			
			MP3PlayerManager.getInstance().play(mp3, v);
			return mp3;
			
		}
		
        public function soundCompleteHandler(event:Event):void {

            this.stop();
            this.dispatchEvent(new Event(Event.SOUND_COMPLETE));
        }
        
		public function play(mp3:MP3Player, v:Number = 0) {
			MP3PlayerManager.stop();
			mp3.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
			if(v != 0) {
				mp3.playAt(v);
			} else {
				mp3.play();
			}
			MP3PlayerManager._MP3Player = mp3;
			MP3PlayerManager._MP3Player.dispatchEvent(new Event("PLAY"));
			trace("PLAY!");
			MP3PlayerManager._MP3Player._FileResult.dispatchEvent(new Event("PLAY"));
			this.dispatchEvent(new Event("PLAY"));
		}
		
		public static function getMP3Player():MP3Player {
			return MP3PlayerManager._MP3Player;
		}

	}
}