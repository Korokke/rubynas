@show_signup_form = ->
  $('#signup_field').show()
  $('#signup_open_btn').hide()
@hide_signup_form = ->
  $('#signup_field').hide()
  $('#signup_open_btn').show()


$(document).on('ajax:success', '#signin-form', (e, data) -> alert data.message if data.status == "f")
$(document).on('ajax:success', '#signup-form', (e, data) -> alert data.message if data.status == "f")
