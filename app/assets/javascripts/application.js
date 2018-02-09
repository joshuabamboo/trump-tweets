// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require d3.v3.min
//= require tweets-per-day
//= require particles.min
//= require sticky/js/jquery.sticky.min
//= require mousewheel/js/jquery.mousewheel-3.0.6.pack
//= require superfish/js/hoverIntent.min
//= require horiz-timeline/js/hortimeline.min
//= require rs-plugin/js/jquery.themepunch.tools.min
//= require rs-plugin/js/jquery.themepunch.revolution.min
//= require rs-plugin/js/extensions/revolution.extension.slideanims.min
//= require rs-plugin/js/extensions/revolution.extension.layeranimation.min
//= require rs-plugin/js/extensions/revolution.extension.navigation.min
//= require rs-plugin/js/extensions/revolution.extension.actions.min
//= require rs-plugin/js/extensions/revolution.extension.video.min
//= require modernizr/js/modernizr.min
//= require parallax/js/jquery.stellar.min
//= require imagesloaded/js/imagesloaded.pkgd.min
//= require isotope/js/isotope.pkgd.min
//= require mfp/js/jquery.magnific-popup.min
//= require anicounter/jquery.counterup.min
//= require circle-progress/circle-progress.min
//= require waypoints/waypoints.min
//= require offcanvas-menu/js/classie.min
//= require progresstracker/js/jquery.progresstracker.min
//= require wow/wow.min
//= require script
//= require_tree .



document.addEventListener("turbolinks:load", function() {
  $('#clinton-tweets').hide()
  $('#obama-tweets').hide()
  $('#trump-tweets').hide()
  $('#hall-of-shame-tweets').hide()

})
