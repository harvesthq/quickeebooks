require "quickeebooks"
require "quickeebooks/windows/model/id"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/address"
require "quickeebooks/windows/model/phone"
require "quickeebooks/windows/model/web_site"
require "quickeebooks/windows/model/email"
require "quickeebooks/windows/model/note"
require "quickeebooks/windows/model/custom_field"

module Quickeebooks
  module Windows
    module Model
      class Employee < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_NODE = "Employee"
        XML_COLLECTION_NODE = 'Employees'
        REST_RESOURCE = "employee"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :from => 'ExternalKey', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft, :from => 'Draft'
        xml_accessor :object_state, :from => 'ObjectState'
        xml_accessor :party_reference_id, :from => 'PartyReferenceId'
        xml_accessor :type_of, :from => 'TypeOf'

        xml_accessor :name, :from => 'Name'
        xml_accessor :addresses, :from => 'Address', :as => [Quickeebooks::Windows::Model::Address]
        xml_accessor :phones, :from => 'Phone', :as => Quickeebooks::Windows::Model::Phone
        xml_accessor :web_site, :from => 'WebSite', :as => Quickeebooks::Windows::Model::WebSite
        xml_accessor :email, :from => 'Email', :as => Quickeebooks::Windows::Model::Email
        xml_accessor :title, :from => 'Title'
        xml_accessor :given_name, :from => 'GivenName'
        xml_accessor :middle_name, :from => 'MiddleName'
        xml_accessor :family_name, :from => 'FamilyName'
        xml_accessor :suffix, :from => 'Suffix'
        xml_accessor :gender, :from => 'Gender'
        xml_accessor :birth_date, :from => 'BirthDate', :as => DateTime
        xml_accessor :dba_name, :from => 'DBAName'
        xml_accessor :tax_identifier, :from => 'TaxIdentifier'
        xml_accessor :notes, :from => 'Note', :as => [Quickeebooks::Windows::Model::Note]
        xml_accessor :active, :from => 'Active'
        xml_accessor :show_as, :from => 'ShowAs'
        xml_accessor :employee_type, :from => 'EmployeeType'
        xml_accessor :employee_number, :from => 'EmployeeNumber'
        xml_accessor :billable_time, :from => 'BillableTime'
        xml_accessor :hired_date, :from => 'HiredDate', :as => DateTime
        xml_accessor :released_date, :from => 'ReleasedDate', :as => DateTime
        xml_accessor :use_time_entry, :from => 'UseTimeEntry'

        validates :name, :presence => true

        def valid_for_create?
          valid?
          if type_of.nil?
            errors.add(:type_of, "Missing required attribute TypeOf for Create")
          end
          errors.empty?
        end

        def valid_for_update?
          if sync_token.nil?
            errors.add(:sync_token, "Missing required attribute SyncToken for update")
          end
          errors.empty?
        end

        # To delete an account Intuit requires we provide Id and SyncToken fields
        def valid_for_deletion?
          return false if id.nil? || sync_token.nil?
          id.value.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

        def email_address=(email_address)
          self.email = Quickeebooks::Windows::Model::Email.new(email_address)
        end

        def address=(address)
          self.addresses ||= []
          self.addresses << address
        end

        def name_cannot_contain_invalid_characters
          if name.to_s.index(':')
            errors.add(:name, "Name cannot contain a colon (:)")
          end
        end

        def email_address_is_valid
          if email
            address = email.address
            unless address.index('@') && address.index('.')
              errors.add(:email, "Email address must contain @ and . (dot)")
            end
          end
        end

        def self.resource_for_collection
          "#{REST_RESOURCE}s"
        end

      end
    end
  end
end
