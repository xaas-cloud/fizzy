class Account::Export::Database
  SCHEMA_PATH = Rails.root.join("db", "schema_sqlite.rb")

  attr_reader :database_path, :base_record

  def initialize(database_path)
    @database_path = database_path
    @base_record = nil
    @model_cache = {}
  end

  def create
    load_schema

    db_path = database_path
    @base_record = Class.new(ActiveRecord::Base) do
      self.abstract_class = true
      def self.name = "Account::Export::Database::BaseRecord"

      establish_connection adapter: "sqlite3", database: db_path
    end

    self
  end

  def load_schema
    db_config = ActiveRecord::DatabaseConfigurations::HashConfig.new(
      "export",
      "primary",
      adapter: "sqlite3",
      database: database_path
    )

    # Temporarily switch ActiveRecord::Base's connection to SQLite
    # so that the schema loads into the export database, not the primary
    original_db_config = ActiveRecord::Base.connection_db_config
    ActiveRecord::Base.connection_handler.establish_connection(db_config)

    ActiveRecord::Tasks::DatabaseTasks.load_schema(db_config, :ruby, SCHEMA_PATH)
  ensure
    ActiveRecord::Base.connection_handler.establish_connection(original_db_config)
  end

  def copy_record(record)
    model = model_for(record.class)
    model.create!(record.attributes)
  end

  def copy_records(relation)
    model = model_for(relation)

    relation.find_in_batches(batch_size: 1000) do |batch|
      model.insert_all(batch.map(&:attributes))
    end
  end

  def model_for(table_name_or_model)
    table_name = if table_name_or_model.respond_to?(:table_name)
      table_name_or_model.table_name
    else
      table_name_or_model.to_s
    end

    model_cache[table_name] ||= Class.new(base_record) do
      self.table_name = table_name
    end
  end

  private
    attr_reader :model_cache
end
