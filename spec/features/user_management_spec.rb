feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do

  	expect {sign_up(password_confirmation: 'wrong')}.not_to change(User,:count)
  end


  scenario 'with a password that does not match' do
  expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
  expect(current_path).to eq('/users') # current_path is a helper provided by Capybara
  expect(page).to have_content 'Password does not match the confirmation'
  end


  scenario 'I cant sign up without an email address' do
    expect {sign_up(email: nil)}.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Email must not be blank")
  end

   scenario 'I cant sign up with an invalid email address' do
    expect {sign_up(email: "invalid@email")}.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Email has an invalid format")
  end

 	 def sign_up(email: 'alice@example.com',
              password: '12345678',
              password_confirmation: '12345678')
    visit '/users/new'
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up
    expect { sign_up }.to_not change(User, :count)
    expect(page).to have_content('Email is already taken')
  end

end
