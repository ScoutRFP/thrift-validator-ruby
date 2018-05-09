require 'thrift/validator/version'
require 'thrift'

module Thrift
  class Validator
    DEFAULT_TYPE = Thrift::ProtocolException::UNKNOWN

    # @param structs [Object] any Thrift value -- struct, primitive, or a collection thereof
    # @raise [Thrift::ProtocolException] if any deviation from schema was detected
    # @return [nil] if no problems were detected; note that this does not include type checks
    def validate(structs)
      # handle anything -- Struct, Union, List, Set, Map, primitives...
      Array(structs).flatten.each do |struct|
        begin
          # only Structs/Unions can be validated (see Thrift.type_checking for another option)
          next unless struct.is_a?(Struct_Union)
          # raises a ProtocolException if this specific struct is invalid
          struct.validate
          # recursively validate all fields except unset union fields
          struct.struct_fields.each_value do |f|
            next if struct.is_a?(Union) && struct.get_set_field != f[:name].to_sym
            validate(struct.send(f[:name]))
          end
        rescue ProtocolException => e
          raise ProtocolException.new(e.type, "#{struct.class}: #{e.message}")
        rescue => e # union validation raises StandardError...
          raise ProtocolException.new(DEFAULT_TYPE, "#{struct.class}: #{e.message}")
        end
      end
    end
  end
end
