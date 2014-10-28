package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class BOOLIT extends B2FlxSprite
    {
        public static const FLIGHT_SPEED:Number = 25.0;

        [Embed(source="../assets/BOOLIT.png")]
        protected var boolitImage:Class;
        
        public var airThrust:b2Vec2;
        public var airAngle:Number = 0;

        public function BOOLIT(x:int, y:int, angle:Number, w:b2World)
        {
			this.density = .000001;
			this.friction = .000001;
            super(x, y, 4, 4, w);
			
            this.body.SetAngle(angle);
            this.airAngle = angle;
            this.loadGraphic(boolitImage, true, true, 4, 4);
            
            var coords:Array = new Array();
            coords[0] = new b2Vec2(-2 * Level.METERS_PER_PIXEL, -2 * Level.METERS_PER_PIXEL);
            coords[1] = new b2Vec2(-2 * Level.METERS_PER_PIXEL, 2 * Level.METERS_PER_PIXEL);
            coords[2] = new b2Vec2(2 * Level.METERS_PER_PIXEL, 2 * Level.METERS_PER_PIXEL);
            coords[3] = new b2Vec2(2 * Level.METERS_PER_PIXEL, -2 * Level.METERS_PER_PIXEL);

            this.createBody(b2PolygonShape.AsArray(coords, 4));

            var mass:b2MassData = new b2MassData();
            this.body.GetMassData(mass);
            mass.center = new b2Vec2(.5 * Level.METERS_PER_PIXEL, 0);
            this.body.SetMassData(mass);
            
            this.airThrust = new b2Vec2(Math.cos(this.airAngle), Math.sin(this.airAngle));
            this.airThrust.Multiply(BOOLIT.FLIGHT_SPEED);
            this.airThrust.Multiply(this.body.GetMass());
            this.body.SetLinearVelocity(this.airThrust);
            
            //apply an extra vector to negate gravity
            var gravityNegation:b2Vec2 = new b2Vec2(-this.world.GetGravity().x, -this.world.GetGravity().y);
            gravityNegation.Multiply(this.body.GetMass());
            this.body.ApplyForce(gravityNegation, this.body.GetWorldCenter());
            
            this.body.SetUserData("BOOLIT");
            
        }
       
        override public function update():void
        {
            if(this.body.GetUserData() == "COLLISION" || !this.onScreen())
                this.kill();
            else
            {
                this.airThrust = new b2Vec2(Math.cos(this.airAngle), Math.sin(this.airAngle));
                this.airThrust.Multiply(BOOLIT.FLIGHT_SPEED);
                this.airThrust.Multiply(this.body.GetMass());
                this.body.ApplyForce(this.airThrust, this.body.GetWorldCenter());
                
                //apply an extra vector to negate gravity
                var gravityNegation:b2Vec2 = new b2Vec2(-this.world.GetGravity().x, -this.world.GetGravity().y);
                gravityNegation.Multiply(this.body.GetMass());
                this.body.ApplyForce(gravityNegation, this.body.GetWorldCenter());
                
                super.update();
            }
        }
    }
}
