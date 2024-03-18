module ApplicationHelper
  BASE_TITLE = "WalkBreak".freeze

  def page_title(title)
    title.blank? ? BASE_TITLE : "#{title} - #{BASE_TITLE}"
  end
end
