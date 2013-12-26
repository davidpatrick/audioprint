# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $("body.orders").on "click", "a.add-quantity", (e) ->
    e.preventDefault();
    $.ajax $(this).attr('href'),
      type: 'PUT'
      data: { add_quantity: true }
      dataType: 'json'
      error: (jqXHR) ->
        alert jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        $("#item-#{data.id} .quantity").html(data["quantity"])
        if data["stock"]
          $("#item-#{data.id} .stock").html(data["stock"])
        $("#item-#{data.id} .subtotal").html(data["subtotal"])
        $("#order-total").html(data["total"])

  $("body.orders").on "click", "a.subtract-quantity", (e) ->
    e.preventDefault();
    current_quantity = $(this).siblings('.quantity').text()
    if current_quantity == "1"
      if !confirm "Are you sure you want to delete this item from your order?"
        return
    $.ajax $(this).attr('href'),
      type: 'PUT'
      data: { subtract_quantity: true }
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        alert jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        if data["deleted"]
          $("#item-#{data.id}").fadeOut()
        else
          $("#item-#{data.id} .quantity").html(data["quantity"])
          if data["stock"]
            $("#item-#{data.id} .stock").html(data["stock"])
          $("#item-#{data.id} .subtotal").html(data["subtotal"])
          $("#order-total").html(data["total"])

  $("body.orders").on "click", "a.delete-item", (e) ->
    e.preventDefault();
    if confirm "Are you sure you want to delete this item from your order?"
      $.ajax $(this).attr('href'),
        type: 'DELETE'
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
          alert textStatus
        success: (data, textStatus, jqXHR) ->
          $("#item-#{data.id}").fadeOut()

  $("body.checkout #address_form").on 'click', 'input[type=submit]', (e) ->
    e.preventDefault();
    if $('.loader').length == 0
      $('body').append(" \
        <div class='loader'> \
          <div class='loader-background'> \
            <div class='loader-indicator'> \
            </div> \
          </div> \
        </div> \
      ")
      form = $('form#address_form')
      $.ajax form.attr('action'),
        type: 'POST'
        data: form.serialize()
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
          console.log(jqXHR)
          console.log(textStatus)
          console.log(errorThrown)
        success: (data, textStatus, jqXHR) ->
          console.log(data.address)
          console.log(data.order)
        complete: (data) ->
          $('.loader').remove()
