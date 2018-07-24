require 'schema_plus/core'

module SchemaPlus
  module Sequences
  end
end

require_relative 'sequences/version'
require_relative 'sequences/active_record/connection_adapters/abstract_adapter'
require_relative 'sequences/active_record/migration/command_recorder'
require_relative 'sequences/middleware'

module SchemaPlus::Sequences
  module ActiveRecord
    module ConnectionAdapters
      autoload :PostgresqlAdapter, 'schema_plus/sequences/active_record/connection_adapters/postgresql_adapter'
    end
  end
end

SchemaMonkey.register SchemaPlus::Sequences
