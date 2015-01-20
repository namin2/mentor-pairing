require "rails_helper"

feature "Staff Views Weekly Metrics" do
  scenario "displays the total number of appointments this week" do
    10.times {
      availability = FactoryGirl.create(:availability,
                      :start_time => rand(Time.now.beginning_of_week(:sunday)..Time.now.end_of_week(:sunday)),
                      :duration => 60)
      FactoryGirl.create(:appointment, :availability => availability)
    }

    visit weekly_metrics_path

    expect(page).to have_content("10 appointments this week")
  end

  scenario "display the metrics for the week of an arbitrary date" do
    previous_date = 2.weeks.ago
    prev_week_begin = previous_date.beginning_of_week(:sunday)

    visit weekly_metrics_path(:for => previous_date.strftime("%Y%m%d"))

    expect(page).to have_content("Metrics for the week of #{prev_week_begin.strftime("%Y-%m-%d")}")
  end

  scenario "displays link for last week's metrics" do
    last_week = 1.week.ago

    visit weekly_metrics_path

    expect(page).to have_link(nil, :href => weekly_metrics_path(:for => last_week.strftime("%Y%m%d")))
  end

  scenario "displays link for current week's metrics if on other week" do
    previous_date = 2.weeks.ago
    prev_week_begin = previous_date.beginning_of_week(:sunday)

    visit weekly_metrics_path(:for => previous_date.strftime("%Y%m%d"))

    expect(page).to have_link(nil, :href => weekly_metrics_path)
  end

  context "when viewing abandoned availabilties" do
    context "and an abandoned availability exists" do
      scenario "displays number of current week's abandoned availabilties" do
        arbitrary_date = Time.new(2014, 3, 19)
        FactoryGirl.create(:availability,
                           :start_time => 1.day.ago(arbitrary_date),
                           :duration => 60)

        visit weekly_metrics_path(:for => arbitrary_date.strftime("%Y%m%d"))

        expect(page).to have_content("1 abandoned availability this week")
      end
    end

    context "and there are no abandoned availabilities" do
      scenario "displays 0 abandoned availabilties" do
        visit weekly_metrics_path

        expect(page).to have_content("0 abandoned availabilities this week")
      end
    end
  end
end
