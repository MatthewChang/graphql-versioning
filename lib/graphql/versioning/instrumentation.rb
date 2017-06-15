# Wrapps fields in authorization checks

module GraphQL
  module Versioning
    class Instrumentation
      set_versions = ->(defn, versions) {
        versions.each { |key,value| value.name = defn.name }
        defn.metadata[:versions] = versions
        defn.type = GraphQL::STRING_TYPE
        defn.resolve = ->(obj, args, context) {
          raise 'no version available'
        }
      }
      GraphQL::Field.accepts_definitions versions: set_versions

      def initialize(version)
        @version = version
      end

      def instrument(type, field)
        if versions = field.metadata[:versions]
          max_version_number = versions.keys.select { |e| e <= @version }.max
          raise 'cannot find version' unless max_version_number
          versions[max_version_number]
        else
          field
        end
      end
    end
  end
end
