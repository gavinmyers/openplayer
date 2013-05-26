package com.openplayer
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class PlaylistManager extends EventDispatcher
	{
		[Bindable]
		public static var IsPlaying:Boolean = true;
		
		[Bindable]
		public static var _Files:ArrayCollection = new ArrayCollection();

	}
}