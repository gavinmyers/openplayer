package com.openplayer
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class SearchResult extends EventDispatcher
	{
		public function SearchResult(t,d,i,a) {
			this.title = t;
			this.description = d;
			this.identifier = i;
			this.avg_rating = a;
		}
		
		[Bindable]
		public var image:String = "";
		
		[Bindable]
		public var title:String;
		
		[Bindable]
		public var description:String;
		
		[Bindable]
		public var identifier:String;
		
		[Bindable]
		public var avg_rating:String;
		
		[Bindable]
		public var fileResults:ArrayCollection;
	}
}