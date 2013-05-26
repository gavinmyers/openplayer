package com.openplayer
{
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ProfileManager extends EventDispatcher
	{
		private static var _ProfileManager:ProfileManager;
		
		private var version:String = "0.0.1";
		
		private var _HTTPService:HTTPService;
		
		public function ProfileManager()
		{
			this._HTTPService = new HTTPService();
			this._HTTPService.addEventListener(ResultEvent.RESULT, ArchiveManager.responseHTTP);
			this._HTTPService.addEventListener(FaultEvent.FAULT, ArchiveManager.responseHTTPError);
		}
		
		public static function getInstance():ProfileManager {
			if(_ProfileManager == null) {
				_ProfileManager = new ProfileManager();
			}
			return _ProfileManager;
		}
		
		public static function version():String {
			return ProfileManager.getInstance().version;
		}
		
		public static function alive():Boolean {
			return false;
		}
		
		public static function responseHTTPError(event:FaultEvent):void {
			
		}
		public static function responseHTTP(event:ResultEvent):void {
			
		}

	}
}