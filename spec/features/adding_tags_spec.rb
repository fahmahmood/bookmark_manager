feature 'adding tags' do
  scenario 'adds tags to links' do
    visit 'links/new'
    fill_in('title', with: 'Apple')
    fill_in('url', with: 'http://www.apple.com')
   	fill_in 'tags',  with: 'tech'
    click_button 'Create link'
    link = Link.first
    expect(link.tags.map(&:name)).to include('tech')
  end

  scenario 'adds multiple tags to links' do
    visit 'links/new'
    fill_in('title', with: 'Apple')
    fill_in('url', with: 'http://www.apple.com')
   	fill_in 'tags',  with: 'mobile tech'
    click_button 'Create link'
    link = Link.first
    expect(link.tags.map(&:name)).to include('mobile', 'tech')
  end
end
