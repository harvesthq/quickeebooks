require 'quickeebooks/online/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class SalesTerm < ServiceBase

        def create(sales_term)
          raise InvalidModelException unless sales_term.valid?
          xml = sales_term.to_xml_ns
          response = do_http_post(url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular), valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::SalesTerm.from_xml(response.body)
          else
            nil
          end
        end

        def fetch_by_id(id)
          url = "#{url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular)}/#{id}"
          response = do_http_get(url)
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::SalesTerm.from_xml(response.body)
          else
            nil
          end
        end

        def update(sales_term)
          raise InvalidModelException.new("Missing required parameters for update") unless sales_term.valid_for_update?
          url = "#{url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular)}/#{sales_term.id.value}"
          xml = sales_term.to_xml_ns
          response = do_http_post(url, valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::SalesTerm.from_xml(response.body)
          else
            nil
          end
        end

        def delete(sales_term)
          raise InvalidModelException.new("Missing required parameters for delete") unless sales_term.valid_for_deletion?
          xml = valid_xml_document(sales_term.to_xml_ns(:fields => ['Id', 'SyncToken']))
          url = "#{url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular)}/#{sales_term.id.value}"
          response = do_http_post(url, xml, {:methodx => "delete"})
          response.code.to_i == 200
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Online::Model::SalesTerm, filters, page, per_page, sort, options)
        end

      end
    end
  end
end
