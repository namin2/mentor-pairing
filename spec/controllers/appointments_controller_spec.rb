require 'rails_helper'

describe AppointmentsController do
  describe "#create" do
    it "creates a new appointment" do
      availability = FactoryGirl.create(:availability)
      mentor = availability.mentor
      mentee = FactoryGirl.create(:mentee)

      expect {
        post :create, code: mentor.activation_code, mentee_id: mentee.id, availability_id: availability.id
      }.to change{Appointment.count}.by(1)
    end

    it "sends emails to accepted and rejected mentees" do
      availability = FactoryGirl.create(:availability)
      mentor = availability.mentor
      mentee = FactoryGirl.create(:mentee)
      other_mentee = FactoryGirl.create(:user)

      availability.appointment_requests.create!(:mentee => mentee)
      availability.appointment_requests.create!(:mentee => other_mentee)

      expect(UserMailer).to receive(:appointment_confirmation).and_return(double(:deliver_now => true))
      expect(UserMailer).to receive(:appointment_rejection).with(availability, other_mentee).and_return(double(:deliver_now => true))

      post :create, code: mentor.activation_code, mentee_id: mentee.id, availability_id: availability.id
    end

    it "does not create a new appointment if availability no longer exists" do
      mentor = FactoryGirl.create(:mentor)
      mentee = FactoryGirl.create(:mentee)

      expect {
        post :create, code: mentor.activation_code, mentee_id: mentee.id, availability_id: "42"*4
      }.not_to change{Appointment.count}
    end
  end
end
