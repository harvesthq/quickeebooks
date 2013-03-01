require 'quickeebooks/online/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class TimeActivity < ServiceBase

        def create(time_activity)
          raise InvalidModelException unless time_activity.valid?
          xml = time_activity.to_xml_ns
          response = do_http_post(url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular), valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::TimeActivity.from_xml(response.body)
          else
            nil
          end
        end

        def fetch_by_id(id)
          url = "#{url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/#{id}"
          response = do_http_get(url)
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::TimeActivity.from_xml(response.body)
          else
            nil
          end
        end

        def update(time_activity)
          raise InvalidModelException.new("Missing required parameters for update") unless time_activity.valid_for_update?
          url = "#{url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/#{time_activity.id.value}"
          xml = time_activity.to_xml_ns
          response = do_http_post(url, valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::TimeActivity.from_xml(response.body)
          else
            nil
          end
        end

        def delete(time_activity)
          raise InvalidModelException.new("Missing required parameters for delete") unless time_activity.valid_for_deletion?
          xml = valid_xml_document(time_activity.to_xml_ns(:fields => ['Id', 'SyncToken']))
          url = "#{url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/#{time_activity.id.value}"
          response = do_http_post(url, xml, {:methodx => "delete"})
          response.code.to_i == 200
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Online::Model::TimeActivity, filters, page, per_page, sort, options)
        end

      end
    end
  end
end
