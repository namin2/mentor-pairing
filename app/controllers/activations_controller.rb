class ActivationsController < ApplicationController
  def user
    user = User.find_by_activation_code(params[:code])
    if user
      unless user.activated?
        user.update_attribute(:activated, true)
        UserMailer.management_link(user).deliver_now
        flash[:notice] = "Congrats, you are a real person! Bookmark this page if you want to manage your mentoring appointments."
      end
    else
      raise "User not found by #{params[:code]}"
    end
    redirect_to edit_user_path(user.activation_code)
  end
end
