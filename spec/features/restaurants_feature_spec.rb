require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'The Ox')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('The Ox')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'The Ox'
      click_button 'Create Restaurant'
      expect(page).to have_content 'The Ox'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'viewing restaurants' do
    let!(:the_ox){Restaurant.create(name: 'The Ox')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'The Ox'
      expect(page).to have_content 'The Ox'
      expect(current_path).to eq "/restaurants/#{the_ox.id}"
    end
  end

  context 'editing restaurants' do
    before { Restaurant.create name: 'The Ox' }

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit The Ox'
      fill_in 'Name', with: 'The Ox restaurant'
      click_button 'Update Restaurant'
      expect(page).to have_content 'The Ox restaurant'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do 
    before { Restaurant.create name: 'The Ox'} 

    scenario 'removes a restaurant when user clicks delete' do
      visit '/restaurants'
      click_link 'Delete The Ox'
      expect(page).not_to have_content('The Ox')
      expect(page).to have_content('Restaurant deleted successfully')
    end

  end  






end
