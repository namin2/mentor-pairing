class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find_by_activation_code(params[:id])
    @availabilities = @user.availabilities.visible.order(:start_time)
    @menteeing_appointments = @user.menteeing_appointments.visible.order(:start_time)
    @mentoring_appointments = @user.mentoring_appointments.visible.order(:start_time)
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @menteeing_past_appointments = @user.menteeing_appointments.past.order(start_time: :desc).limit(5)
    @mentoring_past_appointments = @user.mentoring_appointments.past.order(start_time: :desc).limit(5)
  end

  def find_mentor
      user = User.find_by_email(params[:email])

      respond_to do |format|
        format.json do
          if user
            render :json => { :first_name => user.first_name,
                              :last_name => user.last_name,
                              :twitter_handle => user.twitter_handle,
                              :bio => user.bio,
                              :interests => user.interests}
          else
            render :json => { :no_user => true }
          end
        end
      end
  end

  def feedback
    @user = User.find_by_activation_code(params[:id])
    @feedback_for_user = @user.received_feedbacks.order("created_at DESC")
  end

  def send_manage_link
    user = User.find_by(email: params[:email])
    if user
      UserMailer.management_link(user).deliver_now
      flash[:notice] = "Management link sent."
      redirect_to root_path
    else
      flash.now[:notice] = "User could not be found"
      render :manage
    end
  end
end
