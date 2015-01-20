require 'rails_helper'

describe User do
  it { is_expected.to have_many(:mentoring_appointments) }
  it { is_expected.to have_many(:menteeing_appointments) }
  it { is_expected.to have_many(:availabilities) }
  it { is_expected.to have_many(:received_kudos) }
  it { is_expected.to have_many(:given_kudos) }

  it "should show kudos in pretty_name" do
    ryan = User.new(:first_name => "Ryan", :total_kudos => 42)
    expect(ryan.pretty_name).to eq("Ryan - 42")
  end
end
