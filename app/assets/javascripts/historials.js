jQuery(function($){
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
        source: '/clientes/autocompletar.js'
      });
      
       // Fijar autocliente
      $('#historial_auto_cliente').live('change', function(){
        $('#historial_auto_cliente').attr('disabled', true);
        $('#borrar_autocliente').attr('hidden', false);  
        $('#borrar_autocliente').live('click', function(){
          $('#historial_auto_cliente').attr('value', '').attr('disabled', false);
          $('#borrar_autocliente').attr('hidden', true);
        });
        $('#submit_historial').live('click', function(){
          $('#historial_auto_cliente').attr('disabled', false);
        });
      });
        
      $('.retirado').live('ajax:success',function(xhr,data){
          $(this).parents('tr:first').replaceWith(data);
      });
});