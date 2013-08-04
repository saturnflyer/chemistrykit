# Encoding: utf-8

module ChemistryKit
  # representation of the user object for interacting with the system under test
  class Chemist

    attr_reader :type, :data

    def initialize(type)
      @type = type
      @data = {}
    end

    def data=(data)
      data.each do |key, value|
        send("#{key}=", value)
      end
    end

    # allow this object to be set with arbitrary key value data
    def method_missing(name, *arguments)
      value = arguments[0]
      name = name.to_s
      if name[-1, 1] == '='
        key = name[/(.+)\s?=/, 1]
        @data[key.to_sym] = value unless instance_variables.include? "@#{key}".to_sym
      else
        @data[name.to_sym]
      end
    end

  end
end
