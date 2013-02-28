require 'quickeebooks/online/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class Job < ServiceBase
        include ActiveModel::Validations

        def create(job)
          raise InvalidModelException unless job.valid?
          xml = job.to_xml_ns
          response = do_http_post(url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular), valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Job.from_xml(response.body)
          else
            nil
          end
        end

        def fetch_by_id(id)
          url = "#{url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular)}/#{id}"
          response = do_http_get(url)
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::Job.from_xml(response.body)
          else
            nil
          end
        end

        def update(job)
          raise InvalidModelException.new("Missing required parameters for update") unless job.valid_for_update?
          url = "#{url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular)}/#{job.id.value}"
          xml = job.to_xml_ns
          response = do_http_post(url, valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Job.from_xml(response.body)
          else
            nil
          end
        end

        def delete(job)
          raise InvalidModelException.new("Missing required parameters for delete") unless job.valid_for_deletion?
          xml = valid_xml_document(job.to_xml_ns(:fields => ['Id', 'SyncToken']))
          url = "#{url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular)}/#{job.id.value}"
          response = do_http_post(url, xml, {:methodx => "delete"})
          response.code.to_i == 200
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Online::Model::Job, filters, page, per_page, sort, options)
        end

      end
    end
  end
end
