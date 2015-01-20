require 'rails_helper'

describe User do
  it { should have_many(:mentoring_appointments) }
  it { should have_many(:menteeing_appointments) }
  it { should have_many(:availabilities) }
  it { should have_many(:received_kudos) }
  it { should have_many(:given_kudos) }

  it "should show kudos in pretty_name" do
    ryan = User.new(:first_name => "Ryan", :total_kudos => 42)
    ryan.pretty_name.should == "Ryan - 42"
  end
end
