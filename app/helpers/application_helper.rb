module ApplicationHelper
  def title text
    content_for :title do
      text + ' - ' + Twordtag::Application.config.title
    end
  end
end
