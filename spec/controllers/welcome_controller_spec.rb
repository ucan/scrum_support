require 'spec_helper'

describe WelcomeController do
	it "should have the content 'Welcome!'" do
      visit '/welcome/home'
      page.should have_content('Welcome!')
    end
end
