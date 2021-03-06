require 'spec_helper'

describe DamsSourceCapturesController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
    	#DamsSourceCapture.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsSourceCapture.create(scannerManufacturer: "transmission scanner")
	    end
        after do
          @obj.delete
        end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      expect(response.status).to eq(200)
	      @newobj = assigns[:dams_source_capture]
          expect(@newobj.scannerManufacturer).to eq(@obj.scannerManufacturer)
	    end
	  end
  end
end

