require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class Id < Quickeebooks::Windows::Model::IntuitType
        
        DOMAIN = "QB"
        
        xml_convention :camelcase
        xml_accessor :idDomain, :from => '@idDomain' # Attribute with name 'idDomain'
        xml_accessor :value, :from => :content
        
        def initialize(value = nil, domain = DOMAIN)
          self.idDomain = domain
          self.value = value
        end
        
        def to_i
          self.value.to_i
        end
        
      end
    end
  end
end
