require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it '全ての属性が有効であること' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'タイトルがなければ無効であること' do
      task_without_title = build(:task, title: nil)
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    it 'ステータスがなければ無効であること' do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end

    it 'タイトルが重複していれば無効であること' do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end

    it '別のタイトルであれば有効であること' do
      task = create(:task)
      task_with_anothor_title = build(:task, title: "hogehoge")
      expect(task_with_anothor_title).to be_valid
      expect(task_with_anothor_title.errors).to be_empty
    end
  end
end
