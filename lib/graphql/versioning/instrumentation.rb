# Wrapps fields in authorization checks

class SetMetaData
  def initialize(key)
    @key = key
  end

  def call(defn,value)
    defn.metadata[@key] = value
  end
end

module GraphQL
  module Versioning
    class Instrumentation
      GraphQL::Field.accepts_definitions version: SetMetaData.new(:version)

      def initialize(version)
        @version = version
      end

      def instrument(type, field)
        # fieldType = baseTypeOf(field.type)
        # old_resolve_proc = field.resolve_proc
        # new_resolve_proc = lambda do |obj, args, ctx|
        # unless ctx[:ability] == :root
        # raise GraphQL::Authorization::Unauthorized, "not authorized to execute #{fieldType.name}" unless ctx[:ability].canExecute(fieldType, toSymKeys(args.to_h)) || @always_allow_execute
        # raise GraphQL::Authorization::Unauthorized, "not authorized to access #{field.name} on #{type.name}" unless ctx[:ability].canAccess(type, field.name.to_sym, obj, toSymKeys(args.to_h))
        # end
        # old_resolve_proc.call(obj, args, ctx)
        # end

        ## Return a copy of `field`, with a new resolve proc
        # field.redefine do
        # resolve(new_resolve_proc)
        # end
        type.fields.count
        field
      end
    end
  end
end
