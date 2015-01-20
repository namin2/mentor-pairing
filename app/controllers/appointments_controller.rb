class AppointmentsController < ApplicationController
  def create
    mentee = User.find(params[:mentee_id])
    mentor = User.find_by_activation_code(params[:code])
    availability = mentor.availabilities.find_by_id(params[:availability_id])

    if availability
      AppointmentFactory.create!(availability, mentee, mentor)
      flash[:notice] = "An appointment has been created for you and #{mentee.name}. Enjoy!"
    else
      flash[:notice] = "This time is no longer available. Please create more mentoring availability."
    end

    redirect_to edit_user_path(mentor.activation_code)
  end

  def feedback
    @feedback_giver = User.find_by_activation_code(params[:user_code])
    @appointment = Appointment.find_by_id_and_user(params[:appointment_id], @feedback_giver)
    @feedback_receiver = if @feedback_giver == @appointment.mentor
                           @appointment.mentee
                         else
                           @appointment.mentor
                         end
  end

  def accept_feedback
    @feedback_giver = User.find_by_activation_code(params[:user_code])
    @appointment = Appointment.find_by_id_and_user(params[:appointment_id], @feedback_giver)
    @feedback_receiver = if @feedback_giver == @appointment.mentor
                           @appointment.mentee
                         else
                           @appointment.mentor
                         end

    feedback = AppointmentFeedback.create!(:appointment => @appointment,
                                           :feedback_giver => @feedback_giver,
                                           :feedback_receiver => @feedback_receiver,
                                           :text => params[:feedback][:text])
    UserMailer.new_feedback_notification(feedback).deliver_now
  end
end
