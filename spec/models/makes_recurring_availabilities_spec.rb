require "rails_helper"

describe MakesRecurringAvailabilities do
  context "#setup_recurring_availabilities?" do
    it "is false when recurrence parameter is missing" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {})
      expect(maker).to_not be_setting_up_recurrence
    end

    it "is false when recurrence parameter is blank" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {"setup_recurring" => ""})
      expect(maker).to_not be_setting_up_recurrence
    end

    it "is false when recurrence parameter is 0" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {"setup_recurring" => "0"})
      expect(maker).to_not be_setting_up_recurrence
    end

    it "is true when recurrence parameter is 1" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {"setup_recurring" => "1"})
      expect(maker).to be_setting_up_recurrence
    end
  end

  context "#recurrence_factor" do
    it "weekly is equal to 7 days" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {"recur_weekly" => "1"})
      expect(maker.recurrence_factor).to eq(7.days)
    end

    it "2 weeks is equal to 14 days" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {"recur_weekly" => "2"})
      expect(maker.recurrence_factor).to eq(14.days)
    end

    it "monthly is equal to 28 days" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {"recur_weekly" => "4"})
      expect(maker.recurrence_factor).to eq(28.days)
    end

    it "is 0 when option is not provided" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {})
      expect { maker.recurrence_factor }.to raise_error
    end
  end

  context "#number_of_recurrences" do
    it "it casts the option as an integer" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {"recur_num" => "4"})
      expect(maker.number_of_recurrences).to eq(4)
    end

    it "is 0 if the option is not provided" do
      maker = MakesRecurringAvailabilities.new(double(:mentor), {})
      expect(maker.number_of_recurrences).to eq(0)
    end
  end

  context "without recurrence" do
    it "makes one availability" do
      mentor = FactoryGirl.create(:mentor)
      maker = MakesRecurringAvailabilities.new(mentor, FactoryGirl.attributes_for(:availability))

      expect {
        maker.make_availabilities
      }.to change(Availability, :count).by(1)
    end
  end

  context "when scheduling weekly recurrences" do
    it "with 1 recurrence, creates 2 appointments" do
      mentor = FactoryGirl.create(:mentor)
      attributes = FactoryGirl.attributes_for(:availability)
      attributes.merge!("setup_recurring" => "1", "recur_weekly" => "1", "recur_num" => "1")
      maker = MakesRecurringAvailabilities.new(mentor, attributes)

      expect {
        maker.make_availabilities
      }.to change(Availability, :count).by(2)
    end

    it "spaces recurrences weekly" do
      mentor = FactoryGirl.create(:mentor)
      attributes = FactoryGirl.attributes_for(:availability)
      attributes.merge!("setup_recurring" => "1", "recur_weekly" => "1", "recur_num" => "2")
      maker = MakesRecurringAvailabilities.new(mentor, attributes)

      maker.make_availabilities
      other_appointment_time = attributes[:start_time] + 14.days
      expect(Availability.last.start_time.to_i).to eq(other_appointment_time.to_i)
    end
  end

  context "when scheduling bi-weekly recurrences" do
    it "spaces recurrences two weeks apart" do
      mentor = FactoryGirl.create(:mentor)
      attributes = FactoryGirl.attributes_for(:availability)
      attributes.merge!("setup_recurring" => "1", "recur_weekly" => "2", "recur_num" => "1")
      maker = MakesRecurringAvailabilities.new(mentor, attributes)

      maker.make_availabilities
      other_appointment_time = attributes[:start_time] + 14.days
      expect(Availability.last.start_time.to_i).to eq(other_appointment_time.to_i)
    end
  end

  context "when scheduling monthly recurrences" do
    it "spaces recurrences a month apart" do
      mentor = FactoryGirl.create(:mentor)
      attributes = FactoryGirl.attributes_for(:availability)
      attributes.merge!("setup_recurring" => "1", "recur_weekly" => "4", "recur_num" => "1")
      maker = MakesRecurringAvailabilities.new(mentor, attributes)

      maker.make_availabilities
      other_appointment_time = attributes[:start_time] + 28.days
      expect(Availability.last.start_time.to_i).to eq(other_appointment_time.to_i)
    end
  end
end
