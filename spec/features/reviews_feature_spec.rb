require 'rails_helper'

feature 'reviewing' do

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link 'Review The Ox'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  def sign_up_with(email)
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: email)
    fill_in('Password', with: 'testttest')
    fill_in('Password confirmation', with: 'testttest')
    click_button('Sign up')
  end


  before do
    sign_up_with('test@example.com')
  end

  before {Restaurant.create name: 'The Ox'}

  scenario 'allows user to leave a review using a form' do
    leave_review("so so", 3)
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'so so'
  end

  scenario 'user can only leave one review per restaurant' do
    leave_review("so so", 3)
    click_link 'Review The Ox'
    click_button 'Leave Review'
    expect(page).to have_content('You have already reviewed this restaurant')
  end

  scenario 'user can delete a review' do
    leave_review("so so", 3)
    click_link 'Delete Review for The Ox'
    expect(page).not_to have_content('so so')
    expect(page).to have_content('Review deleted successfully')
  end

  scenario 'user can delete only their own reviews' do
    leave_review("so so", 3)
    click_link 'Sign out'
    sign_up_with('emily@example.com')
    expect(page).not_to have_content('Delete Review for The Ox')
  end

  scenario 'displays an average rating for all reviews' do
    leave_review("so so", 3)
    click_link 'Sign out'
    sign_up_with('dom@example.com')
    leave_review("great", 5)
    expect(page).to have_content('Average rating: ★★★★☆')
  end


end
