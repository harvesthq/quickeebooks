require "quickeebooks"
require "quickeebooks/online/model/id"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/address"
require "quickeebooks/online/model/phone"
require "quickeebooks/online/model/web_site"
require "quickeebooks/online/model/email"
require "quickeebooks/online/model/note"

module Quickeebooks
  module Online
    module Model
      class Job < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        XML_NODE = "Employee"
        REST_RESOURCE = "employee"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData

        xml_accessor :name, :from => 'Name'
        xml_accessor :addresses, :from => 'Address', :as => [Quickeebooks::Online::Model::Address]
        xml_accessor :phone, :from => 'Phone', :as => Quickeebooks::Online::Model::Phone
        xml_accessor :web_site, :from => 'WebSite', :as => Quickeebooks::Online::Model::WebSite
        xml_accessor :email, :from => 'Email', :as => Quickeebooks::Online::Model::Email
        xml_accessor :given_name, :from => 'GivenName'
        xml_accessor :middle_name, :from => 'MiddleName'
        xml_accessor :family_name, :from => 'FamilyName'
        xml_accessor :suffix, :from => 'Suffix'
        xml_accessor :gender, :from => 'Gender'
        xml_accessor :birth_date, :from => 'BirthDate', :as => DateTime
        xml_accessor :dba_name, :from => 'DBAName'
        xml_accessor :tax_identifier, :from => 'TaxIdentifier'
        xml_accessor :show_as, :from => 'ShowAs'
        xml_accessor :customer_type_id, :from => 'CustomerTypeId'
        xml_accessor :customer_type_name, :from => 'CustomerTypeName'

        xml_accessor :customer_id, :from => 'CustomerId'
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :job_parent_id, :from => 'JobParentId'
        xml_accessor :job_parent_name, :from => 'JobParentName'

        validates :name, :presence => true

        def to_xml_ns(options = {})
          to_xml_inject_ns('Employee', options)
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
          self.email = Quickeebooks::Online::Model::Email.new(email_address)
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
