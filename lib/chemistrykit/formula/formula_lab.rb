# Encoding: utf-8

require 'find'

module ChemistryKit
  module Formula
    # Factory class to assemble page objects with users
    class FormulaLab

      attr_reader :formula

      def initialize(driver, chemist_repository, formulas_dir)
        @driver = driver
        @chemist_repository = chemist_repository
        raise ArgumentError, "Formula directory \"#{formulas_dir}\" does not exist!" unless File.directory?(formulas_dir)
        @formulas_dir = formulas_dir
        @sub_chemists = []
      end

      def using(formula_key)
        @formula = formula_key
        self
      end

      def mix(formula_key = nil)
        @formula = formula_key ||= formula
        compose_chemists unless @sub_chemists.empty?
        raise ArgumentError, 'A formula key must be defined!' unless @formula
        formula_file = find_formula_file
        class_name = get_class_name formula_file
        formula = constantize(class_name).new(@driver)
        if formula.singleton_class.include?(ChemistryKit::Formula::ChemistAware)
          raise RuntimeError, "Trying to mix a formula: \"#{formula_key}\" that requires a user, but no user set!" unless @chemist
          formula.chemist = @chemist
        end
        formula
      end

      def with(key)
        @chemist = @chemist_repository.load_chemist_by_key key
        self
      end

      def with_random(type)
        @chemist = @chemist_repository.load_random_chemist_of_type type
        self
      end

      def with_first(type)
        @chemist = @chemist_repository.load_first_chemist_of_type type
        self
      end

      def and_with(key)
        @sub_chemists << @chemist_repository.load_chemist_by_key(key)
        self
      end

      private

        def compose_chemists
          @sub_chemists.each do |sub_chemist|
            @chemist.with sub_chemist
          end
        end

        def find_formula_file
          Find.find(@formulas_dir) do |path|
            return path if path =~ /.*\/#{@formula}\.rb$/
          end
        end

        # TODO: try to resolve this backreff thing
        # rubocop:disable AvoidPerlBackrefs
        def get_class_name(formula_file)
          string = formula_file.match(/(#{@formulas_dir.split('/').last}.*#{@formula})\.rb$/)[1]
          string = string.sub(/^[a-z\d]*/) { $&.capitalize }
          string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
        end
        # rubocop:enable AvoidPerlBackrefs

        # "borrowed" from http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-constantize
        # TODO: this could be simplified, refactored out, or just use the activestate module some how
        def constantize(camel_cased_word)
          names = camel_cased_word.split('::')
          names.shift if names.empty? || names.first.empty?

          names.reduce(Object) do |constant, name|
            if constant == Object
              constant.const_get(name)
            else
              candidate = constant.const_get(name)
              next candidate if constant.const_defined?(name, false)
              next candidate unless Object.const_defined?(name)

              # Go down the ancestors to check it it's owned
              # directly before we reach Object or the end of ancestors.
              constant = constant.ancestors.reduce do |const, ancestor|
                break const    if ancestor == Object
                break ancestor if ancestor.const_defined?(name, false)
                const
              end

              # owner is in Object, so raise
              constant.const_get(name, false)
            end
          end
        end

    end
  end
end
