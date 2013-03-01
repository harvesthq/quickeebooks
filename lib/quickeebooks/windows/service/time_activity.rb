require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/time_activity'

module Quickeebooks
  module Windows
    module Service
      class TimeActivity < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::TimeActivity, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::TimeActivity::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::TimeActivity, url, {:idDomain => idDomain})
        end

        def create(time_activity)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="time_activity">
          xml_node = time_activity.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'TimeActivity')
          xml = <<-XML
          <Add xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Add>
          XML
          perform_write(Quickeebooks::Windows::Model::TimeActivity, xml)
        end

        def update(time_activity)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="time_activity">

          # Intuit requires that some fields are unset / do not exist.
          time_activity.meta_data = nil
          time_activity.external_key = nil

          # unset Id fields in addresses, phones, email
          if time_activity.addresses
            time_activity.addresses.each {|address| address.id = nil }
          end
          if time_activity.email
            time_activity.email.id = nil
          end

          if time_activity.phones
            time_activity.phones.each {|phone| phone.id = nil }
          end

          if time_activity.web_site
            time_activity.web_site.id = nil
          end

          xml_node = time_activity.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'TimeActivity')
          xml = <<-XML
          <Mod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Mod>
          XML
          perform_write(Quickeebooks::Windows::Model::TimeActivity, xml)
        end

      end
    end
  end
end
