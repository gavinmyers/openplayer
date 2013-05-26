package com.openplayer
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	
	
	public class ArchiveManager extends EventDispatcher
	{
		private static var _ArchiveManager:ArchiveManager;
		
		private var version:String = "0.0.1";
		
		private var _HTTPSearchService:HTTPService;
		
		private var _HTTPSearchServiceSending:Boolean;
		
		private var _HTTPDetailService:HTTPService;
		
		private var _HTTPDetailServiceSending:Boolean;
		
		
      	private var itemURL:String = "http://www.mbticentral.com/openplayer/redirector.php?Action=ITEM&identifier=${identifier}";
      	
      	private var searchURL:String = "http://www.mbticentral.com/openplayer/redirector.php?Action=SEARCH&query=${query}";
      	
      	private var fileURL:String = "http://www.archive.org/download/${identifier}/${file}";
      			
		public function ArchiveManager()
		{
			this._HTTPSearchService = new HTTPService();
			this._HTTPSearchService.resultFormat = "e4x";
			this._HTTPSearchService.addEventListener(ResultEvent.RESULT, this.responseHTTPSearch);
			this._HTTPSearchService.addEventListener(FaultEvent.FAULT, this.responseHTTPSearchError);
			
			this._HTTPDetailService = new HTTPService();
			this._HTTPDetailService.resultFormat = "e4x";
			this._HTTPDetailService.addEventListener(ResultEvent.RESULT, this.responseHTTPDetail);
			this._HTTPDetailService.addEventListener(FaultEvent.FAULT, this.responseHTTPDetailError);
			
		}
		
		public static function getInstance():ArchiveManager {
			if(_ArchiveManager == null) {
				_ArchiveManager = new ArchiveManager();
			}
			return _ArchiveManager;
		}
		
		public static function getDynamicInstance():ArchiveManager {
			return new ArchiveManager();
		}
		
		//Generic Listener
		public static function listen(type:String, listener:Function):void {
			ArchiveManager.getInstance().addEventListener(type, listener);
		}
		
		//Generic Unlistener
		public static function ignore(type:String, listener:Function):void {
			ArchiveManager.getInstance().removeEventListener(type, listener);
		}
		
		//Generic Listener
		public function listen(type:String, listener:Function):void {
			this.addEventListener(type, listener);
		}
		
		//Generic Unlistener
		public function ignore(type:String, listener:Function):void {
			this.removeEventListener(type, listener);
		}
		
		public static function version():String {
			return ArchiveManager.getInstance().version;
		}
		
		public static function alive():Boolean {
			return false;
		}
		
		public static function search(str:String):void {
			var am:ArchiveManager = ArchiveManager.getInstance();
			am.search(str);
		}
		
		public function search(str:String):void {
			var temp:String = this.searchURL;
			temp = temp.replace("${query}",str);
			this._HTTPSearchService.url = temp;
			this._HTTPSearchService.send();
		}
		
		private var _SearchResult:SearchResult;
		
		public static function details(sr:SearchResult):void {
			var am:ArchiveManager = ArchiveManager.getInstance();
			am.details(sr);
		}
		
		public function details(sr:SearchResult):void {
			if(sr == null) {
				return;
			}
			this._SearchResult = sr;
			var temp:String = this.itemURL;
			temp = temp.replace("${identifier}",sr.identifier);
			trace(temp);
			this._HTTPDetailService.url = temp;
			this._HTTPDetailService.send();
		}
		
		public function responseHTTPSearchError(event:FaultEvent):void {
			trace("error");
			var e:ResultEvent = new ResultEvent("SEARCH_RESULT", false, true, new ArrayCollection(), null, null);
		}
		
		public function responseHTTPSearch(event:ResultEvent):void {
			var xmlList:XMLList = XML(event.result).result.doc;
			
			var a:ArrayCollection = new ArrayCollection();
			
            for each(var item:XML in xmlList) {
            	var xmlStr:XMLList = XML(item).str;
            	var description:String = item.str.(@name == "description");
            	
                a.addItem(new SearchResult(
                	item.str.(@name == "title"),
	                description.substr(0, 1500),
	                item.str.(@name == "identifier"),
	                item.float.(@name == "avg_rating")
	                	)
                	);
            }
            
            var e:ResultEvent = new ResultEvent("SEARCH_RESULT", false, true, a, null, null);
            ArchiveManager.getInstance().dispatchEvent(e);
			
		}
		
		public function responseHTTPDetailError(event:FaultEvent):void {
			trace("responseHTTPDetailError");
		}
		
		public function responseHTTPDetail(event:ResultEvent):void {
            	trace("responseHTTPDetail");
                var xmlList:XMLList = XML(event.result).file;
                
                var a:ArrayCollection = new ArrayCollection();
                
	            for each(var item:XML in xmlList) {
	            	
	            	var file:String = item.attribute("name");
	            	
	            	if(item.attribute("source") && item.attribute("source") == "original") {
	            		if(this._SearchResult.image == "" && file.substring(file.length - 3, file.length) == "jpg") {
	            			var image:String = ArchiveManager.getInstance().fileURL;
	            			image = image.replace("${file}", file);
	            			image = image.replace("${identifier}",this._SearchResult.identifier);
	            			this._SearchResult.image = image;
	            			
	            		}
	            	}
	            	
	            	if(file.substring(file.length - 3, file.length) == "mp3") {
	            		var url:String = this.fileURL;
	            		url = url.replace("${identifier}", this._SearchResult.identifier);
	            		url = url.replace("${file}", file);

		            	var title:String = file;
		            	var original:String = item.original;
		            	
		            	var test:String = item.title;
		            	if(test != "") {
		            		title = item.title;
		            	}
		            	if(title.length > 75) {
		            		title = title.substr(0, 75);
		            	}
		            	
						var found:Boolean = false;
		            	for each(var fr:FileResult in a) {
		            		if(fr.title == title || (fr.original == original && fr.original != "")) {
		            			found = true;
		            		}
		            	}
		            	
		            	if(!found) {
		            	
		            		var f:String = ArchiveManager.getInstance().fileURL;
		            		f = f.replace("${file}",file);
		            		f = f.replace("${identifier}",this._SearchResult.identifier);
		            		a.addItem(new FileResult(f, title, original, url, this._SearchResult));
		            		}
		            	}
	            	}
	            
            var e:ResultEvent = new ResultEvent("DETAIL_RESULT", false, true, a, null, null);
            ArchiveManager.getInstance().dispatchEvent(e);
            this.dispatchEvent(e);
		}

		
		
		

	}
}