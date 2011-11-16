jQuery(function($){
   //Muestra u oculta las convenientes partes de flotantes o contacto
       $('#historial_tipolente').change(function(){
                if($(this).val() == 'De Contacto') {
                     $('.flotante').hide();
                     $('.contacto').show();
                 }else {
                    $('.flotante').show();
                    $('.contacto').hide();
                 }
       });

        //Autocompletado de cliente En historial
       $('#historial_auto_cliente').autocomplete({
        source: '/clientes/autocompletar.js'
        });
  
});