# app/validators/reserved_name_validator.rb
class ReservedNameValidator < ActiveModel::EachValidator
  RESERVED_NAMES = %w{
    about account add admin api
    app apps archive archives auth
    blog event
    config connect contact create company companies
    delete downloads
    edit email
    faq favorites feed feeds follow followers following
    group groups
    help home
    invitations invite
    jobs job
    login log-in logout log-out logs
    map maps
    oauth openid
    privacy
    register remove replies rss
    save search sessions settings
    signup sign-up signin sign-in signout sign-out
    sitemap ssl subscribe
    terms test trends
    unfollow unsubscribe url user
    widget widgets
    xfn xmpp
    classroom
  }

  def validate_each(record, attribute, value)
    unless value =~ /\A[a-z0-9][a-z0-9-]*\z/i
      record.errors.add(attribute, :invalid_name)
    end

    if RESERVED_NAMES.include?(value)
        record.errors.add(attribute, :reserved_name)
    end
  end
end
