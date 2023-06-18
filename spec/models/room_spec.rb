require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "database" do
    context "must be present" do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:kind).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:read_only).of_type(:boolean).with_options(null: false, default: false) }
      it { is_expected.to have_db_column(:moderated).of_type(:boolean).with_options(null: false, default: false) }
      it { is_expected.to have_db_column(:origin_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:moderator_id).of_type(:integer) }
      it { is_expected.to have_db_column(:app_id).of_type(:integer).with_options(null: false) }
    end

    context "indexes" do
      it { is_expected.to have_db_index(:origin_id) }
      it { is_expected.to have_db_index(:app_id) }
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:app) }
    it { is_expected.to belong_to(:origin).class_name('User').with_foreign_key('origin_id') }
    it { is_expected.to belong_to(:moderator).class_name('User').with_foreign_key('moderator_id').optional }
    it { is_expected.to have_many(:room_participants).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:room_participants) }
  end

  describe "validations" do
    subject { build(:room) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:app_id).ignoring_case_sensitivity }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to define_enum_for(:kind).backed_by_column_of_type(:integer).with_values(grupo: 0, privado: 1, direct: 2) }
  end

  describe "create room" do
    context "successfully" do
      let!(:room) { build(:room) }

      it "should be valid" do
        expect(room).to be_valid
      end

      it "should have a group room type" do
        room.kind = "grupo"
        expect(room.kind).to eq("grupo")
      end
    end

    context "successfully - when repeat name and app_id is different" do
      let!(:room) { create(:room) }
      let!(:room2) { build(:room, name: room.name) }

      it "should be valid" do
        expect(room2).to be_valid
      end
    end

    context "failure - incompleted data" do
      let!(:room) { build(:room) }

      it "when name is nil" do
        room.name = nil
        expect(room).not_to be_valid
      end

      it "when kind is nil" do
        room.kind = nil
        expect(room).not_to be_valid
      end
    end

    context "failure - duplicated data" do
      let!(:room) { create(:room) }
      let!(:room2) { build(:room, name: room.name, app_id: room.app_id) }

      it "when name is duplicated" do
        expect(room2).not_to be_valid
      end
    end
  end
end
