module EventsHelper
  def video_url(ep)
    "http://media.happycasts.net/assets/episodes/videos/#{ep.asset_name}.mov"
  end

  def social_share_button_tag(title = "", opts = {})
    rel = opts[:rel]
    html = []
    html << "<div class='social-share-button' data-title='#{h title}' data-img='#{opts[:image]}' data-url='#{opts[:url]}'>"

    %w(weibo tqq).each do |name|

      link_title = t "social_share_button.share_to", :name => t("social_share_button.#{name.downcase}")
      html << link_to(h(link_title), "#", {:rel => ["nofollow", rel],
        "data-site" => name,
        :class => "social-share-button-#{name}",
        :onclick => "return SocialShareButton.share(this);"})
    end
    html << "</div>"
    raw html.join("\n")
  end
end
