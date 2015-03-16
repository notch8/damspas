require 'spec_helper'

describe "keyword field" do
  it "should prefill the search term if the params exist" do
      visit '/advanced?q=fish'
      expect(page).to have_selector("input[value='fish']")
  end
end

describe "facet field" do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "test", group: "dams-curator", uri: "http://example.com/"
    @copy = DamsCopyright.create status: "Public domain"
    @obj = DamsObject.create typeOfResource: 'still image', unitURI: @unit.pid, titleValue: 'Test', copyrightURI: @copy.pid
    solr_index @obj.pid
  end
  after(:all) do
    @obj.delete
    @copy.delete
    @unit.delete
  end
  it "should prefill the facet if the facet params exist" do
      visit '/advanced?f[unit_sim][]=Test+Unit&f[object_type_sim][]=image'
      expect(page).to have_selector("input[id='f_inclusive_object_type_sim_image'][checked='checked']")
      expect(page).to have_selector("input[id='f_inclusive_unit_sim_Test_Unit'][checked='checked']")
  end

  it "should not prefill the facet if the facet params does not exist" do
      visit '/advanced?q=fish'
      expect(page).not_to have_selector("input[checked='checked']")
  end
end

