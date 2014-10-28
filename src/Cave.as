package
{
    import org.flixel.*;

    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class Cave extends FlxGame
    {
        public static const SCREEN_WIDTH:int = 320;
        public static const SCREEN_HEIGHT:int = 240;
        public static const SCREEN_ZOOM:int = 2;
        public static const SCREEN_CENTER_X:int = 160;
        public static const SCREEN_CENTER_Y:int = 120;

        public function Cave()
        {
            super(Cave.SCREEN_WIDTH, Cave.SCREEN_HEIGHT, MenuState, Cave.SCREEN_ZOOM);
            FlxG.debug = true;
            FlxG.setDebuggerLayout(FlxG.DEBUGGER_BIG);
        }
    }
}
