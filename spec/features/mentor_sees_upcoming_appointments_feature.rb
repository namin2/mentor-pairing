require 'rails_helper'

feature "a mentor can see upcoming appointments" do
  let!(:appointment) { FactoryGirl.create(:appointment) }
  let!(:mentor) { appointment.mentor }
  let!(:mentee) { appointment.mentee }

  scenario "on the profile page" do
    visit(edit_user_path(mentor.activation_code))

    save_and_open_page

    expect(page).to have_content mentor.name
    expect(page).to have_content mentee.name
  end
end
