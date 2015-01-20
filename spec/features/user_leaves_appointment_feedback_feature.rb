require "rails_helper"

feature "User leaves Appointment Feedback" do
  context "when a user provides the proper code and appointment id" do
    before(:each) { ActionMailer::Base.deliveries.clear }

    let(:appointment) { FactoryGirl.create(:appointment) }
    let(:mentor) { appointment.mentor }
    let(:student) { appointment.mentee }

    it "informs the user who they are leaving feedback for" do
      visit new_appointment_feedback_path(mentor.activation_code,
                                          :appointment_id => appointment.id)
      expect(page).to have_content("Leave Feedback for #{student.name}")
    end

    it "upon submission the user's feedback is saved" do
      visit new_appointment_feedback_path(mentor.activation_code,
                                          :appointment_id => appointment.id)

      fill_in "Feedback", :with => "Such and such was really great"

      expect {
        click_button "Submit Feedback"
      }.to change(AppointmentFeedback, :count).by(1)
    end

    it "sends the feedback receiever a notification upon submission" do
      visit new_appointment_feedback_path(mentor.activation_code,
                                          :appointment_id => appointment.id)

      fill_in "Feedback", :with => "Such and such was really great"
      click_button "Submit Feedback"

      expect(ActionMailer::Base.deliveries.last.to).to include student.email
    end
  end

  context "when feedback has been given" do
    it "the feedback receiver can view their feedback in their profile" do
      feedback = FactoryGirl.create(:appointment_feedback)

      visit feedback_user_path(feedback.feedback_receiver.activation_code)
      expect(page).to have_text(feedback.text)
    end
  end
end
