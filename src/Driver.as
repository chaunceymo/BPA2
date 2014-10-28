package
{
    import org.flixel.*;

    public class Driver extends FlxState
    {
        [Embed(source="../assets/crosshair.png")]
        protected var crosshairImage:Class;

        protected var level:Level = null;
        protected var levelName:String = null;

        protected var mode:int = Driver.MODE_NONE;
        protected var ticks:int = 0;
        protected var totalTicks:int = 0;

        public static const MAX_TICKS_DEAD:int = 300;

        public static const MODE_NONE:int = 0;
        public static const MODE_PLAYING:int = 1;
        public static const MODE_DEAD:int = 2;
        public static const MODE_LEVEL_LOAD:int = 3;

        override public function create():void
        {
            FlxG.mouse.show(this.crosshairImage);
            this.declareLevels();
            this.levelName = "001";
            this.loadLevel();
        }

        protected function declareLevels():void
        {
            var level001:Level001;
        }

        public function setLevelName(levelName:String):void
        {
            this.levelName = levelName;
        }

        protected function loadLevel():void
        {
            FlxG.log("loadLevel - levelName = " + this.levelName);

            if (this.level != null) {
                this.level.destroyWorld();
                this.remove(this.level);
            }

            FlxG.camera.stopFX();
            FlxG.flash(0xffffffff, 1);

            var levelClass:Class = FlxU.getClass("Level" + this.levelName);
            this.level = new levelClass(this);
            this.add(this.level);

            this.level.onStart();
            this.setMode(Driver.MODE_PLAYING);
        }

        override public function update():void
        {
            this.level.onTick(this.mode, ++this.ticks);

            switch (this.mode) {

                case Driver.MODE_PLAYING:
                    
                    this.handleInput();
                    break;

                case Driver.MODE_DEAD:

                    if (this.ticks < Driver.MAX_TICKS_DEAD) {
                        /* do nothing */
                        break;
                    }

                    this.setMode(Driver.MODE_LEVEL_LOAD);
                    /* FALLTHROUGH */

                case Driver.MODE_LEVEL_LOAD:

                    FlxG.fade(0xffffffff, 1, this.loadLevel);
                    this.setMode(Driver.MODE_NONE);

                    break;

                case Driver.MODE_NONE:
                default:
                    /* do nothing */

            }

            super.update();
        }

        protected function handleInput():void
        {
            // gameplay/level key logic goes here
            this.level.handleInput();

            // any driver-specific/metagame key logic goes here
            if (FlxG.keys.justPressed("F1")) {
                // do a help dialog
            }
        }

        public function setMode(mode:int):void
        {
            this.totalTicks += this.ticks;
            this.ticks = 0;
            this.mode = mode;
        }

    }
}
