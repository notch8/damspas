require 'spec_helper'
require 'rack/test'

feature 'Visitor want to look at objects' do

  describe "titles and curator data views" do
    before(:all) do
      @o = DamsObject.create titleValue: 'Test Title',
               subtitle: 'Test Subtitle', titleNonSort: 'The',
               titlePartName: 'Test Part', titlePartNumber: 'Test Number',
               titleTranslationVariant: 'Test Translation Variant',
               copyright_attributes: [{status: 'Public domain'}]
      solr_index @o.pid
    end
    after(:all) do
      @o.delete
    end
    it "should display titles" do
      visit dams_object_path @o
      expect(page).to have_selector('h1',:text=>'The Test Title')
      expect(page).to have_selector('h2',:text=>'Test Subtitle, Test Part Test Number, Test Translation Variant')
    end
    it "should display admin links" do
      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_link('RDF View', rdf_dams_object_path(@o.pid))
      expect(page).to have_link('Data View', data_dams_object_path(@o.pid))
      expect(page).to have_link('DAMS 4.2 Preview', dams42_dams_object_path(@o.pid))
    end
    it "should have a data view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'Data View'
      expect(page).to have_selector('td', :text => "Object")
      expect(page).to have_selector('td', :text => "http://library.ucsd.edu/ark:/20775/#{@o.pid}")
    end
    it "should have an rdf/xml view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'RDF View'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'application/rdf+xml'
    end
    it "should have an rdf/ttl view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'RDF Turtle View'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'text/turtle'
      expect(page).to have_content("@prefix");
    end
    it "should have an rdf/ntriples view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'RDF N-Triples View'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'application/n-triples'
      expect(page).to have_content("\" .");
    end
    it "should have an dams 4.2 view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'DAMS 4.2 Preview'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'application/rdf+xml'
    end
  end

  describe "linked metadata records" do
    before(:all) do
      ns = Rails.configuration.id_namespace
      @acol = DamsAssembledCollection.create( titleValue: 'Test Assembled Collection',
                  visibility: 'public' )
      @pcol = DamsProvenanceCollection.create( titleValue: 'Test Provenance Collection',
                  visibility: 'public' )
      @part = DamsProvenanceCollectionPart.create( titleValue: 'Test Provenance Part Collection',
                  visibility: 'public' )

      @cart = DamsCartographics.create( point: 'Test Point', line: 'Test Line',
              polygon: 'Test Polygon' )
      @unit = DamsUnit.create( name: 'Test Unit', description: 'Test Description', code: 'tu',
              group: 'dams-curator', uri: 'http://example.com/' )

      @note = DamsNote.create( value: 'Test Note' )
      @cust = DamsCustodialResponsibilityNote.create( value: 'Test Custodial Responsibility Note' )
      @cite = DamsPreferredCitationNote.create( value: 'Test Preferred Citation Note' )
      @scope = DamsScopeContentNote.create( value: 'Test Scope Content Note' )

      @built = DamsBuiltWorkPlace.create( name: 'Test Built Work Place' )
      @cult = DamsCulturalContext.create( name: 'Test Cultural Context' )
      @func = DamsFunction.create( name: 'Test Function' )
      @icon = DamsIconography.create( name: 'Test Iconography' )
      @sci = DamsScientificName.create( name: 'Test Scientific Name' )
      @style = DamsStylePeriod.create( name: 'Test Style Period' )
      @tech = DamsTechnique.create( name: 'Test Technique' )
      @complex = MadsComplexSubject.create( name: 'Test Complex Subject' )
      @conf = MadsConferenceName.create( name: 'Test Conference Name' )
      @corp = MadsCorporateName.create( name: 'Test Corporate Name' )
      @family = MadsFamilyName.create( name: 'Test Family Name' )
      @genre = MadsGenreForm.create( name: 'Test Genre Form' )
      @geog = MadsGeographic.create( name: 'Test Geographic' )
      @lang = MadsLanguage.create( name: 'Test Language' )
      @name = MadsName.create( name: 'Test Name' )
      @occu = MadsOccupation.create( name: 'Test Occupation' )
      @pers = MadsPersonalName.create( name: 'Test Personal Name' )
      @temp = MadsTemporal.create( name: 'Test Temporal' )
      @topic = MadsTopic.create( name: 'Test Topic' )

      @copy = DamsCopyright.create( status: 'Public domain' )
      @lic = DamsLicense.create( note: 'Creative Commons Attribution 4.0',
                 uri: 'https://creativecommons.org/licenses/by/4.0/' )
      @other = DamsOtherRight.create( note: 'Test Other Rights' )
      @stat = DamsStatute.create( citation: 'Test Statute' )

      @o = DamsObject.create( titleValue: 'Linked Metadata Test',
           assembledCollectionURI: [ @acol.pid ],
           provenanceCollectionURI: [ @pcol.pid ],
           provenanceCollectionPartURI: [ @part.pid ],
           cartographics_attributes: [{ id: RDF::URI.new("#{ns}#{@cart.pid}") }],
           unit_attributes: [{ id: RDF::URI.new("#{ns}#{@unit.pid}") }],
           note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }],
           custodialResponsibilityNote_attributes: [{ id: RDF::URI.new("#{ns}#{@cust.pid}") }],
           preferredCitationNote_attributes: [{ id: RDF::URI.new("#{ns}#{@cite.pid}") }],
           scopeContentNote_attributes: [{ id: RDF::URI.new("#{ns}#{@scope.pid}") }],
           builtWorkPlace_attributes: [{ id: RDF::URI.new("#{ns}#{@built.pid}") }],
           culturalContext_attributes: [{ id: RDF::URI.new("#{ns}#{@cult.pid}") }],
           function_attributes: [{ id: RDF::URI.new("#{ns}#{@func.pid}") }],
           iconography_attributes: [{ id: RDF::URI.new("#{ns}#{@icon.pid}") }],
           scientificName_attributes: [{ id: RDF::URI.new("#{ns}#{@sci.pid}") }],
           stylePeriod_attributes: [{ id: RDF::URI.new("#{ns}#{@style.pid}") }],
           technique_attributes: [{ id: RDF::URI.new("#{ns}#{@tech.pid}") }],
           complexSubject_attributes: [{ id: RDF::URI.new("#{ns}#{@complex.pid}") }],
           conferenceName_attributes: [{ id: RDF::URI.new("#{ns}#{@conf.pid}") }],
           corporateName_attributes: [{ id: RDF::URI.new("#{ns}#{@corp.pid}") }],
           familyName_attributes: [{ id: RDF::URI.new("#{ns}#{@family.pid}") }],
           genreForm_attributes: [{ id: RDF::URI.new("#{ns}#{@genre.pid}") }],
           geographic_attributes: [{ id: RDF::URI.new("#{ns}#{@geog.pid}") }],
           language_attributes: [{ id: RDF::URI.new("#{ns}#{@lang.pid}") }],
           name_attributes: [{ id: RDF::URI.new("#{ns}#{@name.pid}") }],
           occupation_attributes: [{ id: RDF::URI.new("#{ns}#{@occu.pid}") }],
           personalName_attributes: [{ id: RDF::URI.new("#{ns}#{@pers.pid}") }],
           temporal_attributes: [{ id: RDF::URI.new("#{ns}#{@temp.pid}") }],
           topic_attributes: [{ id: RDF::URI.new("#{ns}#{@topic.pid}") }],
           copyright_attributes: [{ id: RDF::URI.new("#{ns}#{@copy.pid}") }],
           license_attributes: [{ id: RDF::URI.new("#{ns}#{@lic.pid}") }],
           otherRights_attributes: [{ id: RDF::URI.new("#{ns}#{@other.pid}") }],
           statute_attributes: [{ id: RDF::URI.new("#{ns}#{@stat.pid}") }]    )

      solr_index @o.pid
    end
    after(:all) do
      @o.delete
      @acol.delete
      @pcol.delete
      @part.delete
      @cart.delete
      @unit.delete
      @note.delete
      @cust.delete
      @cite.delete
      @scope.delete
      @built.delete
      @cult.delete
      @func.delete
      @icon.delete
      @sci.delete
      @style.delete
      @tech.delete
      @complex.delete
      @conf.delete
      @corp.delete
      @family.delete
      @genre.delete
      @geog.delete
      @lang.delete
      @name.delete
      @occu.delete
      @pers.delete
      @temp.delete
      @topic.delete
      @copy.delete
      @lic.delete
      @other.delete
      @stat.delete
    end
    it "should display linked metadata" do

      visit dams_object_path @o

      expect(page).to have_selector('li', text: 'Test Assembled Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Part Collection')

      expect(page).to have_selector('p', text: 'Test Point')
      expect(page).to have_selector('p', text: 'Test Line')
      expect(page).to have_selector('p', text: 'Test Polygon')
      expect(page).to have_selector('li', text: 'Test Unit')

      expect(page).to have_selector('p', text: 'Test Note')
      expect(page).to have_selector('p', text: 'Test Custodial Responsibility Note')
      expect(page).to have_selector('p', text: 'Test Preferred Citation Note')
      expect(page).to have_selector('p', text: 'Test Scope Content Note')

      expect(page).to have_selector('li', text: 'Test Built Work Place')
      expect(page).to have_selector('li', text: 'Test Cultural Context')
      expect(page).to have_selector('li', text: 'Test Function')
      expect(page).to have_selector('li', text: 'Test Iconography')
      expect(page).to have_selector('li', text: 'Test Scientific Name')
      expect(page).to have_selector('li', text: 'Test Style Period')
      expect(page).to have_selector('li', text: 'Test Technique')
      expect(page).to have_selector('li', text: 'Test Complex Subject')
      expect(page).to have_selector('li', text: 'Test Conference Name')
      expect(page).to have_selector('li', text: 'Test Corporate Name')
      expect(page).to have_selector('li', text: 'Test Family Name')
      expect(page).to have_selector('li', text: 'Test Genre Form')
      expect(page).to have_selector('li', text: 'Test Geographic')
      expect(page).to have_selector('li', text: 'Test Language')
      expect(page).to have_selector('li', text: 'Test Name')
      expect(page).to have_selector('li', text: 'Test Occupation')
      expect(page).to have_selector('li', text: 'Test Personal Name')
      expect(page).to have_selector('li', text: 'Test Temporal')
      expect(page).to have_selector('li', text: 'Test Topic')

      expect(page).to have_selector('p', text: 'Public domain')

    end
    it "should display curator-only linked metadata" do

      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_selector('p', text: 'Creative Commons Attribution 4.0')
      expect(page).to have_selector('p', text: 'Test other rights')
      expect(page).to have_selector('p', text: 'Test Statute')
    end
  end
  describe "internal metadata records" do
    before(:all) do
      @acol = DamsAssembledCollection.create( titleValue: 'Test Assembled Collection',
                  visibility: 'public' )
      @pcol = DamsProvenanceCollection.create( titleValue: 'Test Provenance Collection',
                  visibility: 'public' )
      @part = DamsProvenanceCollectionPart.create( titleValue: 'Test Provenance Part Collection',
                  visibility: 'public' )
      @copy = DamsCopyright.create( status: 'Public domain' )
      @o = DamsObject.create( titleValue: 'Internal Metadata Test',
        assembledCollectionURI: [ @acol.pid ],
        provenanceCollectionURI: [ @pcol.pid ],
        provenanceCollectionPartURI: [ @part.pid ],
        copyrightURI: [ @copy.pid ],
        cartographics_attributes: [{ point: 'Test Point', line: 'Test Line',
            polygon: 'Test Polygon' }],
        unit_attributes: [{ name: 'Test Unit', description: 'Test Description', code: 'tu',
            group: 'dams-curator', uri: 'http://example.com/' }],
        note_attributes: [{ value: 'Test Note' }],
        custodialResponsibilityNote_attributes: [{ value: 'Test Custodial Responsibility Note' }],
        preferredCitationNote_attributes: [{ value: 'Test Preferred Citation Note' }],
        scopeContentNote_attributes: [{ value: 'Test Scope Content Note' }],
        builtWorkPlace_attributes: [{ name: 'Test Built Work Place' }],
        culturalContext_attributes: [{ name: 'Test Cultural Context' }],
        function_attributes: [{ name: 'Test Function' }],
        iconography_attributes: [{ name: 'Test Iconography' }],
        scientificName_attributes: [{ name: 'Test Scientific Name' }],
        stylePeriod_attributes: [{ name: 'Test Style Period' }],
        technique_attributes: [{ name: 'Test Technique' }],
        complexSubject_attributes: [{ name: 'Test Complex Subject' }],
        conferenceName_attributes: [{ name: 'Test Conference Name' }],
        corporateName_attributes: [{ name: 'Test Corporate Name' }],
        familyName_attributes: [{ name: 'Test Family Name' }],
        genreForm_attributes: [{ name: 'Test Genre Form' }],
        geographic_attributes: [{ name: 'Test Geographic' }],
        language_attributes: [{ name: 'Test Language' }],
        name_attributes: [{ name: 'Test Name' }],
        occupation_attributes: [{ name: 'Test Occupation' }],
        personalName_attributes: [{ name: 'Test Personal Name' }],
        temporal_attributes: [{ name: 'Test Temporal' }],
        topic_attributes: [{ name: 'Test Topic' }],
        license_attributes: [{ note: 'Creative Commons Attribution 4.0',
            uri: 'https://creativecommons.org/licenses/by/4.0/' }],
        statute_attributes: [{ citation: 'Test Statute' }]  )

      solr_index @o.pid
    end
    after(:all) do
      @o.delete
      @acol.delete
      @pcol.delete
      @part.delete
      @copy.delete
    end
    it "should display linked metadata" do

      visit dams_object_path @o

      expect(page).to have_selector('li', text: 'Test Assembled Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Part Collection')

      expect(page).to have_selector('p', text: 'Test Point')
      expect(page).to have_selector('p', text: 'Test Line')
      expect(page).to have_selector('p', text: 'Test Polygon')
      expect(page).to have_selector('li', text: 'Test Unit')

      expect(page).to have_selector('p', text: 'Test Note')
      expect(page).to have_selector('p', text: 'Test Custodial Responsibility Note')
      expect(page).to have_selector('p', text: 'Test Preferred Citation Note')
      expect(page).to have_selector('p', text: 'Test Scope Content Note')

      expect(page).to have_selector('li', text: 'Test Built Work Place')
      expect(page).to have_selector('li', text: 'Test Cultural Context')
      expect(page).to have_selector('li', text: 'Test Function')
      expect(page).to have_selector('li', text: 'Test Iconography')
      expect(page).to have_selector('li', text: 'Test Scientific Name')
      expect(page).to have_selector('li', text: 'Test Style Period')
      expect(page).to have_selector('li', text: 'Test Technique')
      expect(page).to have_selector('li', text: 'Test Complex Subject')
      expect(page).to have_selector('li', text: 'Test Conference Name')
      expect(page).to have_selector('li', text: 'Test Corporate Name')
      expect(page).to have_selector('li', text: 'Test Family Name')
      expect(page).to have_selector('li', text: 'Test Genre Form')
      expect(page).to have_selector('li', text: 'Test Geographic')
      expect(page).to have_selector('li', text: 'Test Language')
      expect(page).to have_selector('li', text: 'Test Name')
      expect(page).to have_selector('li', text: 'Test Occupation')
      expect(page).to have_selector('li', text: 'Test Personal Name')
      expect(page).to have_selector('li', text: 'Test Temporal')
      expect(page).to have_selector('li', text: 'Test Topic')

      expect(page).to have_selector('p', text: 'Public domain')

    end
    it "should display curator-only internal metadata" do

      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_selector('p', text: 'Creative Commons Attribution 4.0')
      expect(page).to have_selector('p', text: 'Test Statute')
    end
  end

  describe "viewing non-existing records" do
    it 'should show an error when viewing a non-existing record' do
      visit dams_object_path('xxx')
      expect(page).to have_content 'You are not allowed to view this page.'
    end
    it 'should show an error when viewing a file from a non-existing object' do
      visit file_path('xxx','xxx')
      expect(page).to have_content "The page you were looking for does not exist."
    end
    it 'should show an error when viewing a non-existing file from an existing object' do
      visit file_path('bd0922518w','xxx')
      expect(page).to have_content "The page you were looking for does not exist."
    end
  end

####################################################################################################

  scenario 'view a sample data file' do
    pending "working object metadata updates"
    sign_in_developer
    visit file_path('bd0922518w','_5_5.jpg')
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(response.header["Content-Type"]).to eq( "image/jpeg" )
  end
  
  scenario 'view a sample public html content file' do
    pending "working object metadata updates"
    visit file_path('bb01010101','_2_2.html')
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(response.header["Content-Type"]).to have_content( "text/html" )
    expect(page).to have_link('MP3 Audio File', href: '/ark:/20775/bb07178662/1-2.mp3&name=ghio_sdhsoh.mp3')
  end


end


feature 'Visitor wants to look at pan/zoom image viewer' do

  scenario 'valid pan/zoom image viewer' do
    pending "working object metadata updates"
    visit zoom_path 'bd3379993m', '0'
    expect(page).to have_selector('div#map')
    expect(page).not_to have_selector('header')
  end
  scenario 'invalide pan/zoom image viewer' do
    pending "working object metadata updates"
    visit zoom_path 'bd3379993m', '9'
    expect(page).to have_selector('p', :text => "Error: unable to find zoomable image.")
  end

end

feature 'Visitor wants to click the results link to go back to the search results' do
  
  scenario "is on the main page" do
    pending "working object metadata updates"
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('div.pagination-note', :text => "Results 1 - 8 of 8")
    expect(page).to have_selector('span.dams-filter', :text => "sample")    
    click_link "Sample Image Component"
    
    expect(page).to have_selector('div.search-results-pager', :text => "1 of 8 results Next")

    expect(page).to have_link('results', href:"http://www.example.com/search?q=sample")
    
  end
end

feature 'Visitor wants to click the direct object link when the referrer is not a search' do
  
  scenario "is on the main page" do
    pending "working object metadata updates"
    visit catalog_index_path( {:q => 'sample'} )
    click_link "Sample Image Component"   
    expect(page).to have_selector('div.search-results-pager', :text => "1 of 8 results Next")

    #visit another object view page
    visit dams_object_path(:id => 'bd22194583')
    expect(page).to have_selector('h1', :text => "Sample Simple Object")
    expect(page).not_to have_selector('div.search-results-pager', :text => "1 of 8 results Next")
  end
end

feature 'Visitor wants to click the object link and does not want to see the counter parameter in the url' do
  
  scenario "is on the main page" do
    pending "working object metadata updates"
    visit catalog_index_path( {:q => 'sample'} )
    click_link "Sample Image Component"
    URI.parse(current_url).request_uri.should == "/object/bd3379993m"
  end
end

feature 'Format link(s) need to be scoped to the collection level ' do
  
  scenario "is on the object view page" do
    pending "working object metadata updates"
    visit dams_object_path(:id => 'bd3379993m')
    expect(page).to have_link('image')

    click_link "image"
    expect(page).to have_selector('span.dams-filter a', :text => "UCSD Electronic Theses and Diss…")
    expect(page).to have_selector('span.dams-filter a', :text => "image")
    
  end
end

describe "complex object view" do
  before(:all) do
    @damsComplexObj = DamsObject.create(pid: "xx97626129")
  end
  after(:all) do
    @damsComplexObj.delete
  end
  it "should see the component hierarchy view" do
    pending "working object metadata updates"
    @damsComplexObj.damsMetadata.content = File.new('spec/fixtures/damsComplexObject3.rdf.xml').read
    @damsComplexObj.save!
    solr_index (@damsComplexObj.pid)
    visit dams_object_path(@damsComplexObj.pid)
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-1',:text => 'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-2',:text => 'Files')
    
    #click on grand child link
    click_on 'Image 001'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Image 001')
        
    #return to the top level record
    click_on 'Components of "PPTU04WT-027D (dredge, rock)"'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')         
  end     
end

describe "complex object component view" do
  before(:all) do
    @damsComplexObj4 = DamsObject.create(pid: "xx080808xx")
    @damsComplexObj4.damsMetadata.content = File.new('spec/fixtures/damsComplexObject4.rdf.xml').read
    @damsComplexObj4.save!
    solr_index (@damsComplexObj4.pid)
  end
  after(:all) do
    @damsComplexObj4.delete
    damsUnit = DamsUnit.find('xx080808uu')
    damsUnit.delete
  end
  it "should not see the generic component title" do
    visit dams_object_path(@damsComplexObj4.pid)
    expect(page).not_to have_content "Generic Component Title"
    expect(page).to have_content "Component 1 Title"
    expect(page).to have_content "Component 2 Title"
    expect(page).to have_content "Component 3 Title"
    expect(page).to have_content "Component 4 Title"
  end
end

describe "to look at a simple SIO object" do
  before(:all) do
    @damsSioObj = DamsObject.create(pid: "xx3243380c")
  end
  after(:all) do
    @damsSioObj.delete
  end
  it "should not see the accession number in public view" do
    pending "working object metadata updates"
    @damsSioObj.damsMetadata.content = File.new('spec/fixtures/damsSioObject.rdf.xml').read
    @damsSioObj.save!
    solr_index (@damsSioObj.pid)   
    visit dams_object_path(@damsSioObj.pid)
    expect(page).not_to have_selector('span.dams-note-display-label:first',:text=>'Accession Number')                 
  end
  
   it "should see the accession number in curator view" do
    pending "working object metadata updates"
    @damsSioObj.damsMetadata.content = File.new('spec/fixtures/damsSioObject.rdf.xml').read
    @damsSioObj.save!
    solr_index (@damsSioObj.pid)    
    sign_in_developer       
    visit dams_object_path(@damsSioObj.pid)
    expect(page).to have_selector('span.dams-note-display-label',:text=>'Accession Number')
   end     
end
