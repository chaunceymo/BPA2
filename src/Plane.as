package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class Plane extends Actor
    {
        public static const DRAG_COEFFICIENT:Number = 0.08;
        public static const LIFT_COEFFICIENT:Number = 0.1;

        public static const THROTTLE_MIN:int = 0;
        public static const THROTTLE_MAX:int = 100;

        public static const PITCH_SPEED_MIN:Number = Math.PI / 400;
        public static const PITCH_SPEED_MAX:Number = Math.PI / 200;

        public static const ROLL_SPEED_MAX:Number = Math.PI / 8;
        public static const ROLL_SPEED_MIN:Number = Math.PI / 16;

        public static const AMMO_PER_RELOAD:int = 99;

        protected var planeImage:Class;
        protected var throttle:int = Plane.THROTTLE_MAX / 3;

        protected var bombsLeft:int = 3;
        protected var bombsQueued:int = 0;

        protected var ammoLeft:int = Plane.AMMO_PER_RELOAD;

        public var airAngle:Number;
        public var airVelocity:b2Vec2;
        public var airDrag:b2Vec2;
        public var airLift:b2Vec2;
        public var airThrust:b2Vec2;
        public var angleDiff:Number;

        public var isFiring:Boolean = false;

        public var pitchDirection:Number = 0;
        public var rollDirection:Number = 0;
        public var rollAngle:Number = 0;

        public function Plane(x:int, y:int, width:int, height:int, w:b2World)
        {
            super(x, y, width, height, w);
            this.loadGraphic(planeImage, true, false, width, height);

            this.addAnimation("flying", [0,1,2,1], 10, true);
            this.play("flying");
        }

        override public function update():void
        {
            this.airVelocity = this.body.GetLinearVelocity();
            var vsq:Number = this.airVelocity.LengthSquared();
            var vdir:b2Vec2 = this.airVelocity.Copy();
            vdir.Normalize();

            this.airAngle = this.body.GetAngle();
            var facing:b2Vec2 = new b2Vec2(Math.cos(this.airAngle), Math.sin(this.airAngle));

            var vangle:Number = Math.acos(vdir.x);

            this.angleDiff = this.airAngle - vangle;
            var absAngleDiff:Number = Math.abs(this.angleDiff);

            this.airDrag = vdir.GetNegative();

            if (absAngleDiff > Math.PI / 2) {
                // max drag, no lift
                this.airDrag.Multiply(vsq * Plane.DRAG_COEFFICIENT);
                this.airLift = new b2Vec2(0, 0);
            } else {
                // higher angle diff means more drag, less lift
                // for angle diff from 0 - PI / 2:
                // drag multiplier from PI / 4 - PI / 2
                this.airDrag.Multiply(vsq * Plane.DRAG_COEFFICIENT * (absAngleDiff / 2 + Math.PI / 4));
                // lift multiplier from PI / 2 - 0
                this.airLift = new b2Vec2(vdir.y, -vdir.x);
                this.airLift.Multiply(vsq * Plane.LIFT_COEFFICIENT * (Math.PI / 2 - absAngleDiff));
            }

            this.airThrust = facing.Copy();
            this.airThrust.Multiply(20.0 * this.throttle / Plane.THROTTLE_MAX);

            var force:b2Vec2 = this.airDrag.Copy();
            force.Add(this.airLift);
            force.Add(this.airThrust);
            force.Multiply(this.body.GetMass());

            this.body.ApplyForce(force, this.body.GetWorldCenter());

            var pitchSpeed:Number = Plane.PITCH_SPEED_MIN;

            if (absAngleDiff < Math.PI / 4) {
                pitchSpeed = pitchSpeed + (Plane.PITCH_SPEED_MAX - Plane.PITCH_SPEED_MIN) * (1 - (absAngleDiff / (Math.PI / 4)));
            }

            if (this.pitchDirection > 0) {
                this.body.SetAngle(this.airAngle - pitchSpeed);
            } else if (this.pitchDirection < 0) {
                this.body.SetAngle(this.airAngle + pitchSpeed);
            }

            if (this.rollDirection == 0) {
                if (this.rollAngle > 0) {
                    this.rollAngle = this.rollAngle - Plane.ROLL_SPEED_MIN;
                } else if (this.rollAngle < 0) {
                    this.rollAngle = this.rollAngle + Plane.ROLL_SPEED_MIN;
                }
            } else {
                this.rollAngle = this.rollAngle + Plane.ROLL_SPEED_MAX * this.rollDirection;
                if (Math.abs(this.rollAngle) >= 20) {
                    this.DOABARRELROLL();
                }
            }

            super.update();
        }

        public function setThrottle(t:int):void
        {
            if (t <= Plane.THROTTLE_MIN) {
                this.throttle = Plane.THROTTLE_MIN;
            } else if (t >= Plane.THROTTLE_MAX) {
                this.throttle = Plane.THROTTLE_MAX;
            } else {
                this.throttle = t;
            }
        }

        public function adjustThrottle(dt:int):void
        {
            this.setThrottle(this.throttle + dt);
        }

        public function pitch(pitchTarget:Number):void
        {
            if (pitchTarget == 0) {
                this.pitchDirection = 0;
            } else if (pitchTarget > 0) {
                this.pitchDirection = 1;
            } else {
                this.pitchDirection = -1;
            }
        }

        public function roll(rollTarget:Number):void
        {
            if (rollTarget == 0) {
                this.rollDirection = 0;
            } else if (rollTarget > 0) {
                this.rollDirection = 1;
            } else {
                this.rollDirection = -1;
            }
        }

        public function eject():void
        {
            FlxG.log("EJECT!");
        }

        public function queueBomb():void
        {
            if (this.bombsLeft > 0) {
                --this.bombsLeft;
                ++this.bombsQueued;
                FlxG.log("BOMBS READY, BUDDY!");
            } else {
                FlxG.log("no bombs left!");
            }
        }

        public function openBombBay():void
        {
            FlxG.log("PILOT TO BOMBARDIER, PILOT TO BOMBARDIER");
            this.bombsQueued = 0;
        }

        public function reloadMachineGun():void
        {
            FlxG.log("reload machine gun");
            this.ammoLeft = Plane.AMMO_PER_RELOAD;
        }

        override public function fireMachineGun():void
        {
            
        }

        public function DOABARRELROLL():void
        {
            FlxG.log("DO A BARREL ROLL!");
        }
    }
}
