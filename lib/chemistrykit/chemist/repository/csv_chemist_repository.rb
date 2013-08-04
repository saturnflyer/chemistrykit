# Encoding: utf-8

require 'csv'
require 'chemistrykit/chemist'

module ChemistryKit
  # Chemist namespace
  class Chemist
    module Repository
      # Provides the ability to load a chemist by type identifyer from a csv file
      class CsvChemistRepository

        def initialize(csv_path)
          raise ArgumentError, 'Supplied file does not exist!' unless File.exist? csv_path
          @data = CSV.read(csv_path, { headers: true, converters: :all, header_converters: :symbol })
          raise ArgumentError, 'You must define a type field!' unless @data.headers.include? :type
        end

        def load_chemist(type)
          chemist_data = @data.find(-> { raise ArgumentError, "Chemist for type \"#{type}\" not found!" }) do |row|
            row[:type] == type
          end
          chemist = Chemist.new type
          chemist.data = chemist_data.to_hash
          chemist
        end
      end
    end
  end
end
