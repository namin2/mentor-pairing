require 'rails_helper'

feature "a mentor can see past appointments" do
  let!(:appointment) { FactoryGirl.create(:appointment) }
  let!(:mentor) { appointment.mentor }
  let!(:mentee) { appointment.mentee }

  scenario "on the profile page" do
    end_time = 1.week.ago
    appointment.update(end_time: end_time)
    visit(edit_user_path(mentor.activation_code))

    save_and_open_page

    expect(page).to have_content mentor.name
    expect(page).to have_content mentee.name
  end
end

feature "a mentee can see past appointments" do
  let!(:appointment) { FactoryGirl.create(:appointment) }
  let!(:mentor) { appointment.mentor }
  let!(:mentee) { appointment.mentee }

  scenario "on the profile page" do
    end_time = 1.week.ago
    appointment.update(end_time: end_time)
    visit(edit_user_path(mentee.activation_code))

    save_and_open_page

    expect(page).to have_content mentor.name
    expect(page).to have_content mentee.name
  end
end
