module ganglere.components {
	
	import Component = artemis.Component;

	export enum Layer {
		DEFAULT,
		BACKGROUND,
		ACTORS_1,
		ACTORS_2,
		ACTORS_3,
		PARTICLES
		
		// getLayerId() {
		// 	return ordinal();
		// }
	};
	
	export class Sprite extends Component {
    public static className = 'Sprite';
		public layer:Layer;
		
		public name_:string;
		public scaleX_:number;
		public scaleY_:number;
		public rotation_:number;
		public r_:number;
		public g_:number;
		public b_:number;
		public a_:number;
		public sprite_:cc.Sprite;
		
			// public int getLayerId() {
			// 	return ordinal();
			// }
			
		constructor() {
			super();
			this.sprite_ = new cc.Sprite();
			this.sprite_.setScale(0.5);
      this.sprite_.setOpacityModifyRGB(true);
		}
			
		get name():string {return this.name_;}
		set name(value:string) {
			this.name_ = value;
      this.sprite_.initWithSpriteFrameName(`${value}.png`);
		}
		
		get scaleX():number {return this.sprite_.getScaleX();}
		set scaleX(value:number) {this.sprite_.setScaleX(value);}

		get scaleY():number {return this.sprite_.getScaleY();}
		set scaleY(value:number) {this.sprite_.setScaleY(value);}
		
		get rotation():number {return this.sprite_.getRotation();}
		set rotation(value:number) {this.sprite_.setRotation(value);}
		
		get r():number {return this.r_;}
		set r(value:number) {
			this.r_ = value;
			this.sprite_.setColor(cc.color(this.r_, this.g_, this.b_));
		}
		
		get g():number {return this.g_;}
		set g(value:number) {
			this.g_ = value;
			this.sprite_.setColor(cc.color(this.r_, this.g_, this.b_));
		}
		
		get b():number {return this.b_;}
		set b(value:number) {
			this.b_ = value;
			this.sprite_.setColor(cc.color(this.r_, this.g_, this.b_));
		}
		
		get a():number {return this.a_;}
		set a(value:number) {
			this.a_ = value;
			this.sprite_.setColor(cc.color(this.r_, this.g_, this.b_, this.a_));
		}

    addTo(layer:CCLayer) {
      layer.addChild(this.sprite_);
    }

    removeFrom(layer:CCLayer) {
      layer.removeChild(this.sprite_);
    }


	}

	Sprite.prototype.layer = Layer.DEFAULT;
	Sprite.prototype.name_ = '';
	Sprite.prototype.scaleX_ = 1;
	Sprite.prototype.scaleY_ = 1;
	Sprite.prototype.rotation_ = 0;
	Sprite.prototype.r_ = 255;
	Sprite.prototype.g_ = 255;
	Sprite.prototype.b_ = 255;
	Sprite.prototype.a_ = 255;
	Sprite.prototype.sprite_ = null;
}

