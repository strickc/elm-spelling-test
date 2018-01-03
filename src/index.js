'use strict';

require('bootstrap-loader');
require("./styles.scss");

var Elm = require('./Main');
var app = Elm.Main.fullscreen();
var synth = window.speechSynthesis;
app.ports.speak.subscribe(function(word) {
  synth.speak(new SpeechSynthesisUtterance(word));
});
