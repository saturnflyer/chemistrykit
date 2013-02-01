require 'thor/group'

module ChemistryKit
  module CLI
    class New < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(File.dirname(__FILE__), '..', '..')
      end

      def create_project
        directory "templates/chemistrykit", File.join(Dir.getwd, name)
      end

      def notify
        say "Your project name has been added to _config/chemistrykit.yaml"
      end

    end
  end
end
