jQuery(function(){
    
    $('form').submit(function() {
            $(this).find('input[type="submit"],\n\
                 input[name="utf8"]').attr('disabled', true
                );
    });
    
});

