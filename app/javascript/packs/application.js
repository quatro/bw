// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("admin-lte")
require("../application_scripts")

global.toastr = require("toastr")



require("plugins/jquery/jquery.min.js")
require("plugins/jquery-ui/jquery-ui.min.js")
require("plugins/moment/moment.min.js")
require("plugins/bootstrap/js/bootstrap.bundle.min.js")
require("plugins/chart.js/Chart.min.js")
require("plugins/sparklines/sparkline.js")
require("plugins/jqvmap/jquery.vmap.min.js")
require("plugins/jqvmap/maps/jquery.vmap.usa.js")
require("plugins/jquery-knob/jquery.knob.min.js")
require("plugins/daterangepicker/daterangepicker.js")
// require("plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js")
// require("plugins/summernote/summernote-bs4.min.js")
require("plugins/summernote/summernote.min.js")
require("plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js")
require("dist/js/adminlte.js")
// require("dist/js/pages/dashboard.js")
require("dist/js/demo.js")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import 'css/site.scss'

// This bring images into the application
const images = require.context('../images', true)

