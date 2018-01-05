'use strict';

require('bootstrap-loader');
require("./styles.scss");

var Elm = require('./Main');
var app = Elm.Main.fullscreen();

var synth = window.speechSynthesis;
var wordPending = '';
app.ports.speak.subscribe(function(word) {
  var wasSpeaking = synth.speaking;
  console.log(wasSpeaking, wordPending, (new Date()).getMilliseconds(), word);
  if (!wasSpeaking && !wordPending) {
    synth.speak(new SpeechSynthesisUtterance(word));
    wordPending = word;
    setTimeout(function () { wordPending = ''; }, 500);
  } else {
    if (wordPending === word) return;
    if (wasSpeaking) synth.cancel();
    wordPending = word;
    setTimeout(function () {
      synth.speak(new SpeechSynthesisUtterance(word));
      wordPending = '';
    },500);
  }
});
