jQuery(function($){
    
    $('#cliente_auto_recomendado').autocomplete({
        source: 'autocompletar.js'
    });
    
    $('.pagination a').live("click", function() {  
          $.get(this.href, null, null, 'script');  
            return false;  
            
        });  
    
    
});

