'use strict';

require('bootstrap-loader');
require("./styles.scss");
import Speak from './ports/speak.js';

var Elm = require('./Main');
var app = Elm.Main.fullscreen();

Speak.register(app.ports);
