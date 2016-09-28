module MemeCaptainWeb
  # ActiveRecord text match scope lambda generator.
  #
  # Uses Postgres full text search for Postgres and SQL for other databases.
  class TextMatchLambda
    def lambder(o, column)
      if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'.freeze
        postgres_lambda(o)
      else
        other_lambda(o, column)
      end
    end

    private

    def postgres_lambda(o)
      lambda do |query|
        prepared_query = query.try(:strip)
        o.basic_search(prepared_query) if prepared_query
      end
    end

    def other_lambda(o, column)
      lambda do |query|
        prepared_query = query.try(:strip).try(:downcase)
        o.where("LOWER(#{column}) LIKE ?".freeze,
                "%#{prepared_query}%") if prepared_query
      end
    end
  end
end
