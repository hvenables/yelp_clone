require 'rails_helper'

feature 'restaurants' do

  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testttest')
    fill_in('Password confirmation', with: 'testttest')
    click_button('Sign up')
  end

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

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'bz'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'bz'
        expect(page).to have_content 'error'
      end
    end

    context 'when not signed in' do 
      scenario 'does not let you create a restaurant when not signed in' do 
        click_link 'Sign out' 
        click_link 'Add a restaurant'
        expect(current_path).to eq '/users/sign_in'
      end
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
