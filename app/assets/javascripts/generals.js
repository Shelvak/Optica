jQuery(function(){

  //Quitar Snowmen ^^
  $('form').submit(function() {
    $('.spinner-gif').show()
    // $(this).find('input[type="submit"],\n\
    //     input[name="utf8"]').attr('disabled', true
    //       );
  });

  //paginar
  // $(document).on('click', '.pagination a', function() {
  //   $.get(this.href, null, null, 'script');
  //   return false;
  // });

  // No enviar emails vacios
  $('#subject').on('change', function() {
    $('#email_send').attr(
      'disabled',
      $('#subject').val().trim() == ''
    );
  });

  if ($('.nicEditor').length > 0){
    bkLib.onDomLoaded(nicEditors.allTextAreas);
  }

});

