module DatabaseCleaner
  module ActiveRecord
    class Base < DatabaseCleaner::Strategy
      def self.migration_table_name
        if ::ActiveRecord.version >= Gem::Version.new('7.2.0.beta2')
          ::ActiveRecord::Base.connection_pool.schema_migration.table_name
        elsif ::ActiveRecord.version >= Gem::Version.new('6.0.0')
          ::ActiveRecord::Base.connection.schema_migration.table_name
        else
          ::ActiveRecord::SchemaMigration.table_name
        end
      end
    end
  end
end
