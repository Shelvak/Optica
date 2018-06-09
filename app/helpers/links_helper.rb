module LinksHelper
  def link_to_edit(*args)
    options = args.extract_options!

    options[:class] ||= ''
    options['title'] ||= t('label.edit')
    options['data-show-tooltip'] = true

    link_to *args, options do
      content_tag(:i, '', class: 'fa fa-pencil')
    end
  end

  def link_to_destroy(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.delete')
    options['method'] ||= :delete
    options['data-confirm'] ||= t('messages.confirmation')
    options['data-show-tooltip'] = true

    link_to *args, options do
      content_tag(:i, '', class: 'fa fa-trash')
    end
  end
end
