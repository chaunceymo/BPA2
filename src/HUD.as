package
{
    import org.flixel.*;

    public class HUD extends FlxGroup
    {
        [Embed(source="../assets/artificial_horizon_inside.png")]
        protected var ahInsideImage:Class;

        [Embed(source="../assets/artificial_horizon_mask.png")]
        protected var ahMaskImage:Class;

        protected var ahOrigin:FlxPoint;
        protected var ahInside:FlxSprite;
        protected var ahMask:FlxSprite;

        public function HUD()
        {
            this.ahOrigin = new FlxPoint(Cave.SCREEN_WIDTH - 58, Cave.SCREEN_HEIGHT - 58);

            this.ahInside = new FlxSprite(this.ahOrigin.x, this.ahOrigin.y, this.ahInsideImage);
            this.ahInside.scrollFactor = new FlxPoint(0, 0);
            this.add(this.ahInside);

            this.ahMask = new FlxSprite(Cave.SCREEN_WIDTH - 64, Cave.SCREEN_HEIGHT - 64, this.ahMaskImage);
            this.ahMask.scrollFactor = new FlxPoint(0, 0);
            this.add(this.ahMask);
        }

        public function updateHorizon(pitch:Number, roll:Number):void
        {
            this.ahInside.y = this.ahOrigin.y + Math.round(Math.min(Math.max(pitch, -Math.PI / 4), Math.PI / 4) / (Math.PI / 4) * 5);
            this.ahInside.angle = roll;
        }
    }
}
