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
        var Position = (function (_super) {
            __extends(Position, _super);
            function Position() {
                _super.apply(this, arguments);
            }
            Position.className = 'Position';
            return Position;
        })(Component);
        components.Position = Position;
        Position.prototype.x = 0;
        Position.prototype.y = 0;
    })(components = ganglere.components || (ganglere.components = {}));
})(ganglere || (ganglere = {}));
//# sourceMappingURL=Position.js.map