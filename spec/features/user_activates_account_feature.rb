require "rails_helper"

feature "User activates account" do
  scenario "following link from email activates the account" do
    user = FactoryGirl.create(:user)

    expect {
      visit activate_user_path(user.activation_code)
    }.to change { User.where(:activated => true).count }.by(1)
  end

  scenario "after activation an email with the user's management link is sent" do
    user = FactoryGirl.create(:user)

    visit activate_user_path(user.activation_code)

    expect(ActionMailer::Base.deliveries.last.body).to include(user.activation_code)
  end
end
