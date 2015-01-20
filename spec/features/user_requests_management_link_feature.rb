require "rails_helper"

feature "User Requests Management Link" do
  scenario "with valid user, user is sent management link email" do
    availability = FactoryGirl.create(:availability)

    visit "/"
    click_link "Manage my appointments"

    fill_in "Email", :with => availability.mentor.email
    click_button "Submit"

    expect(
      ActionMailer::Base.deliveries.last.body
    ).to include(availability.mentor.activation_code)
  end

  scenario "with invalid user, error message is displayed" do
    bad_email = Faker::Internet.email(Faker::Lorem.words(2).join(" "))

    visit "/"
    click_link "Manage my appointments"

    fill_in "Email", :with => bad_email
    click_button "Submit"

    expect(page).to have_text("User could not be found")
  end
end
