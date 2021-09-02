require 'rails_helper'
require 'capybara/rails'

RSpec.feature 'Phrases', type: :feature do
  let(:user) { create(:user) }
  let!(:phrase) { create(:phrase, user: user) }
  before :each do
    sign_in user
  end

  context 'check phrases routes' do
    it 'path of the phrase' do
      visit phrases_path
      click_link 'phrase_path'
      expect(page).to have_content("Author: #{user.username}")
    end

    it 'path of the user' do
      visit phrases_path
      click_link(href: user_path(phrase.user))
      expect(page).to have_content("Username: #{user.username}")
    end
  end

  describe 'new phrase' do
    it 'successfully created' do
      visit new_phrase_path
      expect do
        fill_form(:phrase, { phrase: 'cat', translation: 'cat rules', category: Phrase.categories.keys[3] })
        fill_form(:example, { example: 'cat rules at world' })
        click_button 'Submit'
      end.to change(Phrase, :count).by(1)
    end
    it 'failed' do
      visit new_phrase_path
      click_button 'Submit'
      expect(page).to have_content("Examples example can't be blank, Phrase can't be blank, and Translation can't be blank")
    end

    it 'unique phrase' do
      visit new_phrase_path
      fill_form(:phrase, { phrase: 'cat', translation: 'cat rules', category: Phrase.categories.keys[3] })
      fill_form(:example, { example: 'cat rules at world' })
      click_button 'Submit'
      visit new_phrase_path
      fill_form(:phrase, { phrase: 'cat', translation: 'cat rules', category: Phrase.categories.keys[3] })
      fill_form(:example, { example: 'cat rules at world' })
      click_button 'Submit'
      expect(page).to have_content('Examples example has already been taken, Phrase has already been taken, and Translation has already been taken')
    end
  end
  describe 'phrase salflike' do
    it 'like fail' do
      visit phrases_path
      click_link 'like'
      expect(page).to have_content('You cant like or dislike yourself')
    end
    it 'dislike fail' do
      visit phrases_path
      click_link 'dislike'
      expect(page).to have_content('You cant like or dislike yourself')
    end
  end

  describe 'vote activity' do
    let!(:phrase) { create(:phrase) }
    it 'like' do
      visit phrases_path
      click_link 'like'
      expect(page).to have_content('you voted!')
    end

    it 'dislike' do
      visit phrases_path
      click_link 'dislike'
      expect(page).to have_content('you voted!')
    end

    it 'if 2 times like should' do
      visit phrases_path
      click_link 'like'
      click_link 'like'
      expect(page).to have_content('You already voted that phrase')
    end

    it 'Double dislike' do
      visit phrases_path
      click_link 'dislike'
      click_link 'dislike'
      expect(page).to have_content('You already voted that phrase')
    end
  end
end
