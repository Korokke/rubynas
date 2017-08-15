# Select
@select_all = ->
  $("input[name='selected[]']:checkbox:not(:checked)").each(->
    $(this).prop("checked", true)
  )

@select_reset = ->
  $("input[name='selected[]']:checkbox:checked").each(->
    $(this).prop("checked", false)
  )

@select_invert = ->
  $("input[name='selected[]']:checkbox").each(->
    $(this).prop("checked", !$(this).prop("checked"))
  )

# Submit
@submit_file_table = (method) ->
  if $("input[name='selected[]']:checkbox:checked").length is 0
    alert('- Please select any file or folder')
  else
    frm = $("#file-table-form")
    $("input[name=_method]").prop("value", method)
    frm.prop("action", $(location).prop("pathname"))
    frm.submit()
