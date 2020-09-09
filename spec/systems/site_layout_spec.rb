require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do 
  
  describe "home layout" do
     it "contains root link" do
      visit root_path
      expect(page).to have_link "Home", href: root_path
     end
     
      it "contains login link" do
       visit login_path
       expect(page).to have_link 'Login', href: login_path
      end
     
     it "contains about link" do
       visit about_path
       expect(page).to have_link 'About', href: about_path
     end
     
     it "contains contact link" do
        visit contact_path
        expect(page).to have_link "Contact", href: contact_path
     end
     
     it "contains questions link" do
        visit questions_path
        expect(page).to have_link "Questions", href: questions_path
     end
   end
end