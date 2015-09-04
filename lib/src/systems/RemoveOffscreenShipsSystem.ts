module ganglere.systems {
	
	import Bounds = ganglere.components.Bounds;
	import Health = ganglere.components.Health;
	import Player = ganglere.components.Player;
	import Position = ganglere.components.Position;
	import Velocity = ganglere.components.Velocity;
	import Constants = ganglere.core.Constants;
	
	import Aspect = artemis.Aspect;
	import ComponentMapper = artemis.ComponentMapper;
	import Entity = artemis.Entity;
	import IntervalEntityProcessingSystem = artemis.systems.IntervalEntityProcessingSystem;
	import Mapper = artemis.annotations.Mapper;
	
	export class RemoveOffscreenShipsSystem extends IntervalEntityProcessingSystem {
		@Mapper(Position) pm:ComponentMapper<Position>;
		@Mapper(Bounds) bm:ComponentMapper<Bounds>;
	
		constructor() {
			super(Aspect.getAspectForAll(Velocity, Position, Health, Bounds), 5);
		}
	
		
		public processEach(e:Entity) {
			var position:Position = this.pm.get(e);
			var bounds:Bounds = this.bm.get(e);

			if(position.y < Constants.FRAME_HEIGHT/-bounds.radius) {
				e.deleteFromWorld();
			}
		}
	
	}
}

