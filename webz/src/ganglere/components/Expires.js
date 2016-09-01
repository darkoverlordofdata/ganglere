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
        var Expires = (function (_super) {
            __extends(Expires, _super);
            function Expires() {
                _super.apply(this, arguments);
            }
            Expires.className = 'Expires';
            return Expires;
        })(Component);
        components.Expires = Expires;
        Expires.prototype.delay = 0;
    })(components = ganglere.components || (ganglere.components = {}));
})(ganglere || (ganglere = {}));
//# sourceMappingURL=Expires.js.map