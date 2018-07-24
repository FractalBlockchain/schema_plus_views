module SchemaPlus::Sequences
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        # Create a sequence given the options.  Specify :force => true
        # to first drop the sequence if it already exists.
        def create_sequence(sequence_name, options={})
          SchemaMonkey::Middleware::Migration::CreateSequence.start(connection: self, sequence_name: sequence_name, sequence_options: options) do |env|
            sequence_name = env.sequence_name
            options = env.sequence_options
            if options[:force]
              drop_sequence(sequence_name, if_exists: true)
            end

            command = if options[:allow_replace]
                        "CREATE OR REPLACE"
                      else
                        "CREATE"
                      end

            sql_options = ""
            sql_options += " OWNED BY #{options[:owned_by]}" if options[:owned_by]
            sql_options += " START WITH #{options[:start_with]}" if options[:start_with]

            execute "#{command} SEQUENCE #{quote_table_name(sequence_name)} #{sql_options}"
          end
        end

        # Drop the named sequence.  Specify :if_exists => true
        # to fail silently if the sequence doesn't exist.
        def drop_sequence(sequence_name, options = {})
          SchemaMonkey::Middleware::Migration::DropSequence.start(connection: self, sequence_name: sequence_name, sequence_options: options) do |env|
            sequence_name = env.sequence_name
            options = env.sequence_options
            sql = "DROP SEQUENCE"
            sql += " IF EXISTS" if options[:if_exists]
            sql += " #{quote_table_name(sequence_name)}"
            execute sql
          end
        end

        #####################################################################
        #
        # The functions below here are abstract; each subclass should
        # define them all. Defining them here only for reference.
        #

        # (abstract) Returns the names of all sequences, as an array of strings
        def sequences(name = nil) raise "Internal Error: Connection adapter didn't override abstract function"; [] end
      end
    end
  end
end
