# frozen_string_literal: true

module SolrSetting
  class SolrServer
    URL_SERVER_SOLR = 'http://localhost:8983/solr/venjob'

    def self.connection
      RSolr.connect url: URL_SERVER_SOLR
    end
  end
end
