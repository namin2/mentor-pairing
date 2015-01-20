require 'rails_helper'

describe AppointmentRequestsController do
  describe "#create" do
    it "creates a record of the appointment request" do
      availability = FactoryGirl.create(:availability)
      mentee = FactoryGirl.create(:mentee, activated: true)

      expect {
        post :create, availability_id: availability.id, email: mentee.email
      }.to change{mentee.appointment_requests.count}.by(1)
    end

    it "creates a new user if user doesn't exist and given params" do
      expect {
        post :create, email: "erik@example.com", :first_name => "Erik", :last_name => "Allar", :twitter_handle => "erik"
      }.to change{User.count}.by(1)
    end

    it "does not create a new user if user is exists but is unactivated" do
      user = FactoryGirl.create(:mentor, :activated => false)
      expect {
        post :create, email: user.email, :first_name => "Erik", :last_name => "Allar", :twitter_handle => "erik"
      }.to_not change{User.count}
    end
  end
end
