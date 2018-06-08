module LinksHelper
  def link_to_edit(*args)
    options = args.extract_options!

    options[:class] ||= ''
    options[:class] += ' iconic'
    options['title'] ||= t('label.edit')
    options['data-show-tooltip'] = true

    link_to '&#x270e;'.html_safe, *args, options
  end

  def link_to_destroy(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.delete')
    options['method'] ||= :delete
    options['data-confirm'] ||= t('messages.confirmation')
    options['data-show-tooltip'] = true

    link_to '&#xe05a;'.html_safe, *args, options
  end
end
