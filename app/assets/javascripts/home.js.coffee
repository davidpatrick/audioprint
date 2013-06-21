# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  # $('.collapse').collapse()
  $('#tracks').sortable
    axis: 'y'
    update: ->
      $.post(
        $(this).data('update-url') + '?album_id=' + $(this).data('album-id'),
        $(this).sortable('serialize')
      )
  $('#bootstrapped-fine-uploader').fineUploader
    request:
      endpoint: "/albums/#{ALBUM_ID}/add_songs"
      customHeaders: "X-File-Upload" : "true"
    text:
      uploadButton: '<i class="icon-upload icon-white"></i> Upload a new song'
    template: '<div class="qq-uploader span12">' +
                '<pre class="qq-upload-drop-area span12"><span>{dragZoneText}</span></pre>' +
                '<div class="qq-upload-button btn btn-success" id="qq-upload" style="width: 100%;">{uploadButtonText}</div>' +
                '<span class="qq-drop-processing"><span>{dropProcessingText}</span><span class="qq-drop-processing-spinner"></span></span>' +
                '<ul class="qq-upload-list" style="margin-top: 10px; text-align: center;"></ul>' +
              '</div>'
    classes:
      success: 'qq-upload-success'
      fail: 'alert alert-error'
    validation:
      allowedExtensions: ["mp3"]
    debug: false
    paramsInBody: true
    forceMultipart: true
    $('#bootstrapped-fine-uploader').on 'submit', ->
      $(this).fineUploader('setParams', {"authenticity_token" : "#{AUTH_TOKEN}" })
    $('#bootstrapped-fine-uploader').on 'complete', (event, id, filename, responseJSON) ->
      if responseJSON["success"] == true
        if responseJSON["upload_type"] == "Song"
          $.ajax
            url: "/albums/ajax_uploaded_song?song=#{responseJSON['id']}"
            success: (data, textStatus, jqXHR) ->
    $('#bootstrapped-fine-uploader').on 'error', ->

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
