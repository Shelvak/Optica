load_remote_content = (link) ->


# $(document).on 'click', '.remote-modal i', (e)->
#   load_remote_content( $(e.currentTarget).parents('a:first') )

$(document).on 'click', 'a.remote-modal', (e)->
  e.preventDefault()
  e.stopPropagation()

  $('.dynamic-content').load $(e.currentTarget).data('remoteLink'), (result)->
    $('.dynamic-modal').modal( show: true )
    $('form.modal-form').bind 'ajax:success', (e, response, status)->
      $('.dynamic-modal').modal('hide')


$(document).on 'hidden', '.dynamic-modal', ->
  $(this).remove()
