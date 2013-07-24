require 'spec_helper'

# Helper class to store the path of the family name
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS Family Name path
	# Used for editing specified family name
	@path = nil
end


feature 'Visitor wants to create/edit a MADS Family Name' do 

	scenario 'is on new MADS Family Name page' do
		sign_in_developer

		visit mads_family_name_path('new')

		# Create new family name
		fill_in "Name", :with => "Mister Doe"
		fill_in "ExternalAuthority", :with => "http://misterdoe.com"
		fill_in "FullNameElement", :with => "John Doe1"
		fill_in "FamilyNameElement", :with => "Doe2"
		fill_in "GivenNameElement", :with => "Johnson"
		fill_in "DateNameElement", :with => "1920"
		fill_in "TermOfAddressElement", :with => "First1"
		page.select("Test Scheme", match: :first)
		click_on "Submit"
		Path.path = current_path

		expect(page).to have_selector('strong', :text => "Mister Doe")
		expect(page).to have_selector('li', :text => "John Doe1")
		expect(page).to have_selector('li', :text => "Doe2")
		expect(page).to have_selector('li', :text => "Johnson")
		expect(page).to have_selector('li', :text => "1920")
		expect(page).to have_selector('li', :text => "First1")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://misterdoe.com")

		click_on "Edit"
		fill_in "Authoritative Label", :with => "Miss Does"
		fill_in "ExternalAuthority", :with => "http://missdoes.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "FullNameElement", :with => "Jane Does"
		fill_in "FamilyNameElement", :with => "Does1"
		fill_in "GivenNameElement", :with => "Jane1"
		fill_in "DateNameElement", :with => "1970"
		fill_in "TermOfAddressElement", :with => "Last1"
		click_on "Save changes"

		expect(page).to have_selector('strong', :text => "Miss Does")
		expect(page).to have_selector('li', :text => "Jane Does")
		expect(page).to have_selector('li', :text => "Does1")
		expect(page).to have_selector('li', :text => "Jane1")
		expect(page).to have_selector('li', :text => "1970")
		expect(page).to have_selector('li', :text => "Last1")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://missdoes.com")

	end

	scenario 'is on Edit Family Name page' do
		sign_in_developer
		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Newer Name"
		fill_in "ExternalAuthority", :with => "http://familyname.com"
		page.select("Test Scheme", match: :first)
		fill_in "FullNameElement", :with => "New Family Name"
		fill_in "FamilyNameElement", :with => "Name"
		fill_in "GivenNameElement", :with => "Family1"
		fill_in "DateNameElement", :with => "1990"
		fill_in "TermOfAddressElement", :with => "Median1"
		click_on "Save changes"

		expect(page).to have_selector('strong', :text => "Newer Name")
		expect(page).to have_selector('li', :text => "New Family Name")
		expect(page).to have_selector('li', :text => "Name")
		expect(page).to have_selector('li', :text => "Family1")
		expect(page).to have_selector('li', :text => "1990")
		expect(page).to have_selector('li', :text => "Median1")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://familyname.com")

	end
	
end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Family Name page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Cancel"
		fill_in "ExternalAuthority", :with => "http://cancel.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "FullNameElement", :with => "Can Cel"
		fill_in "FamilyNameElement", :with => "Cel"
		fill_in "GivenNameElement", :with => "Can"
		fill_in "DateNameElement", :with => "1999"
		fill_in "TermOfAddressElement", :with => "Not here"
		click_on "Cancel"
		expect(page).to_not have_content("Can Cel")
		expect(page).to have_content("Newer Name")
	end

end

feature 'Visitor wants to use Hydra View' do
	
	scenario 'is on Family Name view page' do
		sign_in_developer
		visit Path.path
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "Newer Name")
		expect(page).to have_selector('dd', :text => "New Family Name")
		expect(page).to have_selector('dd', :text => "Name")
		expect(page).to have_selector('dd', :text => "Family1")
		expect(page).to have_selector('dd', :text => "1990")
		expect(page).to have_selector('dd', :text => "Median1")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('dd', :text => "http://familyname.com")

		#Check edit in hydra view
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Miss Does"
		fill_in "ExternalAuthority", :with => "http://missdoes.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "FullNameElement", :with => "Jane Does"
		fill_in "FamilyNameElement", :with => "Does1"
		fill_in "GivenNameElement", :with => "Jane1"
		fill_in "DateNameElement", :with => "1970"
		fill_in "TermOfAddressElement", :with => "Last1"
		click_on "Save changes"

		expect(page).to have_selector('strong', :text => "Miss Does")
		expect(page).to have_selector('li', :text => "Jane Does")
		expect(page).to have_selector('li', :text => "Does1")
		expect(page).to have_selector('li', :text => "Jane1")
		expect(page).to have_selector('li', :text => "1970")
		expect(page).to have_selector('li', :text => "Last1")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://missdoes.com")
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end