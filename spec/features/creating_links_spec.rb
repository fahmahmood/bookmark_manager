require 'spec_helper'

feature 'create new links' do
  scenario 'fill in a form that creates a link' do
    visit 'links/new'
    fill_in('title', with: 'Apple')
    fill_in('url', with: 'http://www.apple.com')
    click_button('Create link')
    expect(page).to have_content('Apple')
  end
end
