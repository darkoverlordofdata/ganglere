var ganglere;
(function (ganglere) {
    var core;
    (function (core) {
        var Constants = (function () {
            function Constants() {
            }
            Constants.FRAME_WIDTH = 320;
            Constants.FRAME_HEIGHT = 480;
            Constants.Groups = {
                PLAYER: "player",
                FENRIS: "fenris",
                LOKE: "loke",
                THOR: "thor"
            };
            return Constants;
        })();
        core.Constants = Constants;
    })(core = ganglere.core || (ganglere.core = {}));
})(ganglere || (ganglere = {}));
//# sourceMappingURL=Constants.js.map