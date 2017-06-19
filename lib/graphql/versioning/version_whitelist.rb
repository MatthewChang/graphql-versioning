# Wrapps fields in authorization checks

module GraphQL
  module Versioning
    class VersionWhitelist
      def initialize(version)
        @version = version
      end

      def call(schema_member, ctx)
        return true unless schema_member.is_a?(GraphQL::Field)
        return true unless versions = schema_member.metadata[:versions]
        versions.keys.any? { |e| e <= @version }
      end
    end
  end
end
