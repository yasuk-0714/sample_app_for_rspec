require 'rails_helper'

RSpec.describe "Users", type: :system do

  let(:user) { create(:user) }
  let(:othor_user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit sign_up_path
          click_link 'SignUp'
          fill_in 'Email', with: 'wasshoi@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(current_path).to eq login_path
          expect(page).to have_content('User was successfully created.')
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          click_link 'SignUp'
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content '1 error prohibited this user from being saved' #追記
          expect(current_path).to eq users_path
          expect(page).to have_content("Email can't be blank")
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          exist_user = create(:user) #exist_user追記
          visit sign_up_path
          click_link 'SignUp'
          fill_in 'Email', with: exist_user.email #追記
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content '1 error prohibited this user from being saved' #追記
          expect(page).to have_content("Email has already been taken")
          expect(page).to have_field 'Email', with: exist_user.email #追記 exist_userのメールがフィールドに入っているか
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content("Login required")
        end
      end
    end
  end

  describe 'ログイン後' do
    before {login(user)}
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'Email', with: 'hoge@example.com'
          fill_in 'Password', with: 'hoge'
          fill_in 'Password confirmation', with: 'hoge'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content("User was successfully updated.")
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content('1 error prohibited this user from being saved') #追記
          expect(page).to have_content("Email can't be blank")
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: othor_user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content('1 error prohibited this user from being saved') #追記
          expect(page).to have_content("Email has already been taken")
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_user_path(othor_user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_content("Forbidden access.")
        end
      end
    end
    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          create(:task, title: "テスト", status: :todo, user: user)
          visit user_path(user)
          expect(page).to have_content("You have 1 task.")
          expect(page).to have_content('テスト') #追記
          expect(page).to have_content('todo') #追記
          expect(page).to have_link('Show') #追記
          expect(page).to have_link('Edit') #追記
          expect(page).to have_link('Destroy') #追記
        end
      end
    end
  end
end
