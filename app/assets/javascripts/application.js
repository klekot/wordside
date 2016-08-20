// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function openSidebar() {
    // "use strict"; - do not comment out this statement, because script will not work...
    vocabularyWidth  = window.screen.availWidth / 6.4;
    vocabularyHeight = window.screen.availHeight;
    open("sidebar/index", "_blank",
        "titlebar=no,screenX=10000,width=" + vocabularyWidth + ",height=" + vocabularyHeight + ",status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=no");
}
