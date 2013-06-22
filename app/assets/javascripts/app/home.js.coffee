# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  # $('.collapse').collapse()
  # $('#tracks').sortable
  #   axis: 'y'
  #   update: ->
  #     $.post(
  #       $(this).data('update-url') + '?album_id=' + $(this).data('album-id'),
  #       $(this).sortable('serialize')
  #     )
  $('.date_picker').datepicker({format: 'yyyy/mm/dd'})
  $('.date_picker').on 'changeDate', ->
    $('.date_picker').datepicker('hide')
  $(document).on('click', '.edit-song', directToUrl)
  $(document).on('click', '.delete-song',  deleteSong)

directToUrl = ->
  window.location = $(this).attr('href')

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
