package 
{
    import mx.collections.ArrayCollection;
    
    [Bindable]
    public class MusicModelLocator
    {
        /* This code is always the same for a ModelLocator. */
        private static var modelLocator:MusicModelLocator;
        public static function getInstance():MusicModelLocator{
            if(modelLocator == null){
                modelLocator = new MusicModelLocator();
            }
            return modelLocator;
        }
        
        /*Declare each data item you want to manage here */
        public var nowPlayingList:ArrayCollection;
    }
}