package {

  import org.flixel.*;

  public class MenuState extends FlxState {

    [Embed(source="../assets/tahoma.ttf", fontFamily="Tahoma", embedAsCFF="false")] public var FontTahoma:String;

    protected var title:FlxText;
    protected var action:FlxText;
	protected var help:FlxText;
	protected var credits1:FlxText;
	protected var credits2:FlxText;
    protected var starting:Boolean = false;

    override public function create():void {

      this.title = new FlxText(0, FlxG.height / 2, FlxG.width, "Biplace Ace: Europe");
      this.title.setFormat("Tahoma", 32, 0xffffff, "center", 0);
      this.add(this.title);

	  this.help = new FlxText(0, FlxG.height - 75, FlxG.width, "[ decreases throttle, ] increases throttle, m fires machine gun, space cuts throttle, mouse controls pitch");
      this.help.setFormat("Tahoma", 12, 0xffffff, "center", 0);
      this.add(this.help);
	  
	  this.credits1 = new FlxText(0, FlxG.height - 45, FlxG.width, "lead programmer, tech lead, design: phat_joe");
      this.credits1.setFormat("Tahoma", 12, 0xffffff, "center", 0);
      this.add(this.credits1);

	  this.credits2 = new FlxText(0, FlxG.height - 31, FlxG.width, "director, lead designer, programmer: chauncey_mo");
      this.credits2.setFormat("Tahoma", 12, 0xffffff, "center", 0);
      this.add(this.credits2);

	  
      this.action = new FlxText(0, FlxG.height - 16, FlxG.width, "click anywhere to start");
      this.action.setFormat("Tahoma", 12, 0xffffff, "center", 0);
      this.add(this.action);

	  
	  
    }

    override public function update():void {

      super.update();

      if(!this.starting && FlxG.mouse.justPressed()) {
        this.starting = true;
        this.action.text = "starting...";
        this.action.color = 0xffaa0000;
        FlxG.fade(0xff000000, 1, this.startGame);
      }

    }

    protected function startGame():void {
      FlxG.switchState(new Driver());
    }

  }

}
