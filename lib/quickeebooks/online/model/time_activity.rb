require "quickeebooks"
require "quickeebooks/online/model/id"
require "quickeebooks/online/model/meta_data"

module Quickeebooks
  module Online
    module Model
      class TimeActivity < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        XML_NODE = "TimeActivity"
        XML_COLLECTION_NODE = 'TimeActivitys'
        REST_RESOURCE = "time-activity"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData

        xml_accessor :txn_date, :from => 'TxnDate', :as => DateTime
        xml_accessor :name_of, :from => 'NameOf'

        xml_accessor :employee_id, :from => 'EmployeeId', :in => 'Employee', :as => Quickeebooks::Online::Model::Id
        xml_accessor :employee_name, :from => 'EmployeeName', :in => 'Employee'
        xml_accessor :customer_id, :from => 'CustomerId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :job_id, :from => 'JobId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :job_name, :from => 'JobName'
        xml_accessor :item_id, :from => 'ItemId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :class_id, :from => 'ClassId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :billable_status, :from => 'BillableStatus'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :hourly_rate, :from => 'HourlyRate'
        xml_accessor :hours, :from => 'Hours', :as => Integer
        xml_accessor :minutes, :from => 'Minutes', :as => Integer
        xml_accessor :break_hours, :from => 'BreakHours', :as => Integer
        xml_accessor :break_minutes, :from => 'BreakMinutes', :as => Integer
        xml_accessor :start_time, :from => 'StartTime', :as => DateTime
        xml_accessor :end_time, :from => 'EndTime', :as => DateTime
        xml_accessor :description, :from => 'Description'

        validates_presence_of :name_of, :customer_id, :hourly_rate

        def to_xml_ns(options = {})
          to_xml_inject_ns(XML_NODE, options)
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
          REST_RESOURCE
        end

      end
    end
  end
end
