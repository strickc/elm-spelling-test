
const synth = window.speechSynthesis;
let wordPending = '';
function speak(word) {
  const wasSpeaking = synth.speaking;
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
}

export default {
  register(appPorts) {
    appPorts.speak.subscribe(speak);
  },
};

