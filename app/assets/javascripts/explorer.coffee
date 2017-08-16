# Rename
@open_rename = ->
  checked = $("input[name='selected[]']:checkbox:checked")
  if checked.length is 0
    alert("- Please select a file")
  else if checked.length is 1
    $("label[for=selected]", $("#rename-form")).html(checked.prop("value"))
    $("input:text[name=newname]", $("#rename-form")).prop("value", checked.prop("value"))
    $("input:submit[value=Rename]", $("#rename-form")).click((e) ->
      e.preventDefault()
      $.ajax ($(location).prop("pathname") + "/" + checked.prop("value")).split('/').map(encodeURIComponent).join('/'),
        type: "PATCH"
        data: $("#rename-form").serialize() + "&selected=" + checked.prop("value")
    )
    show_form("rename")
  else
    alert("- Please select only one file")

# Upload = ->
