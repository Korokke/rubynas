# Change Password
@open_admin_changepassword = ->
  checked = $("input[name='selected[]']:checkbox:checked")
  if checked.length is 0
    alert("- Please select a user")
  else if checked.length is 1
    $("label[for=selected]", $("#admin-changepassword-form")).html(checked.prop("value"))
    $("input:submit[value=Change]", $("#admin-changepassword-form")).click((e) ->
      e.preventDefault()
      $.ajax ("/admin/users/" + checked.prop("value")),
        type: "PATCH"
        data: $("#admin-changepassword-form").serialize()
    )
    show_form("admin-changepassword")
  else
    alert("- Please select only one user")
