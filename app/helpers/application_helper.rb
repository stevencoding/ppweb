module ApplicationHelper
  def owner?(item)
    return false if item.blank? || current_user.blank?
    item.user_id == current_user.id
  end

  def edit?(user)
    return false if current_user.blank?
    current_user.id == user.id
  end
end
