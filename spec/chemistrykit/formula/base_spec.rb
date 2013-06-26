require 'spec_helper'

describe ChemistryKit::Formula::Base do

  before(:each) do
    #ideally we should mock the driver and not pass in nil
    driver = nil
    @formula_base = ChemistryKit::Formula::Base.new(driver)
  end

  it ''

end
