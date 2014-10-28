package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class Actor extends B2FlxSprite
    {

        protected var fireRateCounter:Number = 0;
        protected var fireInterval:Number = 60; //~2 seconds as a default
        protected var hp:Number = 1;

        public function Actor(x:int, y:int, width:int, height:int, w:b2World)
        {
            super(x, y, width, height, w);
            
        }

        //TODO: destroy function with nice explosion
        
        public function applyDamage(damage:int):void
        {
            this.hp -= damage;
            if(this.hp <= 0)
                this.destroy();
        }
        
        public function shouldFire():Boolean
        {
            return (0 == this.fireRateCounter);
        }
        
        public function fireMachineGun():void
        {
            //defined in concrete class
        }
        
        override public function update():void
        {
            if(this.body.GetUserData() == "WALL_COLLISION")
            {
                FlxG.log("wall collide");
                this.body.SetUserData("ACTOR");
                this.applyDamage(999);
            }
            else if(this.body.GetUserData() == "BULLET_COLLISION")
            {
                FlxG.log("BOOLIT collide");
                this.body.SetUserData("ACTOR");
                this.applyDamage(1);
            }
            else if(this.body.GetUserData() == "ACTOR_COLLISION")
            {
                FlxG.log("actor collide");
                this.body.SetUserData("ACTOR");
                this.applyDamage(5);
            }
            else
            {
                super.update();
                
                if(this.fireRateCounter > 0) 
                    this.fireRateCounter--;
            }
        }
    }
}
