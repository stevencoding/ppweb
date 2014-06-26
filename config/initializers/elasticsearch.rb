Elasticsearch::Model.client = Elasticsearch::Client.new host: Settings.elasticsearch.host, log: true, logger: Rails.logger
