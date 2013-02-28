require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/employee'

module Quickeebooks
  module Windows
    module Service
      class Employee < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::Employee, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Employee::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Employee, url, {:idDomain => idDomain})
        end

        def create(employee)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="employee">
          xml_node = employee.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Employee')
          xml = <<-XML
          <Add xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Add>
          XML
          perform_write(Quickeebooks::Windows::Model::Employee, xml)
        end

        def update(employee)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="employee">

          # Intuit requires that some fields are unset / do not exist.
          employee.meta_data = nil
          employee.external_key = nil

          # unset Id fields in addresses, phones, email
          if employee.addresses
            employee.addresses.each {|address| address.id = nil }
          end
          if employee.email
            employee.email.id = nil
          end

          if employee.phones
            employee.phones.each {|phone| phone.id = nil }
          end

          if employee.web_site
            employee.web_site.id = nil
          end

          xml_node = employee.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Employee')
          xml = <<-XML
          <Mod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Mod>
          XML
          perform_write(Quickeebooks::Windows::Model::Employee, xml)
        end

      end
    end
  end
end
