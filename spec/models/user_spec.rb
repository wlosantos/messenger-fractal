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

  describe "associations" do
    it { is_expected.to have_many(:moderator_rooms).class_name('Room').with_foreign_key('moderator_id') }
    it { is_expected.to have_many(:origin_rooms).class_name('Room').with_foreign_key('origin_id') }
  end

  describe "create user" do
    context "successfully" do
      let!(:user) { build(:user) }
      it { expect(user).to be_valid }
    end

    context "failure - incompleted data" do
      let!(:user) { build(:user, email: nil) }
      it { expect(user).not_to be_valid }
    end

    context "failure - duplicated data" do
      let!(:user) { create(:user) }
      let!(:user2) { build(:user, email: user.email) }
      it { expect(user2).not_to be_valid }
    end

    context "failure - invalid email" do
      let(:user) { build(:user, email: "invalid_email") }
      it { expect(user).not_to be_valid }
    end

    context "with admin role" do
      let(:user) { create(:user, :admin) }
      it { expect(user).to be_valid }
      it { expect(user.has_role?(:admin)).to be_truthy }
    end

    context "with user role" do
      let(:user) { create(:user, :user) }
      it { expect(user).to be_valid }
      it { expect(user.has_role?(:user)).to be_truthy }
    end

    context "with first user is admin" do
      let(:user) { create(:user) }
      it { expect(user.has_role?(:admin)).to be_truthy }
    end
  end
end
