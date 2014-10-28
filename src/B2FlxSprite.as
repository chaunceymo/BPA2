package
{
    import org.flixel.*;
 
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
 
    public class B2FlxSprite extends FlxSprite
    {
        public var world:b2World;
        public var ratio:Number;
        public var fixDef:b2FixtureDef;
        public var bodyDef:b2BodyDef;
        public var body:b2Body = null;
        public var bodyType:uint = b2Body.b2_dynamicBody;
        public var friction:Number = 0.8;
        public var restitution:Number = 0.3;
        public var density:Number = 0.7;

        public function B2FlxSprite(x:Number, y:Number, width:Number, height:Number, world:b2World, ratio:Number = 0):void
        {
            super(x, y);
            this.width = width;
            this.height = height;
            this.world = world;
            if (ratio == 0) {
                this.ratio = Level.METERS_PER_PIXEL;
            } else {
                this.ratio = ratio;
            }
            this.createBody();
        }
        
        override public function update():void
        {
            this.x = this.body.GetPosition().x / this.ratio - this.width / 2;
            this.y = this.body.GetPosition().y / this.ratio - this.height / 2;
            this.angle = this.body.GetAngle() * 180 / Math.PI;
            super.update();
        }
        
        public function createBody(shape:b2PolygonShape = null):void
        {
            if (this.body != null) {
                this.world.DestroyBody(this.body);
            }

            this.fixDef = new b2FixtureDef();
            this.fixDef.density = this.density;
            this.fixDef.restitution = this.restitution;
            this.fixDef.friction = this.friction;

            if (shape == null) {
                this.fixDef.shape = b2PolygonShape.AsBox(this.width / 2 * ratio, this.height / 2 * ratio);
            } else {
                this.fixDef.shape = shape;
            }

            this.bodyDef = new b2BodyDef();
            this.bodyDef.position.Set((this.x + this.width / 2) * this.ratio, (this.y + this.height / 2) * this.ratio);
            this.bodyDef.angle = this.angle * Math.PI / 180;
            this.bodyDef.type = this.bodyType;

            this.body = this.world.CreateBody(this.bodyDef);
            this.body.CreateFixture(this.fixDef);
        }
    }
}
