require 'rails_helper'
require 'capybara/rails'

RSpec.feature 'Phrases', type: :feature do
  let(:user) { create(:user) }
  let!(:phrase) { create(:phrase, user: user) }
  before :each do
    sign_in user
  end
  describe 'new example' do
    it 'successfully create' do
      visit phrase_path(phrase)
      expect do
        fill_in 'example_example', with: 'cat Ruulleeess!'
        click_button 'commit'
      end.to change(Example, :count).by(1)
    end
    it 'fail' do
      visit phrase_path(phrase)
      click_button 'commit'
      expect(page).to have_content("Example can't be blank")
    end

    it 'failed uniqe example' do
      visit phrase_path(phrase)
      fill_in 'example_example', with: 'cat Ruulleeess!'
      click_button 'commit'
      fill_in 'example_example', with: 'cat Ruulleeess!'
      click_button 'commit'
      expect(page).to have_content('Example has already been taken')
    end
  end
  describe 'votes of examples' do
    let!(:example) { create(:example, phrase: phrase) }
    it 'vote up successfully' do
      visit phrase_path(phrase)
      click_link 'vote_up'
      expect(page).to have_content('you voted')
    end

    it 'vote down successfully' do
      visit phrase_path(phrase)
      click_link 'vote_down'
      expect(page).to have_content('you voted')
    end
  end
  describe 'selflike' do
    let!(:example) { create(:example, phrase: phrase, user: user) }
    it 'vote up fail' do
      visit phrase_path(phrase)
      click_link 'vote_up'
      expect(page).to have_content('You cant like or dislike yourself')
    end

    it 'vote down fail' do
      visit phrase_path(phrase)
      click_link 'vote_down'
      expect(page).to have_content('You cant like or dislike yourself')
    end
  end

  context 'double voted' do
    let!(:example) { create(:example, phrase: phrase) }
    it 'double vote' do
      visit phrase_path(phrase)
      click_link 'vote_up'
      click_link 'vote_up'
      expect(page).to have_content('You already voted that post')
    end
  end

  context 'delete example' do
    let!(:example) { create(:example, phrase: phrase, user: user) }
    it 'successfully deleted' do
      visit phrase_path(phrase)
      accept_alert do
        click_link 'delete'
      end
      expect(page).to have_content('Example deleted!')
    end
  end

  describe 'carma score' do
    let!(:example) { create(:example, phrase: phrase) }
    context 'points for examples' do
      it 'vote up' do
        visit phrase_path(phrase)
        click_link 'vote_up'
        visit users_path
        expect(first('#carmaID')).to have_content('2' || '1')
        expect(page.all('#carmaID').find('1' || '2'))
      end

      it 'vote_down' do
        visit phrase_path(phrase)
        click_link 'vote_down'
        visit users_path
        expect(first('#carmaID')).to have_content('-1' || '1')
        expect(page.all('#carmaID').find('1' || '-1'))
      end
    end
  end
end
