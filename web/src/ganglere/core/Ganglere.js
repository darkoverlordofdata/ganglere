var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ganglere;
(function (ganglere) {
    var core;
    (function (core) {
        var Ganglere = (function (_super) {
            __extends(Ganglere, _super);
            /**
             *
             * @constructor
             * @extends {cc.Layer}
             * @param {cc.Scene} scene
             */
            function Ganglere(scene) {
                _super.call(this);
                this.scene = scene;
                return new (cc.Layer.extend(this));
            }
            /**
              * Start the menu
              * @return {cc.Scene} the menu scene
              */
            Ganglere.start = function () {
                var scene = new cc.Scene();
                scene.addChild(new Ganglere(scene));
                return scene;
            };
            Ganglere.prototype.ctor = function () {
                this._super();
                this.game = new core.Game(this);
                //setScreen(gameScreen);
                this.scheduleUpdate();
            };
            Ganglere.prototype.update = function (time) {
                this.game.render(time);
            };
            return Ganglere;
        })(CCLayer);
        core.Ganglere = Ganglere;
    })(core = ganglere.core || (ganglere.core = {}));
})(ganglere || (ganglere = {}));
//# sourceMappingURL=Ganglere.js.map