var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ganglere;
(function (ganglere) {
    var components;
    (function (components) {
        var Component = artemis.Component;
        var Velocity = (function (_super) {
            __extends(Velocity, _super);
            function Velocity() {
                _super.apply(this, arguments);
            }
            Velocity.className = 'Velocity';
            return Velocity;
        })(Component);
        components.Velocity = Velocity;
        Velocity.prototype.vectorX = 0;
        Velocity.prototype.vectorY = 0;
    })(components = ganglere.components || (ganglere.components = {}));
})(ganglere || (ganglere = {}));
//# sourceMappingURL=Velocity.js.map