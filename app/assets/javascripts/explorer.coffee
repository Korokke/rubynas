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

"""
# Upload
CHUNK_SIZE = 15728640 # 15 MB
@upload_file_changed = ->
  $("#upload-submit").click((e) ->
    offset = 0
    @onLoadHandler = (evt) ->
      offset += CHUNK_SIZE
      data = evt.target.result
      frm = new FormData()
      frm.append("bn", data.toString())
      frm.append("file", file.original_filename)
      frm.append("last", "1") if offset >= file.size
      $.ajax ("/upload" + $(location).prop("pathname").split('/').map(encodeURIComponent).join('/')),
        type: "PATCH"
        data: frm
        contentType: "application/octet-stream"
      if offset >= file.size
        return
      else
        this.readChunk(offset, CHUNK_SIZE, file)

    @readChunk = (_offset, length, _file) ->
      reader = new FileReader()
      blob = _file.slice(_offset, length + _offset)
      reader.onload = this.onLoadHandler
      reader.readAsBinaryString(blob)

    e.preventDefault()

    files = $("input[type=file]", $("#upload-form")).prop("files")
    if files.length == 0
      alert("- Please select a file")
      return false
    else
      file = files[0]
      if file.size <= CHUNK_SIZE
        frm = new FormData()
        frm.append("file", file)
        $.ajax ("/upload" + $(location).prop("pathname").split('/').map(encodeURIComponent).join('/')),
          type: "POST"
          data: frm
          processData: false
          contentType: false
      else
        this.readChunk(offset, CHUNK_SIZE, file)
  )
  # $("#upload-form").submit()
"""
