package
{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class Level extends FlxGroup
    {
        public static const TILE_WIDTH:int = 16;
        public static const TILE_HEIGHT:int = 16;
        public static const METERS_PER_PIXEL:Number = 0.2;

        public var mapString:Class;
        public var mapTiles:Class;

        public var map:B2FlxTilemap;

        public var dolly:FlxSprite;

        public var driver:Driver;
        public var world:b2World;

        public var player:PlayerPlane;

        protected var lastMousePos:FlxPoint;
        
        private var boolits:FlxGroup = new FlxGroup();
		private var explosions:FlxGroup = new FlxGroup();
		
        public function Level(driver:Driver):void
        {
            super();

            this.driver = driver;
            this.world = new b2World(new b2Vec2(0.0, 9.8), true);
            this.loadMap();

            var gameContactListener:ContactListener = new ContactListener();
            this.world.SetContactListener(gameContactListener);
            
            this.player = new PlayerPlane(-20, 140, this.world, this);
            this.add(this.player);
            
            var testZeppelin:Zeppelin = new Zeppelin(230, 140, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
            
			testZeppelin = new Zeppelin(300, 55, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(440, 80, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(800, 130, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(1200, 150, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
            testZeppelin = new Zeppelin(1450, 50, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(1450, 130, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);


			testZeppelin = new Zeppelin(1600, 60, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(1660, 120, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(1720, 160, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2200, 20, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2200, 75, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2200, 130, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2200, 185, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2500, 170, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2550, 125, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2600, 90, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2650, 55, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			
			testZeppelin = new Zeppelin(2700, 20, this.world, instantiateBOOLIT, this);
            this.add(testZeppelin);
			

            this.add(this.player.hud);

            this.lastMousePos = FlxG.mouse.getScreenPosition();
            FlxG.worldBounds = new FlxRect(0, 0, this.map.width, this.map.height);
            FlxG.camera.setBounds(0, 0, this.map.width, this.map.height);
            FlxG.camera.follow(this.player);
            
            this.add(boolits);
			this.add(explosions);
        }

        public function loadMap():void
        {
            this.map = new B2FlxTilemap(this.world, Level.METERS_PER_PIXEL);
            this.map.loadMap(new this.mapString, this.mapTiles, Level.TILE_WIDTH, Level.TILE_HEIGHT, FlxTilemap.OFF, 0, 0);
            this.add(this.map);

            this.dolly = new FlxSprite(0, 0);
            this.dolly.visible = false;
            this.add(this.dolly);
        }

        private function instantiateBOOLIT(x:int, y:int, angle:Number):void
        {
            //NOT WORKING :(
            //var instantiatedBOOLIT:BOOLIT = boolits.getFirstAvailable() as BOOLIT;
            
            //if (instantiatedBOOLIT == null)
            //{
                boolits.add(new BOOLIT(x, y, angle, this.world));
            //}
            //else
            //{
            //    instantiatedBOOLIT.revive();
            //    instantiatedBOOLIT.reset(x, y);
            //    instantiatedBOOLIT.body.SetAngle(angle);
            //}
        }
        
        public function onStart():void
        {
        }

        public function onTick(mode:int, ticks:int):void
        {
            if (mode == Driver.MODE_PLAYING) {
                this.world.Step(1 / 60, 10, 10);
                this.world.ClearForces();
                this.dolly.x = this.dolly.x + 1;
            }
        }

		public function createExplosion(x:int, y:int):void
		{
			explosions.add(new Explosion(x, y, this.world));
		}
		
		public function playerDied():void
		{
			this.driver.setMode(Driver.MODE_DEAD);
		}
		
        public function handleInput():void
        {
            if (FlxG.keys.justPressed("ESCAPE")) {
                this.player.eject();
                playerDied();
                return;
            }

            if (FlxG.keys.justPressed("Q")) {
                this.player.queueBomb();
            }

            if (FlxG.keys.justPressed("O")) {
                this.player.openBombBay();
            }

            if (FlxG.keys.justPressed("R")) {
                this.player.reloadMachineGun();
            }

            if (FlxG.keys.pressed("M")) {
                if(this.player.shouldFire()) //shoot from the front tip of the plane a bit below the top, and adjust angle for titled .png of plane
                    instantiateBOOLIT(this.player.x + 32, this.player.y + 3, this.player.body.GetAngle() - (Math.PI/18)); 
            }

            if (FlxG.keys.pressed("LBRACKET")) {
                this.player.adjustThrottle(-1);
            }

            if (FlxG.keys.pressed("RBRACKET")) {
                this.player.adjustThrottle(1);
            }

            if (FlxG.keys.pressed("SPACE")) {
                this.player.setThrottle(0);
            }

            var mousePos:FlxPoint = FlxG.mouse.getScreenPosition();

            if (mousePos.x < 0 || mousePos.x > Cave.SCREEN_WIDTH || mousePos.y < 0 || mousePos.y > Cave.SCREEN_HEIGHT) {
                mousePos = this.lastMousePos;
            }

            var mouseDiff:FlxPoint = new FlxPoint(
                mousePos.x - this.lastMousePos.x,
                mousePos.y - this.lastMousePos.y
            );

            this.lastMousePos = mousePos;

            this.player.roll(mouseDiff.x);
            this.player.pitch(mouseDiff.y);
        }

        public function destroyWorld():void
        {
            this.map.destroyBodies();
            this.world = null;
        }
    }
}
