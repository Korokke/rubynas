// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require_tree .

function show_form(action) {
  $('#' + action + '-field').show();
  $('#' + action + '-open-btn').hide();
}
function hide_form(action) {
  $('#' + action + '-field').hide();
  $('#' + action + '-open-btn').show();
}

// Select
function select_all() {
  $("input[name='selected[]']:checkbox:not(:checked)").each(function() {
    $(this).prop("checked", true);
  });
}

function select_reset() {
  $("input[name='selected[]']:checkbox:checked").each(function() {
    $(this).prop("checked", false);
  });
}

function select_invert() {
  $("input[name='selected[]']:checkbox").each(function() {
    $(this).prop("checked", !$(this).prop("checked"));
  });
}

// Submit
function submit_table(loc, method) {
  if ($("input[name='selected[]']:checkbox:checked").length == 0) {
    alert("- Please select any file or folder");
  }
  else {
    frm = $("#table-form");
    $.ajax({
      url: loc,
      type: method.toUpperCase(),
      data: frm.serialize()
    });
  }
}
