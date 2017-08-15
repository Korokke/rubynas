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
    alert("- Please select any file or folder")
  else
    frm = $("#file-table-form")
    $.ajax $(location).prop("pathname"),
      type: method.toUpperCase()
      data: frm.serialize()

# Rename
@open_rename = ->
  checked = $("input[name='selected[]']:checkbox:checked")
  if checked.length is 0
    alert("- Please select a file")
  else if checked.length is 1
    $("label[for=selected]").html(checked.prop("value"))
    $("input:submit[value=Rename]").click((e) ->
      e.preventDefault()
      $.ajax ($(location).prop("pathname") + "/" + checked.prop("value")).split('/').map(encodeURIComponent).join('/'),
        type: "PATCH"
        data: $("#rename-form").serialize() + "&selected=" + checked.prop("value")

    #$("#rename-form").prop("action", ($(location).prop("pathname") + "/" + checked.prop("value")).split('/').map(encodeURIComponent).join('/'))
    #$("#selected").prop("value", checked.prop("value"))
    #$("label[for=selected]").html(checked.prop("value"))
    #$("#newname").prop("value", checked.prop("value"))
    #$("input:submit[value=Rename]").submit((e) ->
    #  if $("#newname").prop("value") is ""
    #    alert("- Please enter the new name")
    #    return false
    #  else if $("#newname").prop("value") is $("#selected").prop("value")
    #    alert("- Please enter the name different from the previous one")
    #    return false
    #  else
    #    return true
    )
    show_form("rename")
  else
    alert("- Please select only one file")
