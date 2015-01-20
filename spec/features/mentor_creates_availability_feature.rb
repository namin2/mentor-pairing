require 'rails_helper'

feature "Mentor creates availability" do
  context "when the mentor provides valid input" do
    it "persists the availability to the database" do
      mentor = FactoryGirl.create(:mentor)

      visit new_availability_path
      fill_in :first_name, with: mentor.first_name
      fill_in :last_name, with: mentor.last_name
      fill_in :email, with: mentor.email
      fill_in :twitter_handle, with: mentor.twitter_handle
      fill_in :availability_duration, with: 60


      mentoring_time = 1.week.from_now
      select_datetime(mentoring_time, :availability_start_time)

      click_on :submit_availability

      expect(page).to have_content "#{mentor.name} on #{mentoring_time.strftime("%m/%d/%Y")}"
    end
  end

  context "when displaying the availabity request" do
    it "displays the user's full name" do
      availability = FactoryGirl.create(:availability)
      visit "/"

      avail_panel = find_link(availability.mentor.name).find(:xpath, "ancestor::div[@class='panel']")
      within(avail_panel) do
        click_link "Sign up"
      end

      expect(page).to have_text(availability.mentor.name)
    end
  end

  context "when the mentor provides recurrence parameters" do
    it "persists the availabilities to the database" do
      mentor = FactoryGirl.create(:mentor)

      visit new_availability_path
      fill_in :first_name, with: mentor.first_name
      fill_in :last_name, with: mentor.last_name
      fill_in :email, with: mentor.email
      fill_in :twitter_handle, with: mentor.twitter_handle
      fill_in :availability_duration, with: 60

      mentoring_time = 1.week.from_now
      select_datetime(mentoring_time, :availability_start_time)
      check :availability_setup_recurring
      select("week", :from => :availability_recur_weekly)
      select("1", :from => :availability_recur_num)

      expect {
        click_on :submit_availability
      }.to change(Availability, :count).by(2)
    end

    it "all availabilities are viewable by mentor" do
      mentor = FactoryGirl.create(:mentor)

      visit new_availability_path
      fill_in :first_name, with: mentor.first_name
      fill_in :last_name, with: mentor.last_name
      fill_in :email, with: mentor.email
      fill_in :twitter_handle, with: mentor.twitter_handle
      fill_in :availability_duration, with: 60

      mentoring_time = 1.week.from_now
      second_time = mentoring_time + 7.days
      select_datetime(mentoring_time, :availability_start_time)
      check :availability_setup_recurring
      select("week", :from => :availability_recur_weekly)
      select("1", :from => :availability_recur_num)

      click_on :submit_availability

      expect(page).to have_content "#{mentor.name} on #{mentoring_time.strftime("%m/%d/%Y")}"
      expect(page).to have_content "#{mentor.name} on #{second_time.strftime("%m/%d/%Y")}"
    end
  end
end
