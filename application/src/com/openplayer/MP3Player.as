/*
    MP3Player version 0.1
    
    Simple mp3 player.
    
    use:
    - url, pathe to the mp3-file;
    - autoAutplay;
    
    properties you can read:
    - id3, info;
    - length, length in ms;
    - sLength, formatted length "0.00";
    - sPosition, formatted position "0.00";
    - position, position in ms;
    - pMinutes, position minutes;
    - pSeconds, position seconds;
    
    TODO:
    - set position, this is for example for slider-drag;
    - volume;
    - pan;
    - and other cool stuff
    - boring stuff like documentation
    
    Created by Maikel Sibbald
    info@flexcoders.nl
    http://labs.flexcoders.nl
    
    Free to use.... just give me some credit
*/

package com.openplayer{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.media.ID3Info;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    import mx.core.UIComponent;
    
    public class MP3Player extends UIComponent{
        
        [Bindable]public var id3:ID3Info;
        [Bindable]public var length:Number;
        [Bindable]public var sLength:String        = "0.00";
        [Bindable]public var sPosition:String     = "0.00";
        [Bindable]public var pMinutes:Number     = 0;
        [Bindable]public var pSeconds:Number     = 0;
        [Bindable]public var position:Number     = 0;
        
        private var _url:String;
        private var _autoPlay:Boolean;
        private var _isPlaying:Boolean;
        private var _volume:Number                 = 0;
        
        public var soundInstance:Sound;
        private var soundChannelInstance:SoundChannel;
        private var urlRequest:URLRequest;
        private var pausePosition:Number;
        private var soundBytes:ByteArray;
        
        public var _FileResult:FileResult;

        public function MP3Player():void{
            this.explicitHeight = 100;
            this.soundInstance = new Sound();
            this.setupListeners();
        }

        public function set url(value:String):void{
        	            
			try
			{
			 this.stop();			
			}
			catch (err:Error)
			{
			 // code to react to the error
			}
			finally
			{
			}
			
            this._url = value;
            this.urlRequest = new URLRequest(this._url);
            
			this.soundInstance = new Sound();
			this.setupListeners();
            this.soundInstance.load(this.urlRequest);
            this.length = this.soundInstance.length;
        }
        
        public function get url():String{
            return _url;
        }
        
        public function set autoPlay(value:Boolean):void{
            this._autoPlay = value;
        }
        public function get autoPlay():Boolean{
            return this._autoPlay;
        }
        public function set volume(value:Number):void{
            /* this._volume = value;
            if(this.soundChannelInstance != null){
                this.soundChannelInstance.soundTransform.volume = this._volume;
            } */
        }
        
        public function get isPlaying():Boolean{
            return this._isPlaying;
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
            if(this._autoPlay && !this._isPlaying){
                this.play();
            }
        }
        /******************************************CONTROLS***********************************************/
        private function setupListeners():void{
            this.soundInstance.addEventListener(Event.COMPLETE, completeHandler);
            this.soundInstance.addEventListener(Event.OPEN, openHandler);
            this.soundInstance.addEventListener(Event.ID3, id3Handler);
            this.soundInstance.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            this.soundInstance.addEventListener(ProgressEvent.PROGRESS, progressHandler);

            this.addEventListener( Event.ENTER_FRAME, function():void {
              if(soundChannelInstance != null){
                  position = soundChannelInstance.position;
                  pMinutes = Math.floor(soundChannelInstance.position / 1000 / 60);
                  pSeconds = Math.floor(soundChannelInstance.position / 1000) % 60;
                  sPosition = pMinutes+":"+(pSeconds < 10?"0"+pSeconds:pSeconds);
              }
            });
        }
        
        public function play():void{
            if(!this._isPlaying){
                this._isPlaying = true;
                this.soundChannelInstance = this.soundInstance.play(this.pausePosition);
                this.soundChannelInstance.soundTransform.volume = this._volume;
                this.soundChannelInstance.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);                
                this.pausePosition = null;
               
            }
        }
        
        public function playAt(pos:Number):void{
            if(!this._isPlaying){
                this._isPlaying = true;
                this.soundChannelInstance = this.soundInstance.play(pos);
                this.soundChannelInstance.soundTransform.volume = this._volume;
                this.soundChannelInstance.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);                
                this.pausePosition = null;
               
            }
        }
        
        public function pauze():void{
            this.pausePosition = this.soundChannelInstance.position;
            this.stop();
        }
        
        public function stop():void{
            this._isPlaying = false;
            
			try
			{
			 	this.soundChannelInstance.stop();
			 
			}
			catch (err:Error)
			{
			}
			finally
			{
			}

        }
    
        /******************************************HANDLERS***********************************************/
        private function completeHandler(event:Event):void {
            this.dispatchEvent(event);
        }
        
        private function openHandler(event:Event):void {
            this.dispatchEvent(event);
        }
        
        private function id3Handler(event:Event):void {
            this.id3 = this.soundInstance.id3;
        }
        
        public function soundCompleteHandler(event:Event):void {
        	this.dispatchEvent(event);
            this.stop();
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
           this.dispatchEvent(event);
        }

        private function progressHandler(event:ProgressEvent):void {

            if(this.soundInstance != null){
                this.length = this.soundInstance.length;
                var tempMinutes:Number = Math.floor(this.length  / 1000 / 60);
                var tempSeconds:Number = Math.floor(this.length  / 1000) % 60;
                
                this.sLength = tempMinutes+":"+(tempSeconds < 10?"0"+tempSeconds:tempSeconds);
             }
             this.dispatchEvent(event);
        }

    }
}