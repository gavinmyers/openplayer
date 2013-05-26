package com.openplayer
{
	import flash.events.EventDispatcher;
	
	public class FileResult extends EventDispatcher
	{
		public function FileResult(f, t, s, u, sr) {
			this.filename = f;
			this.title = t;
			this.original = s;
			this.url = u;
			this._SearchResult = sr;
		}
		public var filename:String;
		
		public var title:String;
		
		public var original:String;
		
		public var url:String;
		
		public var _SearchResult:SearchResult;
	}
}