class InvitationsMailer < ApplicationMailer

  def invite_by_email_id(user, email_id)
    @user = user
    mail(to: email_id, subject: "Invitation for Signup")
  end
end
