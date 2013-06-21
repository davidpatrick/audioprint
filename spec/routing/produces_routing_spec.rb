require "spec_helper"

describe ProducesController do
  describe "routing" do

    it "routes to #index" do
      get("/produces").should route_to("produces#index")
    end

    it "routes to #new" do
      get("/produces/new").should route_to("produces#new")
    end

    it "routes to #show" do
      get("/produces/1").should route_to("produces#show", :id => "1")
    end

    it "routes to #edit" do
      get("/produces/1/edit").should route_to("produces#edit", :id => "1")
    end

    it "routes to #create" do
      post("/produces").should route_to("produces#create")
    end

    it "routes to #update" do
      put("/produces/1").should route_to("produces#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/produces/1").should route_to("produces#destroy", :id => "1")
    end

  end
end
