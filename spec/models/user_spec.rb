require 'rails_helper'

RSpec.describe User, type: :model do
  describe "database" do
    context "must be present" do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:fractal_id).of_type(:string).with_options(null: false) }
    end

    context "indexes" do
      it { is_expected.to have_db_index(:email).unique }
      it { is_expected.to have_db_index(:fractal_id).unique }
    end
  end

  describe "validations" do
    context "must be present" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:fractal_id) }
    end

    context "must be unique" do
      subject { FactoryBot.create(:user) }

      it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
      it { is_expected.to validate_uniqueness_of(:fractal_id).ignoring_case_sensitivity }
    end
  end
end
