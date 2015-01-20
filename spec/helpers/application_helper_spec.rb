require 'rails_helper'
class FakeApplicationHelper
  include ApplicationHelper

end

describe ApplicationHelper do
  def stub_link_to(symbol, date, value)
    helper.stub(:link_to).with(symbol, month: date.strftime("%Y-%m-01")).and_return(value)
  end
  context "month_link" do
    before :each do
      @date = DateTime.new(2013, 1, 1)
    end
    it "links to the previous month" do
      stub_link_to("<", @date.beginning_of_month - 1, "previous_month_link")
      link = helper.month_link("<", @date.beginning_of_month - 1)
      expect(link).to eq("previous_month_link")
    end

    it "links to the next month" do
      stub_link_to(">", @date.end_of_month + 1, "next_month_link")
      link = helper.month_link(">", @date.end_of_month + 1)
      expect(link).to eq("next_month_link")
    end
  end

  context "#appointment_time_in_words" do
    def make_appointment(time = 7.days.from_now)
      availability = FactoryGirl.create(:availability, :start_time => time, :duration => 60)
      FactoryGirl.create(:appointment, :availability => availability)
    end

    it "displays the distance in time from now" do
      appointment = make_appointment
      expect(helper.appointment_time_in_words(appointment)).to include("7 days")
    end

    it "displays 'from now' for future appointments" do
      appointment = make_appointment
      expect(helper.appointment_time_in_words(appointment)).to include("from now")
    end

    it "displays 'ago' for appointments that have already started" do
      appointment = make_appointment(5.minutes.ago)
      expect(helper.appointment_time_in_words(appointment)).to include("ago")
    end
  end

  context "#future_or_past_tense" do
    it "returns 'is mentoring' for an appointment with a future start date" do
      start_time = 1.day.from_now
      expect(future_or_past_tense(start_time)).to eq("is mentoring")
    end

    it "returns 'mentored' for an appointment with a past start date" do
      start_time = 1.day.ago
      expect(future_or_past_tense(start_time)).to eq("mentored")
    end
  end
end
