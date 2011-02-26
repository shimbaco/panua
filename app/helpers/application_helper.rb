module ApplicationHelper

  def page_title(text = nil)
    title = ''
    if text.present?
      title += "#{text} | "
    end
    title += 'Panua'
  end
end
