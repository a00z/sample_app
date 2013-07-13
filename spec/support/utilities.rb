include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_page_title do |title, window_title|
  match do |page|
    if title
      page.should have_selector('h1', text: title)
    end
    window_title ||= title
    if window_title
      page.should have_selector('title', text: window_title)
    end
  end
end
