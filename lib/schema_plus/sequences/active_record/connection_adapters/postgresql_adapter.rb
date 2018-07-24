module SchemaPlus::Sequences
  module ActiveRecord
    module ConnectionAdapters
      module PostgresqlAdapter

        def sequences(name = nil) #:nodoc:
          SchemaMonkey::Middleware::Schema::Sequences.start(connection: self, query_name: name, sequences: []) { |env|
            sql = <<-SQL
            SELECT relname
              FROM pg_class
            WHERE relkind = 'S'
            SQL
            env.sequences += env.connection.query(sql, env.query_name).map { |row| row[0] }
          }.sequences
        end

        def sequence_options(sequence_name, name = nil)
          SchemaMonkey::Middleware::Schema::SequenceOptions.start(connection: self, query_name: name) { |env|
            sql = <<-SQL
            SELECT tab.relname, attr.attname
            FROM pg_class
            LEFT JOIN pg_depend
              ON pg_class.relfilenode = pg_depend.objid
            LEFT JOIN pg_class tab
              ON pg_depend.refobjid = tab.relfilenode
            LEFT JOIN pg_attribute attr
              ON attr.attnum = pg_depend.refobjsubid
              AND attr.attrelid = pg_depend.refobjid
            WHERE pg_class.relkind = 'S'
              AND pg_class.relname = '#{sequence_name}'
            SQL
            
            row = env.connection.query(sql, env.query_name)[0]

            env.sequence_options = {}
            env.sequence_options[:owned_by] = "#{row[0]}.#{row[1]}" if row[0]
          }.sequence_options
        end
      end
    end
  end
end
