require 'spec_helper'

# Class to store the path of the StylePeriod
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS StylePeriod path
	# Used for editing specified StylePeriod
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS StylePeriod' do

	scenario 'is on new DAMS StylePeriod page' do
		sign_in_developer

		visit dams_style_period_path('new')
		# Create new StylePeriod
		fill_in "Name", :with => "New StylePeriod"
		fill_in "ExternalAuthority", :with => "http://firstperiod.com"
		fill_in "StylePeriodElement", :with => "Temp"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of StylePeriod for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "New StylePeriod")
		expect(page).to have_selector('a', :text => "http://firstperiod.com")
		expect(page).to have_selector('li', :text => "Temp")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit StylePeriod after Create"
		fill_in "ExternalAuthority", :with => "http://newperiod.com"
		fill_in "StylePeriodElement", :with => "Old"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "Edit StylePeriod after Create")
		expect(page).to have_selector('a', :text => "http://newperiod.com")
		expect(page).to have_selector('li', :text => "Old")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "Edit StylePeriod after Create")
		expect(page).to have_selector('dd', :text => "http://newperiod.com")
		expect(page).to have_selector('dd', :text => "Old")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_content('Edit')

		click_on "Solr View"
	end

	scenario 'is on the StylePeriod page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Test StylePeriod"
		fill_in "ExternalAuthority", :with => "http://styleperiods.com"
		fill_in "StylePeriodElement", :with => "Current"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('strong', :text => "Test StylePeriod")
		expect(page).to have_selector('a', :text => "http://styleperiods.com")
		expect(page).to have_selector('li', :text => "Current")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit StylePeriod page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "StylePeriodElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Test StylePeriod")
	end

end



def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end