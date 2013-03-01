require "quickeebooks"
require "quickeebooks/windows/model/id"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/custom_field"

module Quickeebooks
  module Windows
    module Model
      class TimeActivity < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_NODE = "TimeActivity"
        XML_COLLECTION_NODE = 'TimeActivities'
        REST_RESOURCE = "time_activity"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft, :from => 'Draft'
        xml_accessor :object_state, :from => 'ObjectState'

        xml_accessor :txn_date, :from => 'TxnDate', :as => DateTime
        xml_accessor :name_of, :from => 'NameOf'

        xml_accessor :customer_id, :from => 'CustomerId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :job_id, :from => 'JobId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :job_name, :from => 'JobName'
        xml_accessor :item_id, :from => 'ItemId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :item_name, :from => 'ItemName'
        xml_accessor :class_id, :from => 'ClassId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :class_name, :from => 'ClassName'
        xml_accessor :pay_item_id, :from => 'PayItemId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :pay_item_name, :from => 'PayItemName'
        xml_accessor :billable_status, :from => 'BillableStatus'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :hourly_rate, :from => 'HourlyRate'
        xml_accessor :hours, :from => 'Hours', :as => Integer
        xml_accessor :minutes, :from => 'Minutes', :as => Integer
        xml_accessor :seconds, :from => 'Seconds', :as => Integer
        xml_accessor :break_hours, :from => 'BreakHours', :as => Integer
        xml_accessor :break_minutes, :from => 'BreakMinutes', :as => Integer
        xml_accessor :start_time, :from => 'StartTime', :as => DateTime
        xml_accessor :end_time, :from => 'EndTime', :as => DateTime
        xml_accessor :description, :from => 'Description'

        validates :name_of, :presence => true
        validates :customer_id, :presence => true
        validates :item_id, :presence => true

        def to_xml_ns(options = {})
          to_xml_inject_ns('TimeActivity', options)
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

        def self.resource_for_collection
          "#{REST_RESOURCE}s"
        end

      end
    end
  end
end
