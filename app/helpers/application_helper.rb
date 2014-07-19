module ApplicationHelper
  def owner?(item)
    return false if item.blank? || current_user.blank?
    item.user_id == current_user.id
  end

  def edit?(user)
    return false if current_user.blank?
    current_user.id == user.id
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
