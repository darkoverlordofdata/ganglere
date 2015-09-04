var ganglere;
(function (ganglere) {
    var core;
    (function (core) {
        var SoundEffect = ganglere.components.SoundEffect;
        var EFFECT = ganglere.components.EFFECT;
        var EntityFactory = (function () {
            function EntityFactory() {
            }
            EntityFactory.createPlayer = function (game, world, x, y) {
                var e = world.createEntity();
                // var position:Position = new Position();
                // position.x = x;
                // position.y = y;
                // e.addComponent(position);
                // var sprite:Sprite = new Sprite();
                // sprite.name = "fighter";
                // sprite.r = 93;
                // sprite.g = 255;
                // sprite.b = 129;
                // sprite.layer = Layer.ACTORS_3;
                // e.addComponent(sprite);
                // sprite.addTo(game);
                // var velocity:Velocity = new Velocity();
                // velocity.vectorX = 0;
                // velocity.vectorY = 0;
                // e.addComponent(velocity);
                // var bounds:Bounds = new Bounds();
                // bounds.radius = 43;
                // e.addComponent(bounds);
                // e.addComponent(new Player());
                // world.getManager<GroupManager>(GroupManager).add(e, Constants.Groups.PLAYER_SHIP);
                return e;
            };
            EntityFactory.createPlayerBullet = function (game, world, x, y) {
                var e = world.createEntity();
                // var position:Position = new Position();
                // position.x = x;
                // position.y = y;
                // e.addComponent(position);
                // var sprite:Sprite = new Sprite();
                // sprite.name = "bullet";
                // sprite.layer = Layer.PARTICLES;
                // e.addComponent(sprite);
                // sprite.addTo(game);
                // var velocity:Velocity = new Velocity();
                // velocity.vectorY = 800;
                // e.addComponent(velocity);
                // var bounds:Bounds = new Bounds();
                // bounds.radius = 5;
                // e.addComponent(bounds);
                // var expires:Expires = new Expires();
                // expires.delay = 5;
                // e.addComponent(expires);
                // var sf:SoundEffect = new SoundEffect();
                // sf.effect = EFFECT.PEW;
                // e.addComponent(sf);
                // world.getManager<GroupManager>(GroupManager).add(e, Constants.Groups.PLAYER_BULLETS);
                return e;
            };
            EntityFactory.createEnemyShip = function (game, world, name, layer, health, x, y, velocityX, velocityY, boundsRadius) {
                var e = world.createEntity();
                // var position:Position = new Position();
                // position.x = x;
                // position.y = y;
                // e.addComponent(position);
                // var sprite:Sprite = new Sprite();
                // sprite.name = name;
                // sprite.r = 255;
                // sprite.g = 0;
                // sprite.b = 142;
                // sprite.layer = layer;
                // e.addComponent(sprite);
                // sprite.addTo(game);
                // var velocity:Velocity = new Velocity();
                // velocity.vectorX = velocityX;
                // velocity.vectorY = velocityY;
                // e.addComponent(velocity);
                // var bounds:Bounds = new Bounds();
                // bounds.radius = boundsRadius;
                // e.addComponent(bounds);
                // var h:Health = new Health();
                // h.health = h.maximumHealth = health;
                // e.addComponent(h);
                // world.getManager<GroupManager>(GroupManager).add(e, Constants.Groups.ENEMY_SHIPS);
                return e;
            };
            EntityFactory.createSmallExplosion = function (game, world, x, y) {
                var e = this.createExplosion(game, world, x, y, 0.1);
                var sf = new SoundEffect();
                sf.effect = EFFECT.SMALLASPLODE;
                e.addComponent(sf);
                return e;
            };
            EntityFactory.createBigExplosion = function (game, world, x, y) {
                var e = this.createExplosion(game, world, x, y, 0.5);
                var sf = new SoundEffect();
                sf.effect = EFFECT.ASPLODE;
                e.addComponent(sf);
                return e;
            };
            EntityFactory.createExplosion = function (game, world, x, y, scale) {
                var e = world.createEntity();
                // var position:Position = new Position();
                // position.x = x;
                // position.y = y;
                // e.addComponent(position);
                // var sprite:Sprite = new Sprite();
                // sprite.name = "explosion";
                // sprite.scaleX = sprite.scaleY = scale;
                // sprite.r = 255;
                // sprite.g = 216;
                // sprite.b = 0;
                // sprite.a = 128;
                // sprite.layer = Layer.PARTICLES;
                // e.addComponent(sprite);
                // sprite.addTo(game);
                // var expires:Expires = new Expires();
                // expires.delay = 0.5;
                // e.addComponent(expires);
                // var scaleAnimation:ScaleAnimation = new ScaleAnimation();
                // scaleAnimation.active = true;
                // scaleAnimation.max = scale;
                // scaleAnimation.min = scale/100;
                // scaleAnimation.speed = -3.0;
                // scaleAnimation.repeat = false;
                // e.addComponent(scaleAnimation);
                return e;
            };
            EntityFactory.createStar = function (game, world) {
                var e = world.createEntity();
                // var position:Position = new Position();
                // //position.x = MathUtils.random(-Constants.FRAME_WIDTH/2, Constants.FRAME_WIDTH/2);
                // //position.y = MathUtils.random(-Constants.FRAME_HEIGHT/2, Constants.FRAME_HEIGHT/2);
                // position.x = MathUtils.nextInt(Constants.FRAME_WIDTH/2);
                // position.y = MathUtils.nextInt(Constants.FRAME_HEIGHT);
                // e.addComponent(position);
                // var sprite:Sprite = new Sprite();
                // sprite.name = "particle";
                // sprite.scaleX = sprite.scaleY = MathUtils.random(0.5, 1);
                // sprite.a = MathUtils.random(127);
                // sprite.layer = Layer.BACKGROUND;
                // e.addComponent(sprite);
                // sprite.addTo(game);
                // var velocity:Velocity = new Velocity();
                // velocity.vectorY = MathUtils.random(-10, -60);
                // e.addComponent(velocity);
                // e.addComponent(new ParallaxStar());
                // var colorAnimation:ColorAnimation = new ColorAnimation();
                // colorAnimation.alphaAnimate = true;
                // colorAnimation.repeat = true;
                // colorAnimation.alphaSpeed = MathUtils.random(0.2, 0.7);
                // colorAnimation.alphaMin = 0;
                // colorAnimation.alphaMax = 255;
                // e.addComponent(colorAnimation);
                return e;
            };
            EntityFactory.createParticle = function (game, world, x, y) {
                var e = world.createEntity();
                // var position:Position = new Position();
                // position.x = x;
                // position.y = y;
                // e.addComponent(position);
                // var sprite:Sprite = new Sprite();
                // sprite.name = "particle";
                // sprite.scaleX = sprite.scaleY = MathUtils.random(0.5, 1);
                // sprite.r = 255;
                // sprite.g = 216;
                // sprite.b = 0;
                // sprite.a = 1;
                // sprite.layer = Layer.PARTICLES;
                // e.addComponent(sprite);
                // sprite.addTo(game);
                // var radians:number = MathUtils.random(2*Math.PI);
                // var magnitude:number = MathUtils.random(400);
                // var velocity:Velocity = new Velocity();
                // velocity.vectorX = magnitude * Math.cos(radians);
                // velocity.vectorY = magnitude * Math.sin(radians);
                // e.addComponent(velocity);
                // var expires:Expires = new Expires();
                // expires.delay = 1;
                // e.addComponent(expires);
                // var colorAnimation:ColorAnimation = new ColorAnimation();
                // colorAnimation.alphaAnimate = true;
                // colorAnimation.alphaSpeed = -1;
                // colorAnimation.alphaMin = 0;
                // colorAnimation.alphaMax = 1;
                // colorAnimation.repeat = false;
                // e.addComponent(colorAnimation);
                return e;
            };
            return EntityFactory;
        })();
        core.EntityFactory = EntityFactory;
    })(core = ganglere.core || (ganglere.core = {}));
})(ganglere || (ganglere = {}));
//# sourceMappingURL=EntityFactory.js.map