require 'spec_helper'

describe "produces/show" do
  before(:each) do
    @produce = assign(:produce, stub_model(Produce,
      :name => "Name",
      :price => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/9.99/)
  end
end
