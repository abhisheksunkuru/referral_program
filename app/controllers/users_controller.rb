class UsersController < ApplicationController
  before_action :authenticate_user!

  def home
    @referrals = current_user.type == "Admin" ? current_user.referrals : []
    respond_to do |format|
      format.html
      format.json do
        render json:{referrals: @referrals, personal_info: current_user}.to_json, status: 200
      end
    end
  end

  def invite

    if current_user.type == "Admin"
      email_id = params[:email]

      referrals = current_user.referrals.where(email: email_id)
      if referrals.present?
        msg = "Invitation already sent"
        flash[:info] = msg
        referral = referrals.last
      else
        referral = current_user.referrals.create!(email: email_id)
        msg = "Invitation sent successfully"
        flash[:success] = msg
        InvitationsMailer.invite_by_email_id(current_user, email_id).deliver_now
      end

      respond_to do |format|
        format.html do
          redirect_back(fallback_location: "/")
        end
        format.json do
          render json: {message: msg, referral: referral}.to_json, status: 200
        end
      end

    else
      msg = "You are not authorized to do this action"
      respond_to do |format|

        format.html do
          flash[:error] = msg
          redirect_to root_path
        end
        format.json do
          render json:{message: msg},status: 422
        end
      end
    end
  end

  def resend_invitation
    if current_user.type == "Admin"
      referral_id = params[:id]
      referral = Referral.where(id: referral_id).last
      if referral.present?
        count = referral.resend_count
        InvitationsMailer.invite_by_email_id(current_user, referral.email).deliver_now
        referral.update(resend_count: count+1)
        message = "Resend invitation successflly"
        flash[:success] = message
      else

        message = "Referral record doesnot found"
        flash[:error] = message
      end
      respond_to do |format|
        format.html do
          redirect_back(fallback_location: "/")
        end
        format.json do
          format.json do
            render json:{referral: referral, message: msg}.to_json, status: 200
          end
        end
      end
    else
      msg = "You are not authorized"
      flash[:error] = msg
      respond_to do |format|
        format.html{redirect_back(fallback_location: "/")}
        format.json{render json:{message: msg}.to_json, status: 422}
      end
    end

  end

end
