jQuery ->
  $('#bootstrapped-fine-uploader').fineUploader
    request:
      endpoint: "/albums/" + $('#bootstrapped-fine-uploader').data('album-id') + "/add_songs"
      customHeaders: "X-File-Upload" : "true"
    text:
      uploadButton: '<i class="icon-upload icon-white"></i> Upload a new song'
    template: '<div class="qq-uploader span12">' +
                '<pre class="qq-upload-drop-area span12"><span>{dragZoneText}</span></pre>' +
                '<div class="qq-upload-button button" id="qq-upload" style="width: 100%;">{uploadButtonText}</div>' +
                '<span class="qq-drop-processing" style="display:none;"><span>{dropProcessingText}</span><span class="qq-drop-processing-spinner"></span></span>' +
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
