require 'active_support/concern'

module Dams
  module DamsFunction
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.Function
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsFunctionElementList')
      end
      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :functionElement, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, DAMS.Function]) if new?
        super
      end
      delegate :functionElement_attributes=, to: :elementList
      alias_method :functionElement, :elementList
      def functionElement_with_update_name= (attributes)
        self.functionElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :functionElement_without_update_name=, :functionElement_attributes=
      alias_method :functionElement_attributes=, :functionElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'function', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "function_element", elementList.first.elementValue.to_s)
        end
        solr_base solr_doc
      end
    end
    class DamsFunctionElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.functionElement(:in=> DAMS, :to =>"FunctionElement", :class_name => "DamsFunctionElement")
      end
      accepts_nested_attributes_for :functionElement
    end
    class DamsFunctionElement
      include Dams::MadsElement
      rdf_type DAMS.FunctionElement  
    end
  end
end