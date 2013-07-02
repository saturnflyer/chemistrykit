# Encoding: utf-8

module ChemistryKit
  module CLI
    module Helpers
      # this loader returns the formulas found in a path according to these rules:
      # - directories loaded in alpha order
      # - children directories loaded before parents
      # - files loaded in alpha order
      # - lib directories are loaded before any other
      # - rules stack
      class FormulaLoader

        def initialize
          @formulas = []
        end

        def get_formulas(path)
          gather(path)
          @formulas
        end

        private

          def gather(path)
            # get all the directories for path
            directories = get_directories path
            if directories.empty?
              # if there are no directories is empty just get all the files and add it to the instance variable
              @formulas.concat Dir.glob(File.join(path, '*.rb')).sort
            else
              # otherwise for each of them recurse into it
              directories.sort!
              move_lib_to_top_of_stack directories
              directories.each do |directory|
                gather(File.join(path, directory))
              end
              # and then after add the files in the original parent
              @formulas.concat Dir.glob(File.join(path, '*.rb')).sort
            end
          end

          def get_directories(path)
            Dir.entries(path).select do |entry|
              (File.directory? File.join(path, entry)) && !(entry == '.' || entry == '..')
            end
          end

          def move_lib_to_top_of_stack(directories)
            if directories.include? 'lib'
              # if there is a lib directory, put that at the front
              directories.delete('lib')
              directories.unshift('lib')
            end
          end
      end
    end
  end
end
