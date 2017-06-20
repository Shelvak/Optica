jQuery(function($){
  var disableAutoClient = function () {
        changeAutoClient('disable');
      },
      enableAutoClient = function () {
        changeAutoClient('enable');
        $('#historial_auto_cliente').val('')
      },
      changeAutoClient = function (_status) {
        var readonly, hidden;
        if (_status == 'disable') {
          readonly = true;
          hidden = false;
        } else {
          readonly = false;
          hidden = true;
        }
        $('#historial_auto_cliente').attr('readonly', readonly);
        $('#borrar_autocliente').attr('hidden', hidden);
      };

   //Muestra u oculta las convenientes partes de flotantes o contacto
      $('#historial_tipolente').change(function(){
        if($(this).val() == '1') {
          $('.flotante').slideUp();
          $('.contacto').slideDown();
        }else {
           $('.flotante').slideDown();
           $('.contacto').slideUp();
        }
      });

        //Autocompletado de cliente En historial
      $('#historial_auto_cliente').autocomplete({
        source: '/clientes/autocompletar.js',
        minLength: 3,
        select: disableAutoClient
      });
      $('#borrar_autocliente').on('click', enableAutoClient);

      $(document).on('ajax:success', '.retirado', function(xhr,data){
          $(this).parents('tr:first').replaceWith(data);
      });
});

$(document).on('click', '.js-create-with-bill', function(e) {
    e.preventDefault()

    $('input.js-with-bill').val(true);

    $(e.currentTarget).parents('form:first').submit();
});
