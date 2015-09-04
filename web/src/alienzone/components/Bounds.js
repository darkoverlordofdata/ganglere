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
        var Bounds = (function (_super) {
            __extends(Bounds, _super);
            function Bounds() {
                _super.apply(this, arguments);
            }
            Bounds.className = 'Bounds';
            return Bounds;
        })(Component);
        components.Bounds = Bounds;
        Bounds.prototype.radius = 0;
    })(components = ganglere.components || (ganglere.components = {}));
})(ganglere || (ganglere = {}));
//# sourceMappingURL=Bounds.js.map