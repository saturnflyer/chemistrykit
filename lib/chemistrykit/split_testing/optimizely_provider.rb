# Encoding: utf-8

module ChemistryKit
  module SplitTesting
    class OptimizelyProvider

      attr_reader :config

      def initialize(config)
        @config = config
      end

      def split(driver)
        driver.get config.base_url
        driver.manage.add_cookie(name: 'optimizelyOptOut', value: config.opt_out.to_s)
        driver.navigate.refresh
      end

    end
  end
end
