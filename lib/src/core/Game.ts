module ganglere.core {


	// import CollisionSystem = ganglere.systems.CollisionSystem;
	// import ColorAnimationSystem = ganglere.systems.ColorAnimationSystem;
	// import EntitySpawningTimerSystem = ganglere.systems.EntitySpawningTimerSystem;
	// import ExpiringSystem = ganglere.systems.ExpiringSystem;
	// import HealthRenderSystem = ganglere.systems.HealthRenderSystem;
	// import HudRenderSystem = ganglere.systems.HudRenderSystem;
	// import MovementSystem = ganglere.systems.MovementSystem;
	// import ParallaxStarRepeatingSystem = ganglere.systems.ParallaxStarRepeatingSystem;
	// import PlayerInputSystem = ganglere.systems.PlayerInputSystem;
	// import RemoveOffscreenShipsSystem = ganglere.systems.RemoveOffscreenShipsSystem;
	// import ScaleAnimationSystem = ganglere.systems.ScaleAnimationSystem;
	// import SoundEffectSystem = ganglere.systems.SoundEffectSystem;
	import SpriteRenderSystem = ganglere.systems.SpriteRenderSystem;
	import World = artemis.World;
	// import GroupManager = artemis.managers.GroupManager;
	// import Constants = ganglere.core.Constants;

	export class Game {
	
		private world:World;
	
		private spriteRenderSystem:SpriteRenderSystem;
		// private healthRenderSystem:HealthRenderSystem;
		// private hudRenderSystem:HudRenderSystem;
		// //private batch:SpriteBatch;
		// private viewport;

		// private static ASPECT_RATIO = Constants.FRAME_WIDTH / Constants.FRAME_HEIGHT;
	
		constructor(public game:CCLayer) {
			this.game = game;

			this.world = new artemis.World();
	
			// this.world.setManager(new GroupManager());
			// this.world.setSystem(new MovementSystem());
			// this.world.setSystem(new PlayerInputSystem(game));
			// //this.world.setSystem(new SoundEffectSystem());
			// this.world.setSystem(new CollisionSystem(game));
			// this.world.setSystem(new ExpiringSystem());
			// this.world.setSystem(new EntitySpawningTimerSystem(game));
			// this.world.setSystem(new ParallaxStarRepeatingSystem());
			// this.world.setSystem(new ColorAnimationSystem());
			// this.world.setSystem(new ScaleAnimationSystem());
			// this.world.setSystem(new RemoveOffscreenShipsSystem());
	
			this.spriteRenderSystem = this.world.setSystem(new SpriteRenderSystem(game), true);
			// this.healthRenderSystem = this.world.setSystem(new HealthRenderSystem(game), true);
			// this.hudRenderSystem = this.world.setSystem(new HudRenderSystem(game), true);
	
			this.world.initialize();
	
			// EntityFactory.createPlayer(this.game, this.world, Constants.FRAME_WIDTH/4, Constants.FRAME_HEIGHT-80).addToWorld();
	
			// for (var i = 0; 5 > i; i++) {
			// 	EntityFactory.createStar(this.game, this.world).addToWorld();
			// }
	
		}
	
		public render(delta:number) {
			this.world.setDelta(delta);
			this.world.process();
	
			this.spriteRenderSystem.process();
			// this.healthRenderSystem.process();
			// this.hudRenderSystem.process();
		}
	
		
	}
}

