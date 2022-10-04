module DatabaseCleaner
  module ActiveRecord
    class Base < DatabaseCleaner::Strategy
      def self.migration_table_name
        if Gem::Version.new('6.0.0') <= ::ActiveRecord.version
          ::ActiveRecord::Base.connection.schema_migration.table_name
        else
          ::ActiveRecord::SchemaMigration.table_name
        end
      end
    end
  end
end
