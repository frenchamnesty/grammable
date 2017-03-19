require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  
  describe "grams#destroy" do 
    
    it "shouldn't let unauthenticated users delete a gram" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(gram).to redirect_to new_user_session_path
    end 
    
    it "should successfuly delete the gram if the gram is found" do 
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to root_path 
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end
    
    it "should return a 404 message if the gram is not found" do 
      user = FactoryGirl.create(:user)
      sign_in user 
      delete :destroy, params: { id: 'oops'}
      expect(response).to have_http_status(:not_found)
    end 
  end 
  
  describe "grams#update" do 
    
    it "shouldn't let users who didnt create the gram update the gram" do 
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user 
      patch :update, params: { id: gram.id, gram: { message: 'wahoo' }}
      expect(response).to have_http_status(:forbidden)
    end 
    
    it "should only let authenticated users to update a gram" do 
      gram = FactoryGirl.create(:gram)
      patch :update, params: { id: gram.id, gram: {message: 'changed' }}
      expect(response).to redirect_to new_user_session_path
    end 
    
    it "should successfully update the gram if the gram is found" do 
      gram = FactoryGirl.create(:gram, message: "initial value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: 'changed' } }
      expect(response).to redirect_to root_path 
      gram.reload 
      expect(gram.message).to eq "changed"
    end 
    
    it "should return a 404 message if the gram is not found" do 
      user = FactoryGirl.create(:user)
      sign_in user 
      patch :update, params: { id: 'yoloswag', gram: { message: 'changed' } }
      expect(response).to have_http_status(:not_found)
    end 
    
    it "should return an error if the gram is not updated as unprocessable entity" do
      gram = FactoryGirl.create(:gram, message: 'initial value')
      sign_in gram.user 
      patch :update, params: { id: gram.id, gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload 
      expect(gram.message).to eq 'initial value'
    end 
  end 

  describe "grams#edit" do
    
    it "shouldn't let a user who didn't create the gram edit the gram" do 
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end 
    
    it "shouldn't let unauthenticated users edit a gram" do 
      gram = FactoryGirl.create(:gram)
      get :edit, params: {id: gram.id}
      expect(response).to redirect_to new_user_session_path
    end 
    
    it "should successfuly show the edit page if the gram is found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user 
      get :edit, params: {id: gram.id}
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user 
      get :edit, params: { id: 'swag' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#show action" do
    
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index action" do
    
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, params: { gram: { message: "Hello" }}
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram: { message: 'Hello!' }}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq('Hello!')
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: '' }}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq gram_count
    end

  end


end
