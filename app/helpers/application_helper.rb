module ApplicationHelper
  def full_title(page_title)
    'Ruby on Rails Tutorial Sample App' +
     (!page_title.empty? ? " | #{page_title}" : '')
  end
end
