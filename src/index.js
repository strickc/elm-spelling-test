'use strict';

require('bootstrap-loader');
require("./styles.scss");
// require("css-loader!sweetalert2/dist/sweetalert2.css");

import Speak from './ports/speak';
import Swal from './ports/sweetAlert2.js';

var Elm = require('./Main');
var app = Elm.Main.fullscreen();

Speak.register(app.ports);
Swal.register(app.ports);
