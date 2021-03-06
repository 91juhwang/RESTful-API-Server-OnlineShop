require 'spec_helper'
require 'rspec/rails'

describe Api::V1::UsersController do
  
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      get :show, id: @user.id
    end

    it "should return the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it 'should return the http status of 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do

    context "when the user is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end
    
	    it 'should return the http status of 201' do
	      expect(response).to have_http_status(201)
	    end
    end

    context "when the user is not created" do
      before(:each) do
        #notice I'm not including the email
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

	    it 'should return the http status of 422' do
	      expect(response).to have_http_status(422)
	    end
    end

    describe "PUT/PATCH #update" do

	    context "when is successfully updated" do
	      before(:each) do
	        @user = FactoryGirl.create :user
	        patch :update, { id: @user.id,
	                         user: { email: "newmail@example.com" } }
	      end

	      it "renders the json representation for the updated user" do
	        user_response = json_response
	        expect(user_response[:email]).to eql "newmail@example.com"
	      end

		    it 'should return the http status of 200' do
		      expect(response).to have_http_status(200)
		    end
		  end

	    context "when is not created" do
	      before(:each) do
	        @user = FactoryGirl.create :user
	        patch :update, { id: @user.id,
	                         user: { email: "bademail.com" } }
	      end

	      it "renders an errors json" do
	        user_response = json_response
	        expect(user_response).to have_key(:errors)
	      end

	      it "renders the json errors on whye the user could not be created" do
	        user_response = json_response
	        expect(user_response[:errors][:email]).to include "is invalid"
	      end

   	    it 'should return the http status of 422' do
	        expect(response).to have_http_status(422)
	      end
	    end
	  end

	  describe "DELETE #destroy" do
		  before(:each) do
		    @user = FactoryGirl.create :user
		    delete :destroy, { id: @user.id }
		  end

 	    it 'should return the http status of 204' do
        expect(response).to have_http_status(204)
      end
		end
  end
end

