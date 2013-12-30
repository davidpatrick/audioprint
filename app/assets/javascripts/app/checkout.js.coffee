jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  checkout.setupForm()
  $("body.checkout .edit").on 'click', sections.editSection
  $("body.checkout #address-dropdown").on 'change', formHandler.addressDropdownSelect
  $("body.checkout #address-form").on 'click', 'input[type=submit]', formHandler.setAddress
  $("body.orders").on 'click', '.ship-order', (e) ->
    $(this).siblings('.confirmation-form').show()
    $(this).siblings('.cancel-ship').show()
    $(this).hide()
    $("body.orders").on 'click', '.cancel-ship', (e) ->
      $(this).siblings('.confirmation-form').hide()
      $(this).siblings('.ship-order').show()
      $(this).hide()

checkout =
  setupForm: ->
    $('#billing-form').submit ->
      event.preventDefault();
      $('input[type=submit]').attr('disabled', true)
      checkout.processCard()

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, checkout.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    $('input[type=submit]').attr('disabled', false)
    if status == 200
      $('#stripe_card_token').val(response.id)
      $('#billing').toggleClass('on off')
      $('#review').toggleClass('on off')
      $('#billing .edit').show()
    else
      $('#stripe_error').text(response.error.message)

formHandler =
  populateForm: (name, data) ->
    $.each data, (key, value) ->
      $("[name='#{name}[#{key}]']").val value

  handleFormErrors: (name, data) ->
    $.each data, (key, value) ->
      string = value.toString()
      target = $(".#{name}_#{key}")
      target.addClass('field_with_errors')
      target.append("<span class='error'>#{string}</span>")
  addressDropdownSelect: ->
    selectedValue = this.value
    dataObject = $.parseJSON($(this).find("option[value='#{selectedValue}']").attr('data'))
    $('#preloaded_address').val selectedValue
    formHandler.populateForm 'address', dataObject
  setAddress: ->
    event.preventDefault();
    $('#address-form .error').remove()
    if $('.loader').length == 0
      $('body').append("<div class='loader'><div class='loader-background'><div class='loader-indicator'></div></div></div>")
      form = $('form#address-form')
      $.ajax form.attr('action'),
        type: 'PUT'
        data: form.serialize()
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
          data = jqXHR.responseJSON
          if !$.isEmptyObject(data.address)
            formHandler.handleFormErrors 'address', data.address
          # if !$.isEmptyObject(data.order)
          #   handleFormErrors 'address', data.order
        success: (data, textStatus, jqXHR) ->
          $('#preloaded_address').val data.address.id
          $('#shipping').toggleClass('on off')
          $('#billing').toggleClass('on off')
          #console.log(data.address)
          #console.log(data.order)
        complete: (data) ->
          $('.loader').remove()
sections =
  editSection: ->
    section = $(this).closest('.checkout-section').attr('id')
    $(".on").toggleClass('on off', ->
      $("##{section}").toggleClass('on off')
    )