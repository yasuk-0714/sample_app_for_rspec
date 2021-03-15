require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it '全ての属性が有効であること' do
      expect(FactoryBot.build(:task)).to be_valid
    end

    it 'タイトルがなければ無効であること' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'ステータスがなければ無効であること' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'タイトルが重複していれば無効であること' do
      FactoryBot.create(:task)
      task = FactoryBot.build(:task)
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end

    it '別のタイトルであれば有効であること' do
      FactoryBot.create(:task)
      task = FactoryBot.build(:task, title: "hogehoge")
      task.valid?
      expect(task).to be_valid
    end
  end
end
