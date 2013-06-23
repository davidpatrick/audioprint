jQuery ->
  $('body').on('click', 'a.delete-song',  deleteSong)
  $('body').on('click', 'a.edit-song', editSong)


deleteSong = ->
  if confirm('Are you sure you want to delete this song?')
    song_id = $(this).attr('id')
    $.ajax $(this).attr('href'),
      type: 'DELETE'
      dataType: 'json'
      success: (result) ->
        $('tr#song-' + song_id).fadeOut()
        $('.tool-container:visible').hide()
      error: (result) ->
        alert('There was a problem deleting this song')
  return false

editSong = ->
  url_request = "http://localhost:3000/" + $(this).attr('href')
  $("#song-modal").foundation "reveal", "open",
    url: url_request
    success: (data) ->
    error: ->

  return false