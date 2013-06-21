require 'spec_helper'

describe "produces/new" do
  before(:each) do
    assign(:produce, stub_model(Produce,
      :name => "MyString",
      :price => "9.99"
    ).as_new_record)
  end

  it "renders new produce form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", produces_path, "post" do
      assert_select "input#produce_name[name=?]", "produce[name]"
      assert_select "input#produce_price[name=?]", "produce[price]"
    end
  end
end
