# Encoding: utf-8

require 'csv'
require 'securerandom'
require 'chemistrykit/chemist'

module ChemistryKit
  # Chemist namespace
  class Chemist
    module Repository
      # Provides the ability to load a chemist by type identifyer from a csv file
      class CsvChemistRepository

        def initialize(csv_path)
          @tables = []
          @chemist_cache = {}
          files = csv_path.kind_of?(String) ? [csv_path] : csv_path

          files.each do |file|
            raise ArgumentError, 'Supplied file does not exist!' unless File.exist? file
            table = CSV.read(file, { headers: true, converters: :all, header_converters: :symbol })
            [:key, :type].each do |header|
              unless table.headers.include?(header) || table.headers.length == 0
                raise ArgumentError, "You must define a #{header.to_s} field!"
              end
            end
            @tables.push table
          end
        end

        # Required Method
        # Load a specific chemist by the unique key
        def load_chemist_by_key(key)
          @tables.each do |table|
            chemist_data = table.find { |row| row[:key] == key }
            chemist = make_chemist(key, chemist_data[:type], chemist_data) if chemist_data
            return fetch_from_cache(chemist) if chemist
          end
          raise ArgumentError, "Chemist for type \"#{key}\" not found!"
        end

        # Required Method
        # Load the first chemist found for a given type
        def load_first_chemist_of_type(type)
          fetch_from_cache(load_chemists_of_type(type)[0])
        end

        # Required Method
        # Loads a chemist at random from all those found with a given type
        def load_random_chemist_of_type(type)
          fetch_from_cache(load_chemists_of_type(type).sample)
        end

        protected

          def load_chemists_of_type(type)
            chemists = []
            @tables.each do |table|
              chemist_data = table.select { |row| row[:type] == type }
              if chemist_data
                chemist_data.each do |data|
                  chemists << make_chemist(data[:key], type, data)
                end
              end
            end
            raise ArgumentError, "Chemist for type \"#{type}\" not found!" if chemists.empty?
            chemists
          end

          def make_chemist(key, type, data)
            chemist = Chemist.new(key, type)
            data_hash = data.to_hash
            data_hash.map { |index, value| value.gsub!(/{{UUID}}/, SecureRandom.uuid) }
            chemist.data = data_hash
            chemist
          end

          def fetch_from_cache(chemist)
            return @chemist_cache[chemist.key.to_sym] if @chemist_cache.include?(chemist.key.to_sym)
            @chemist_cache[chemist.key.to_sym] = chemist
            fetch_from_cache chemist
          end

      end
    end
  end
end
