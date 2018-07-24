module SchemaPlus::Sequences
  module ActiveRecord
    module Migration
      module CommandRecorder
        def create_sequence(*args, &block)
          record(:create_sequence, args, &block)
        end

        def drop_sequence(*args, &block)
          record(:drop_sequence, args, &block)
        end

        def invert_create_sequence(args)
          [ :drop_sequence, [args.first] ]
        end

      end
    end
  end
end
