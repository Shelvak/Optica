$(document).on 'click', 'a.remote-modal', (e)->
  e.preventDefault()
  e.stopPropagation()

  $('.dynamic-content').load $(e.currentTarget).data('remoteLink'), (result)->
    $('.dynamic-modal').modal( show: true )
    $('form.modal-form').bind 'ajax:complete', (e, response, status)->
      if status == 'success'
        window.location.href = window.location.href
      else
        $('.dynamic-modal').html(response.responseText)


$(document).on 'hidden', '.dynamic-modal', ->
  $(this).remove()

$(document).on 'submit', 'form.modal-form', (e)->
  console.log('submit vieja')

