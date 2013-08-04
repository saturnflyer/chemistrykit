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
          @tables = []
          files = csv_path.kind_of?(String) ? [csv_path] : csv_path

          files.each do |file|
            raise ArgumentError, 'Supplied file does not exist!' unless File.exist? file
            table = CSV.read(file, { headers: true, converters: :all, header_converters: :symbol })
            raise ArgumentError, 'You must define a type field!' unless table.headers.include? :type
            @tables.push table
          end
        end

        def load_chemist(type)
          @tables.each do |table|
            chemist_data = table.find do |row|
              row[:type] == type
            end
            if chemist_data
              chemist = Chemist.new(type)
              chemist.data = chemist_data.to_hash
              return chemist
            end
          end
          raise ArgumentError, "Chemist for type \"#{type}\" not found!"
        end
      end
    end
  end
end
