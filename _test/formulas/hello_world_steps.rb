step "I go to :url" do |url|
  @driver.get url
end

step "I should see :text in the page title" do |text|
  text.should include("Google")
end
