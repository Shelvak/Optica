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
        
//        //paginar
       $('.pagination a').live("click", function() {  
          $.get(this.href, null, null, 'script');  
            return false;  
        });  


  
  
});