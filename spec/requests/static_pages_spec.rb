require 'spec_helper'

describe "Static pages" do
  subject {page}

  shared_examples_for 'all static pages' do
    it {should have_selector('h1', :text => heading)}
    it {should have_selector('title', :text => full_title(page_title))}
  end

  describe "Home page" do
    before {visit root_path}
    let(:heading) {'Sample App'}
    let(:page_title) {''}

    it_should_behave_like 'all static pages'
    it {should_not have_selector 'title', text: '| Home'}

    describe 'for signed-in users' do
      let(:user) {FactoryGirl.create(:user)}
      before do
        sign_in user
      end

      it 'should render the user\'s feed in various sizes' do
        (0...5).each do |i|
          visit root_path

          page.should have_content("#{i} micropost#{i == 1 ? '' : 's'}")
          user.feed.each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
  
          FactoryGirl.create(:micropost, user: user, content: "#{i}")
        end
      end

      it 'should paginate the user\'s feed' do
        (0...40).each do |i|
          FactoryGirl.create(:micropost, user: user, content: "#{i}")
        end

        visit root_path page: 1

        page.should have_selector("li##{user.feed[0].id}")
        page.should have_selector("li##{user.feed[29].id}")
        page.should_not have_selector("li##{user.feed[30].id}")

        visit root_path page: 2

        page.should_not have_selector("li##{user.feed[29].id}")
        page.should have_selector("li##{user.feed[30].id}")
        page.should have_selector("li##{user.feed[39].id}")
      end
    end
  end

  describe "Help page" do
    before {visit help_path}
    let(:heading) {'Help'}
    let(:page_title) {'Help'}

    it_should_behave_like 'all static pages'
  end

  describe "About page" do
    before {visit about_path}
    let(:heading) {'About Us'}
    let(:page_title) {'About'}

    it_should_behave_like 'all static pages'
  end

  describe "Contact page" do
    before {visit contact_path}
    let(:heading) {'Contact Us'}
    let(:page_title) {'Contact'}

    it_should_behave_like 'all static pages'
  end

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    page.should have_selector 'title', text: full_title('About Us')
    click_link 'Help'
    page.should have_selector 'title', text: full_title('Help')
    click_link 'Contact'
    page.should have_selector 'title', text: full_title('Contact')
    click_link 'Home'
    click_link 'Sign up now!'
    page.should have_selector 'title', text: full_title('Sign up')
    click_link 'sample app'
    page.should have_selector 'title', text: full_title('')
  end
end
