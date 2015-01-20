require "rails_helper"

describe Availability do
  it { is_expected.to belong_to(:mentor) }

  describe "when first created" do
    before(:each) do
      @start_time = DateTime.new(2013, 1, 1)
      @availability = FactoryGirl.create(:availability,
        start_time: @start_time,
        city: 'Chicago')
    end

    it "should have a start_time" do
      expect(@availability.start_time).to eq(@start_time)
    end

    it "should have an end_time which is the duration times 60" do
      expect(@availability.end_time).to eq(@availability.start_time + 1800)
    end

    context "length" do
      it "should be 30 minutes long" do
        expect(@availability.end_time - @availability.start_time).to eq(1800)
      end
    end

    context "when validating city" do
      it { is_expected.to validate_inclusion_of(:city).in_array(Location::LOCATION_NAMES) }
    end

    describe '::today' do
      it 'should check start_time bounds for today' do
        now = Time.new(2013,12,2,0,0,0, "-05:00")
          .in_time_zone("Eastern Time (US & Canada)")

        allow(Time).to receive(:now) { now }

        utc_eod = Availability.utc_eod_for_tz(now, "Central Time (US & Canada)")

        expect(Availability)
          .to(receive(:where)
            .with('start_time between ? and ?',
              now.utc.to_s,
              utc_eod.to_s))

        Availability.today("Central Time (US & Canada)")
      end
    end

    describe '::without_appointment_requests' do
      let(:mentor) { FactoryGirl.create(:mentor) }
      let(:mentee) { FactoryGirl.create(:mentee) }

      it "should fetch availabilities without appointment requests" do
        params = {
          timezone:"UTC",
          start_time: Time.new(2013,12,2,0,0,0, "-05:00"),
          mentor: mentor,
          city: 'Chicago'
        }

        a1 = Availability.create!(params)
        a2 = Availability.create!(params)
        a3 = Availability.create!(params)
        ar = AppointmentRequest.create!(:mentee => mentee, :availability => a2)

        without_appointments = Availability.without_appointment_requests
        expect(without_appointments).to include(a1,a3)
        expect(without_appointments).to_not include(a2)
      end
    end

    describe '::utc_eod_for_tz' do
      it "should produce a locale's EOD as UTC" do
        time_in_est = Time.new(2013,12,2,0,0,0, "-05:00")
          .in_time_zone("Eastern Time (US & Canada)")

        cst_eod = Time.new(2013,12,1,23,59,59, "-06:00")
          .in_time_zone("Central Time (US & Canada)")

        expect(Availability
          .utc_eod_for_tz(time_in_est, "Central Time (US & Canada)")
          .to_s)
          .to eq(cst_eod.utc.to_s)
      end
    end

    describe '::CITY_ROUTE_CONSTRAINT' do
      it 'should reject invalid cities' do
        expect(Availability::CITY_ROUTE_CONSTRAINT.call(city:'atlantis'))
          .to eq nil
      end

      it 'should reject remote' do
        expect(Availability::CITY_ROUTE_CONSTRAINT.call(city:'remote'))
          .to eq false
      end

      it 'should accept valid city' do
        expect(Availability::CITY_ROUTE_CONSTRAINT.call(city:'san-francisco'))
          .to eq true
      end
    end
  end
end
