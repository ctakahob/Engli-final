require 'rails_helper'
require 'capybara/rails'

RSpec.feature 'UserShows', type: :feature do
  let(:user) { create(:user) }
  let!(:phrase) { create(:phrase, user: user) }
  before :each do
    sign_in user
  end

  describe 'change phrase' do
    it 'delete phrase' do
      visit user_path(user)
      accept_alert do
        click_link('Delete')
      end
      expect(page).to have_content('Phrase has been deleted')
      expect(page).to have_content('Phrase has been deleted')
    end
    it 'updated phrase' do
      visit edit_phrase_path(phrase)
      expect(page).to have_content('Edit Phrase')
      fill_in 'phrase_phrase', with: 'kitty cat'
      click_button 'Submit'
      expect(page).to have_content('kitty cat')
    end
  end
  describe 'failed create' do
    it 'fail transilition' do
      visit edit_phrase_path(phrase)
      expect(page).to have_content('Edit Phrase')
      fill_in 'phrase_translation', with: ''
      click_button 'Submit'
      expect(page).to have_content("Translation can't be blank")
    end

    it 'fail phrase' do
      visit edit_phrase_path(phrase)
      expect(page).to have_content('Edit Phrase')
      fill_in 'phrase_phrase', with: ''
      click_button 'Submit'
      expect(page).to have_content("Phrase can't be blank")
    end
  end

  context 'you author check?' do
    let!(:phrase) { create(:phrase) }
    it 'if you are not the author the method should redirect' do
      visit edit_phrase_path(phrase)
      expect(page).to have_content('You dont author')
    end
  end

  context 'Users list show' do
    it 'if success' do
      visit users_path
      expect(page).to have_content('List of users')
      expect(page).to have_content(user.username.to_s)
    end
  end

  describe 'phrase carma counter' do
    let!(:phrase) { create(:phrase) }
    it 'check carma if liked' do
      visit phrases_path
      click_link 'like'
      visit users_path
      expect(first('#carmaID')).to have_content '4' || '1'
      expect(page.all('#carmaID').find('1' || '4'))
    end

    it 'check carma if disliked' do
      visit phrases_path
      click_link 'dislike'
      visit users_path
      expect(first('#carmaID')).to have_content '-2' || '1'
      expect(page.all('#carmaID').find('1' || '-2'))
    end
  end
end
