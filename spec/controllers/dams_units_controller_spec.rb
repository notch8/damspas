require 'spec_helper'

describe DamsUnitsController do

  describe "GET 'view'" do
    before do
      sign_in User.create! ({:provider => 'developer'})
      @unit = DamsUnit.create pid: "un48484848", name: "Research Data Curation Program", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/", code: "unrci", group: "dams-rci"
    end
    after do
      @unit.delete
    end

    it "returns http success" do
      get 'show', :id => 'unrci'
      response.should be_success
    end
  end

end
