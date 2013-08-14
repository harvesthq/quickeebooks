# https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/v2/0400_quickbooks_online/salesterm
require 'quickeebooks'
require 'quickeebooks/online/model/id'
require 'quickeebooks/online/model/meta_data'

module Quickeebooks
  module Online
    module Model
      class SalesTerm < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        XML_NODE = "SalesTerm"
        REST_RESOURCE = "sales-term"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :name, :from => 'Name'
        xml_accessor :due_days, :from => 'DueDays', :as => Integer
        xml_accessor :discount_days, :from => 'DiscountDays', :as => Integer
        xml_accessor :discount_percent, :from => 'DiscountPercent', :as => Float
        xml_accessor :day_of_month_due, :from => 'DayOfMonthDue', :as => Integer
        xml_accessor :due_next_month_days, :from => 'DueNextMonthDays', :as => Integer
        xml_accessor :discount_day_of_month, :from => 'DiscountDayOfMonth', :as => Integer
        xml_accessor :date_discount_percent, :from => 'DateDiscountPercent', :as => Float

        validates_presence_of :name

        def valid_for_update?
          errors.empty?
        end

        def valid_for_deletion?
          return false if id.nil? || sync_token.nil?
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

        def to_xml_ns(options = {})
          to_xml_inject_ns(XML_NODE, options)
        end

        def self.resource_for_collection
          "#{self::REST_RESOURCE}s"
        end

      end
    end
  end
end
