jQuery(function($){
   
   $('#contacto').live('click', function(){
      if($(this).attr('checked')) {
          $('.contacto').hide();
      } else {
          $('.contacto').show();
      }
      
     
   });    
   
   $('#historial_auto_cliente').autocomplete({
    source: '/clientes/autocompletar.js'
    });
   
   $('#recetader').live('click', function(){
       $('#recetaizq').attr('checked', $('#recetader').attr('checked'));
   });
   
    $('#correcder').live('click', function(){
       $('#correcizq').attr('checked', 'checked');
   });
   
});