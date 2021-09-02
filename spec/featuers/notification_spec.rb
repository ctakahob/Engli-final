require 'rails_helper'

RSpec.feature 'Notifications', type: :feature do
  let(:user) { create(:user) }
  before :each do
    sign_in user
  end

  describe 'check notifications' do
    let!(:phrase) { create(:phrase) }

    context 'Examples notifications' do
      let!(:example) { create(:example, phrase: phrase) }
      it 'voted up message' do
        visit phrase_path(phrase)
        click_link 'vote_up'
        expect(page).to have_content('you voted')
        sign_out user
        sign_in example.user
        visit root_path
        click_link 'new_notifications'
        expect(page).to have_content('Liked your example')
      end
      it 'voted down message' do
        visit phrase_path(phrase)
        click_link 'vote_down'
        expect(page).to have_content('you voted')
        sign_out user
        sign_in example.user
        visit root_path
        click_link 'new_notifications'
        expect(page).to have_content('Disliked your example')
      end
    end

    context 'Phrases notifications' do
      it 'like message' do
        visit phrases_path
        click_link 'like'
        expect(page).to have_content('you voted')
        sign_out user
        sign_in phrase.user
        visit root_path
        click_link 'new_notifications'
        expect(page).to have_content('Liked your phrase')
      end
      it 'dislike message' do
        visit phrases_path
        click_link 'dislike'
        expect(page).to have_content('you voted')
        sign_out user
        sign_in phrase.user
        visit root_path
        click_link 'new_notifications'
        expect(page).to have_content('Disliked your phrase')
      end
    end
  end

  context 'delete notifications' do
    let!(:phrase) { create(:phrase) }
    it 'successfully delete' do
      visit phrases_path
      click_link 'dislike'
      expect(page).to have_content('you voted')
      sign_out user
      sign_in phrase.user
      visit root_path
      click_link 'new_notifications'
      click_link 'delete_notification'
      expect(page).to have_content('notification deleted')
    end
  end
end
