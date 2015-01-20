class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  has_many :availabilities, :foreign_key => :mentor_id
  has_many :mentoring_appointments, :foreign_key => :mentor_id, :class_name => "Appointment"
  has_many :menteeing_appointments, :foreign_key => :mentee_id, :class_name => "Appointment"
  has_many :appointment_requests, :foreign_key => :mentee_id
  has_many :received_kudos, :foreign_key => :mentor_id, :class_name => 'Kudo'
  has_many :given_kudos, :foreign_key => :mentee_id, :class_name => 'Kudo'
  has_many :received_feedbacks, :foreign_key => :feedback_receiver_id, :class_name => "AppointmentFeedback"

  validates_uniqueness_of :email

  before_create :create_activation_code

  def self.featured_mentors
    limit(10).order("total_kudos DESC")
  end

  def name
    [first_name, last_name].compact.join(" ")
  end

  def pretty_name
    "#{name} - #{total_kudos}"
  end

  def send_activation
    UserMailer.user_activation(self).deliver_now
    self
  end

  def send_appointment_request(availability)
    UserMailer.appointment_request(availability, self).deliver_now
  end

  def send_appointment_confirmation(appointment)
    UserMailer.appointment_confirmation(appointment).deliver_now
  end

  def send_appointment_rejection(availability)
    UserMailer.appointment_rejection(availability, self).deliver_now
  end

  private

  def create_activation_code
    self.activation_code = Digest::MD5.hexdigest( rand.to_s + Time.now.to_s + (twitter_handle || ""))
  end
end
