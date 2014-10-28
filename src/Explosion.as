package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class Explosion extends B2FlxSprite
    {
        
        [Embed(source="../assets/explosion2.png")]
        protected var explosionImage:Class;

        public function Explosion(x:int, y:int, w:b2World)
        {
			
            super(x, y, 100, 62, w);
			
			this.loadGraphic(explosionImage, true, false, width, height);
			this.addAnimation("exploding", [0,1,2,3,4,5,6,7,8,9], 25, false);
            this.play("exploding");
			
            this.body.SetUserData("EXPLOSION");
            
        }  
		
        override public function update():void
        {
        
           //TODO: collisions
        
            
            super.update();
            
        }
    }
}
