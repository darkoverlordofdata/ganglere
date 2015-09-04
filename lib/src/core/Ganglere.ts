module ganglere.core {
  
  export class Ganglere extends CCLayer {
  
    public game:Game;
  
    /**
      * Start the menu
      * @return {cc.Scene} the menu scene
      */
    public static start(): cc.Scene {
        var scene = new cc.Scene();
        scene.addChild(new Ganglere(scene));
        return scene;
    }
      
    /**
     *
     * @constructor
     * @extends {cc.Layer}
     * @param {cc.Scene} scene
     */
    constructor(public scene) {
        super();
        return new (cc.Layer.extend(this));
    }
 
    ctor() {
        this._super();
        this.game = new Game(this);
        //setScreen(gameScreen);
        this.scheduleUpdate();
    }
  
    update(time:number) {
      this.game.render(time);
    }
  }
}

