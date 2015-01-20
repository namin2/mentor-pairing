require "rails_helper"

describe Location do
	describe "#find_by_name" do
		it "should find cities by name" do
			location = Location.find_by_name("Chicago")
			expect(location).to be_a Location
			expect(location.name).to eq "Chicago"
		end
	end

	describe "#find_by_slug" do
		it "should find cities by slug" do
			location = Location.find_by_slug("san-francisco")
			expect(location).to be_a Location
			expect(location.name).to eq "San Francisco"
		end
	end

	describe "#physical?" do
		it "should be true for cities" do
			expect(Location.new("Chicago")).to be_physical
		end

		it "should be false for remote" do
			expect(Location.new("Remote")).to_not be_physical
		end
	end

	describe "#slug" do
		let(:location) { Location.new("Foo Bar") }

		it "should convert full name names to slugs"  do
			expect(location.slug).to eq ("foo-bar")
		end
	end

	describe "::all" do
		it "should return all DBC locations" do
			expect(Location.all.map(&:name)).to eq Location::LOCATION_NAMES
		end
	end

	describe "::slug_to_name" do
		it "should convert slugs to full names" do
			expect(Location.slug_to_name("foo-bar")).to eq "Foo Bar"
		end
	end
end
