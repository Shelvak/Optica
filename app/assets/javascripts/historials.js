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
       $('#historial_auto_cliente').live('keyup', function(e){
           var key = e.which;
           if (key == '08'){
               $('#historial_auto_cliente').val(null);
       }
       });
//       $('#historial_auto_cliente').live("change", function(){
//          $('.mostrar_cliente').show();
//            $('#lala').attr('href', '/edit/2').text('lala');
//       });
        
        
        
        $('.retirado').live('ajax:success',function(xhr,data){
            $(this).parents('tr:first').replaceWith(data);
        });

  
  
});