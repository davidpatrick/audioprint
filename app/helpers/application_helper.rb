module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def avatar_url(user)
    if user.avatar.present?
      user.avatar(:medium)
    else
      gravatar_id = Digest::MD5.hexdigest(user.email)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=200&d=mm"
    end
  end

  def gravatar_url(user)
    gravatar_id = Digest::MD5.hexdigest(user.email)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=30&d=mm"
  end
end
