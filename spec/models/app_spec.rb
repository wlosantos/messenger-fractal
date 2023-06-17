require 'rails_helper'

RSpec.describe App, type: :model do
  describe "database" do
    context "must be present" do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    end
  end

  describe "validations" do
    context "presence" do
      it { is_expected.to validate_presence_of(:name) }
    end
  end

  describe "create app" do
    context "successfully" do
      subject { create(:app) }
      it { is_expected.to be_valid }
    end

    context "failure - without name" do
      subject { build(:app, name: nil) }
      it { is_expected.to_not be_valid }
    end
  end
end
