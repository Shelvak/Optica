jQuery(function(){
    
    //Quitar Snowmen ^^
    $('form').submit(function() {
            $(this).find('input[type="submit"],\n\
                 input[name="utf8"]').attr('disabled', true
                );
    });
    
    //paginar
       $('.pagination a').live("click", function() {  
          $.get(this.href, null, null, 'script');  
            return false;  
        });  
        
     // No enviar emails vacios
        $('#subject, #body').live('change', function(){
           if ($('#subject').val() != '' && $('#subject').val() != ' '){
               $('#email_send').attr('disabled', false);
           } else {
               $('#email_send').attr('disabled', true);
           }
        });

   if ($('.nicEditor').length > 0){
     bkLib.onDomLoaded(nicEditors.allTextAreas);
   }
    
});

