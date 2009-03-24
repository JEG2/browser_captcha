module BrowserCaptcha
  module ParamFields
    def param_fields(current = params, nesting = [ ])
      case current
      when Array
        current.map do |value|
          param_fields(value, nesting + [nil])
        end.join
      when Hash
        current.map do |name, value|
          param_fields(value, nesting + [name])
        end.join
      else
        field_name = ( nesting[0..0] +
                       nesting[1..-1].map { |param| param ? "[#{param}]" : "[]" } ).join
        hidden_field_tag(field_name, current)
      end
    end
  end
end
