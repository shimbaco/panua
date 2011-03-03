# coding: utf-8

module ApplicationHelper

  def page_title(text = nil)
    title = ''
    if text.present?
      title += "#{text} | "
    end
    title += 'Panua'
  end

  def little_time_ago_in_words(from_time, include_seconds = false)
    from_time = from_time.to_time
    to_time = Time.now.to_time
    distance_in_minutes = (((to_time - from_time).abs)/60).round

    if distance_in_minutes < 1440
      time_ago_in_words(from_time, include_seconds)
    else
      l(from_time)
    end
  end
end
