class FeedbackRequestSender
  def appointments
    @appointments ||= Appointment.ready_for_feedback
  end

  def send_all_requests
    Rails.logger.info("Sending #{appointments.count} feedback requests")

    appointments.each do |appointment|
      UserMailer.feedback_request(appointment, appointment.mentor, appointment.mentee).deliver_now
      UserMailer.feedback_request(appointment, appointment.mentee, appointment.mentor).deliver_now

      appointment.update!(:feedback_sent => true)
    end
  end
end
