package
{
    import flash.events.*;
    import flash.ui.Keyboard;
	import flash.utils.*;
    
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class PlayerPlane extends Plane
    {
        [Embed(source="../assets/playerplane.png")]
        protected var playerPlaneImage:Class;
		
		protected var levelController:Level;
		
        public var hud:HUD;

        public function PlayerPlane(x:int, y:int, w:b2World, containingLevel:Level)
        {
            this.planeImage = this.playerPlaneImage;

            super(x, y, 32, 16, w);

			this.levelController = containingLevel;
			
            var coords:Array = new Array();
            coords[0] = new b2Vec2(-16 * Level.METERS_PER_PIXEL, -1 * Level.METERS_PER_PIXEL);
            coords[1] = new b2Vec2(5 * Level.METERS_PER_PIXEL, -8 * Level.METERS_PER_PIXEL);
            coords[2] = new b2Vec2(14 * Level.METERS_PER_PIXEL, -6 * Level.METERS_PER_PIXEL);
            coords[3] = new b2Vec2(16 * Level.METERS_PER_PIXEL, 2 * Level.METERS_PER_PIXEL);
            coords[4] = new b2Vec2(9 * Level.METERS_PER_PIXEL, 8 * Level.METERS_PER_PIXEL);
            coords[5] = new b2Vec2(-15 * Level.METERS_PER_PIXEL, 5 * Level.METERS_PER_PIXEL);

            this.createBody(b2PolygonShape.AsArray(coords, 6));
            
            this.hp = 3;
            
            var mass:b2MassData = new b2MassData();
            this.body.GetMassData(mass);
            mass.center = new b2Vec2(6 * Level.METERS_PER_PIXEL, 0);
            this.body.SetMassData(mass);

            this.body.SetLinearVelocity(new b2Vec2(9.0, 0.0));

            this.hud = new HUD();

            FlxG.watch(this, "angleDiff", "angleDiff");
            FlxG.watch(this, "airAngle", "airAngle");
            FlxG.watch(this, "airVelocity", "airVelocity");
            FlxG.watch(this, "airDrag", "airDrag");
            FlxG.watch(this, "airLift", "airLift");
            FlxG.watch(this, "airThrust", "airThrust");
            
            this.body.SetUserData("ACTOR");
        }

        override public function shouldFire():Boolean
        {
            if(super.shouldFire() && (this.ammoLeft > 0)) {
                --this.ammoLeft;
                this.fireRateCounter = this.fireInterval;
                return true;
            } else {
                return false;
            }
        }

        override public function update():void
        { 
            super.update();
            this.hud.updateHorizon(this.body.GetAngle(), this.rollAngle);
        }
	
		private function explosionDone():void
		{

            FlxG.unwatch(this);
            this.world.DestroyBody(this.body);
            super.destroy();
		}
		
        override public function destroy():void
        {
            this.visible = false;
		    levelController.createExplosion(this.x - 28, this.y - 34);
			levelController.playerDied();
		   
		    setTimeout(explosionDone, 1000);
		   
        }
    }
}
