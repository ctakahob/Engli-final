require 'rails_helper'
require 'capybara/rails'

RSpec.feature 'Devise test', type: :feature do
  let(:user) { create(:user) }
  before :each do
    sign_in user
  end

  context 'registration' do
    it 'sucsess registration' do
      sign_out user
      visit new_user_registration_path
      fill_in 'user_email', with: '123@msil.ru'
      fill_in 'user_username', with: 'catInCar'
      fill_in 'user_password', with: 'qwerty'
      fill_in 'user_password_confirmation', with: 'qwerty'
      click_button 'Sign up'
      expect(page).to have_content('Welcome! You have signed up successfully')
    end
  end

  context 'Users uniqe' do
    it 'failed registration' do
      sign_out user
      visit new_user_registration_path
      fill_in 'user_email', with: '123@msil.ru'
      fill_in 'user_username', with: 'catInCar'
      fill_in 'user_password', with: 'qwerty'
      fill_in 'user_password_confirmation', with: 'qwerty'
      click_button 'Sign up'
      visit destroy_user_session_path
      visit new_user_registration_path
      fill_in 'user_email', with: '123@msil.ru'
      fill_in 'user_username', with: 'catInCar'
      fill_in 'user_password', with: 'qwerty'
      fill_in 'user_password_confirmation', with: 'qwerty'
      click_button 'Sign up'
      expect(page).to have_content('2 errors prohibited this user from being saved')
    end
  end

  describe 'profile' do
    it 'Edit and login' do
      visit edit_user_registration_path
      fill_in 'user_email', with: 'citty@mail.ru'
      fill_in 'user_password', with: 'qwerty'
      fill_in 'user_password_confirmation', with: 'qwerty'
      fill_in 'user_current_password', with: 'password'
      click_button 'commit'
      expect(page).to have_content('Your account has been updated successfully')
      visit destroy_user_session_path
      expect(page).to have_content('You need to sign in or sign up before continuing.')
      fill_in 'user_email', with: 'citty@mail.ru'
      fill_in 'user_password', with: 'qwerty'
      click_button 'commit'
      expect(page).to have_content('Signed in successfully')
    end
  end

  context 'destroy account' do
    it 'successfully deleted' do
      visit edit_user_registration_path
      accept_alert do
        click_button 'Delete my account'
      end
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  end

  context 'redirect' do
    it 'routes should redirect to root path' do
      visit new_user_session_path
      expect(page).to have_content('Listting phrases')
    end

    it 'routes should redirect to log in' do
      sign_out user
      visit users_path
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  end
end
