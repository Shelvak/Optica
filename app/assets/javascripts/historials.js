jQuery(function($){
   //Muestra u oculta las convenientes partes de flotantes o contacto
       $('#historial_tipolente').change(function(){
                if($(this).val() == '1') {
                     $('.flotante').slideUp();
                     //.attr('hidden', true);
                     $('.contacto').slideDown();
                     //.attr('hidden', false);
                 }else {
                    $('.flotante').slideDown();
                    //.attr('hidden', false);
                    $('.contacto').slideUp();
                    //.attr('hidden', true);
                 }
       });

        //Autocompletado de cliente En historial
       $('#historial_auto_cliente').autocomplete({
        source: '/clientes/autocompletar.js'
        });
  
});