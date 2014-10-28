package
{
    import org.flixel.*;

    public class Level001 extends Level
    {
        [Embed(source="../assets/level001.map", mimeType="application/octet-stream")]
        protected var mapString001:Class;

        [Embed(source="../assets/level001.png")]
        protected var mapTiles001:Class;

        public function Level001(driver:Driver):void
        {
            this.mapString = this.mapString001;
            this.mapTiles = this.mapTiles001;
            super(driver);
        }

        override public function onStart():void
        {
            FlxG.log("level001 start");
        }
    }
}
