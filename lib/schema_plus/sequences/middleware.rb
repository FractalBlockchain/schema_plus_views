module SchemaPlus::Sequences
  module Middleware

    module Dumper
      module Tables

        # Dump sequences
        def after(env)
          env.connection.sequences.each do |sequence_name|
            next if env.dumper.ignored?(sequence_name)
            options = env.connection.sequence_options(sequence_name)
            sequence = Sequence.new(name: sequence_name, options: options)
            env.dump.tables[sequence.name] = sequence
          end
        end

        # quacks like a SchemaMonkey Dump::Table
        class Sequence < KeyStruct[:name, :options]
          def assemble(stream)
            stream.puts <<-ENDSEQUENCE
  create_sequence "#{name}", #{options}
            ENDSEQUENCE
          end
        end
      end
    end

    #
    # Define new middleware stacks patterned on SchemaPlus::Core's naming
    # for tables

    module Schema
      module Sequences
        ENV = [:connection, :query_name, :sequences]
      end

      module SequenceOptions
        ENV = [:connection, :query_name, :sequence_options]
      end
    end

    module Migration
      module CreateSequence
        ENV = [:connection, :sequence_name, :sequence_options]
      end
      module DropSequence
        ENV = [:connection, :sequence_name, :sequence_options]
      end
    end
  end

end
