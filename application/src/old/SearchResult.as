package
{
	[Bindable]
	public class SearchResult
	{
		public function SearchResult(t,d,i,a) {
			this.title = t;
			this.description = d;
			this.identifier = i;
			this.avg_rating = a;
		}
		public var title:String;
		public var description:String;
		public var identifier:String;
		public var avg_rating:String;
		
	}
}