package {

    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class B2FlxTilemap extends FlxTilemap {

        protected var world:b2World;
        protected var ratio:Number;
        protected var bodies:Array = new Array();
        
        public function B2FlxTilemap(world:b2World, ratio:Number = 0):void {

            this.world = world;

            if (ratio == 0) {
                this.ratio = Level.METERS_PER_PIXEL;
            } else {
                this.ratio = ratio;
            }

            super();
        }

        override public function loadMap(MapData:String, TileGraphic:Class, TileWidth:uint = 0, TileHeight:uint = 0, AutoTile:uint = FlxTilemap.OFF, StartingIndex:uint = 0, DrawIndex:uint = 1, CollideIndex:uint = 1):FlxTilemap
        {
            this.destroyBodies();

            super.loadMap(MapData, TileGraphic, TileWidth, TileHeight, AutoTile, StartingIndex, DrawIndex, CollideIndex);

            for (var r:uint = 0; r < this.heightInTiles; r++) {

                for (var c:uint = 0; c < this.widthInTiles; c++) {

                    if (this._data[r * this.widthInTiles + c] < CollideIndex) {
                        continue;
                    }

                    var bodyDef:b2BodyDef = new b2BodyDef();
                    bodyDef.position.Set((this.x + (c + 0.5) * this._tileWidth) * this.ratio, (this.y + (r + 0.5) * this._tileHeight) * this.ratio);
                    bodyDef.type = b2Body.b2_staticBody;

                    var body:b2Body = this.world.CreateBody(bodyDef);
                    body.CreateFixture2(b2PolygonShape.AsBox(this._tileWidth / 2 * this.ratio, this._tileHeight / 2 * this.ratio));
                    body.SetUserData("CAVE_WALL");

                }
            }

            return this as FlxTilemap;
        }

        public function destroyBodies():void
        {
            var len:int = this.bodies.length;

            for (var i:int = len - 1; i >= 0; i--) {
                this.world.DestroyBody(this.bodies[i]);
            }

            this.bodies = new Array();
        }
    }
}
