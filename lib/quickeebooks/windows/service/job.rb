require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/job'

module Quickeebooks
  module Windows
    module Service
      class Job < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::Job, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Job::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Job, url, {:idDomain => idDomain})
        end

        def create(job)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="job">
          xml_node = job.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Job')
          xml = <<-XML
          <Add xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Add>
          XML
          perform_write(Quickeebooks::Windows::Model::Job, xml)
        end

        def update(job)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="job">

          # Intuit requires that some fields are unset / do not exist.
          job.meta_data = nil
          job.external_key = nil

          # unset Id fields in addresses, phones, email
          if job.addresses
            job.addresses.each {|address| address.id = nil }
          end
          if job.email
            job.email.id = nil
          end

          if job.phones
            job.phones.each {|phone| phone.id = nil }
          end

          if job.web_site
            job.web_site.id = nil
          end

          xml_node = job.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Job')
          xml = <<-XML
          <Mod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Mod>
          XML
          perform_write(Quickeebooks::Windows::Model::Job, xml)
        end

      end
    end
  end
end
