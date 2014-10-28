package
{
    import org.flixel.*;

    import Box2D.Dynamics.b2ContactListener;
    import Box2D.Dynamics.Contacts.b2Contact;
    
    public class ContactListener extends b2ContactListener
    {
        override public function BeginContact(contact:b2Contact):void 
        {
            if(contact.GetFixtureA().GetBody().GetUserData() == "ACTOR" && contact.GetFixtureB().GetBody().GetUserData() == "CAVE_WALL")
            {
                contact.GetFixtureA().GetBody().SetUserData("WALL_COLLISION");
            }
            else if(contact.GetFixtureA().GetBody().GetUserData() == "CAVE_WALL" && contact.GetFixtureB().GetBody().GetUserData() == "ACTOR")
                contact.GetFixtureB().GetBody().SetUserData("WALL_COLLISION");
            else if(contact.GetFixtureA().GetBody().GetUserData() == "BOOLIT" && contact.GetFixtureB().GetBody().GetUserData() == "CAVE_WALL")
                contact.GetFixtureA().GetBody().SetUserData("COLLISION");
            else if(contact.GetFixtureA().GetBody().GetUserData() == "CAVE_WALL" && contact.GetFixtureB().GetBody().GetUserData() == "BOOLIT")
                contact.GetFixtureB().GetBody().SetUserData("COLLISION");
            else if(contact.GetFixtureA().GetBody().GetUserData() == "ACTOR" && contact.GetFixtureB().GetBody().GetUserData() == "BOOLIT")
            {
                contact.GetFixtureA().GetBody().SetUserData("BULLET_COLLISION");
                contact.GetFixtureB().GetBody().SetUserData("COLLISION");
            }
            else if(contact.GetFixtureA().GetBody().GetUserData() == "BOOLIT" && contact.GetFixtureB().GetBody().GetUserData() == "ACTOR")
            {
                contact.GetFixtureB().GetBody().SetUserData("BULLET_COLLISION");
                contact.GetFixtureA().GetBody().SetUserData("COLLISION");
            }
            else if(contact.GetFixtureA().GetBody().GetUserData() == "ACTOR" && contact.GetFixtureB().GetBody().GetUserData() == "ACTOR")
            {
                //actor on actor crime, what a shame
                contact.GetFixtureB().GetBody().SetUserData("ACTOR_COLLISION");
                contact.GetFixtureA().GetBody().SetUserData("ACTOR_COLLISION");
            }
        }
    }
}