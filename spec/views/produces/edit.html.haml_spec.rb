require 'spec_helper'

describe "produces/edit" do
  before(:each) do
    @produce = assign(:produce, stub_model(Produce,
      :name => "MyString",
      :price => "9.99"
    ))
  end

  it "renders the edit produce form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", produce_path(@produce), "post" do
      assert_select "input#produce_name[name=?]", "produce[name]"
      assert_select "input#produce_price[name=?]", "produce[price]"
    end
  end
end
