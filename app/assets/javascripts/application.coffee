# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require_tree .
#= require masonry/jquery.masonry
#= require masonry/jquery.imagesloaded.min
#= require masonry/jquery.infinitescroll.min
#= require masonry/modernizr-transitions
$ ->
    $('#masonry-container').masonry
        itemSelector: '.movie-box'
        isInitLayout: false
        isAnimated: !Modernizr.csstransitions
        isFitWidth: true
    $('.modal-button').click ->
        $($(this).attr('data-target')).addClass 'is-active'
    $('.modal-close').click ->
        $('.modal').removeClass 'is-active'
    return