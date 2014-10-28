package
{
    import flash.events.*;
    import flash.ui.Keyboard;
    
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;

    public class Zeppelin extends Actor
    {
        [Embed(source="../assets/zeppelin.png")]
        protected var zeppelinImage:Class;
        
        protected var bulletCallback:Function;

		protected var levelController:Level;
		
        public function Zeppelin(x:int, y:int, w:b2World, cb:Function, containingLevel:Level)
        {
			
            super(x, y, 64, 37, w);
            
			this.levelController = containingLevel;
			
            this.bulletCallback = cb;
            
            this.loadGraphic(zeppelinImage, true, false, 64, 37);

            this.fireInterval = 90; //zeppelins are pokey
            
			this.body.SetType(b2Body.b2_staticBody);
			
            this.body.SetUserData("ACTOR");
        }

        override public function shouldFire():Boolean
        {
            if(super.shouldFire() && this.onScreen()) {
                this.fireRateCounter = this.fireInterval;
                return true;
            } else {
                return false;
            }
        }

        override public function fireMachineGun():void
        {
            FlxG.log("zeppelin fire");
            bulletCallback(this.x-2, this.y+30, Math.PI);
        }
        
        override public function destroy():void
        {
			//levelController.createExplosion(this.x, this.y); not working
			
            this.kill();
            this.world.DestroyBody(this.body);
            super.destroy();
        }
        
       
        override public function update():void
        {
        
            if(this.shouldFire())
                this.fireMachineGun();
        
            
            super.update();
            
        }
       
    }
}
