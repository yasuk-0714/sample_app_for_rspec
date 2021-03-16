require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe 'タスクのCRUD' do
    let(:user) { create(:user) }
    let(:task) { create(:task) }
    describe 'タスクの一覧' do
      it 'タスク一覧が表示されること' do
        visit root_path
        expect(current_path).to eq root_path
      end
    end

    describe 'タスクの詳細' do
      it 'タスクの詳細が表示されること' do
        visit task_path(task)
        expect(current_path).to eq task_path(task)
        expect(page).to have_content task.title
      end
    end

    describe 'タスクの作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content("Login required")
        end
      end

      context 'ログインしている場合' do
        before { login(user) }
        it 'タスクが作成できること' do
          visit new_task_path
          fill_in 'Title', with: 'test'
          fill_in 'Content', with: 'testtest'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021,3,21,22,36)
          click_button 'Create'
          expect(current_path).to eq '/tasks/1'
          expect(page).to have_content("Task was successfully created.")
          expect(page).to have_content "Title: test"
        end

        it 'タイトルが空の時にタスクの作成に失敗すること' do
          visit new_task_path
          fill_in 'Title', with: nil
          fill_in 'Content', with: 'testtest'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021,3,21,22,36)
          click_button 'Create'
          expect(current_path).to eq tasks_path
          expect(page).to have_content("Title can't be blank")
        end

        it 'タイトルが重複した時にタスクの作成に失敗すること' do
          visit new_task_path
          fill_in 'Title', with: task.title
          fill_in 'Content', with: 'testtest'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021,3,21,22,36)
          click_button 'Create'
          expect(current_path).to eq tasks_path
          expect(page).to have_content("Title has already been taken")
        end
      end
    end

    describe 'タスクの更新' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content("Login required")
        end
      end

      context 'ログインしている場合' do
        before { login(user) }
        let(:task) { create(:task, user: user) }
        it 'タスクを更新できること' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'wasshoi'
          fill_in 'Content', with: 'wasshoiwasshoi'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content("Task was successfully updated.")
        end

        it 'タイトルが空でタスクの更新に失敗すること' do
          visit edit_task_path(task)
          fill_in 'Title', with: nil
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content("Title can't be blank")
        end

        it 'タイトルが重複してタスクの更新に失敗すること' do
          othor_task = create(:task)
          visit edit_task_path(task)
          fill_in 'Title', with: othor_task.title
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content("Title has already been taken")
        end
      end
    end

    describe '掲示板の削除' do
      before { login(user) }
      let!(:task) { create(:task, user: user) }
      it '掲示板が削除できること' do
        visit tasks_path
        click_link 'Destroy'
        expect(page.accept_confirm).to eq ("Are you sure?")
        expect(current_path).to eq tasks_path
        expect(page).to have_content("Task was successfully destroyed.")
      end
    end
  end
end