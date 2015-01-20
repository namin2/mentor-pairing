require 'rails_helper'

describe AvailabilitiesController do
  describe "#create" do
    let(:mentor) { FactoryGirl.create(:mentor) }

    it "creates a new availability given params" do
      expect {
        post :create, email: mentor.email, availability: FactoryGirl.attributes_for(:availability)
      }.to change{Availability.count}.by(1)
    end

    it "returns mentor info with JSON" do
      availability = FactoryGirl.create(:availability)
      get :index, :format => :json
      JSON.parse(response.body).first["mentor_name"].should == availability.mentor.name
    end

    it "handles datepicker style start times" do
      availability_params = {
        :duration => 30,
        'start_time(1s)' => '2013-01-01',
        'start_time(4i)' => '00',
        'start_time(5i)' => '00',
        :timezone => 'UTC',
        :city => 'Chicago'
      }
      expect do
        post :create, email: mentor.email, availability: availability_params
      end.to change{Availability.count}.by(1)
    end
  end

  describe '#remaining' do
    it 'should assign physical cities' do
      get :remaining
      assigns(:cities).should =~ Location.all.select(&:physical?)
    end
  end

  describe '#remaining_in_city' do
    it 'should provide availabilities' do
      Availability.should_receive(:visible).and_call_original
      Availability.should_receive(:today).with('Central Time (US & Canada)').and_call_original
      Availability.should_receive(:in_city).with('Chicago').and_call_original
      Availability.should_receive(:without_appointment_requests).and_call_original
      get :remaining_in_city, :city => 'chicago'
      assigns(:availabilities).should be_a(ActiveRecord::Relation)
    end

    context "via regular GET request" do
      it "should render with empty layout" do
        get :remaining_in_city, {:city => 'chicago'}
        expect(response).to render_template(layout: "empty")
      end
    end

    context "via XHR GET request" do
      it "should render without layout" do
        xhr :get, :remaining_in_city, {:city => 'chicago'}
        expect(response).to render_template(layout: false)
      end
    end
  end
end
