require 'spec_helper'

describe "MicropostPages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  describe "micropost creation" do
  	before { visit root_path }

  	describe "with invalid information" do

  		it "should not create a micropost" do
  			expect { click_button "Post" }.not_to change(Micropost, :count)
  		end

  		describe "error messages" do
  			before { click_button "Post" }
  			it { should have_content('error') }
  		end
  	end

  	describe "with valid information" do

  		before { fill_in 'micropost_content', with: "Lorem ipsum" }
  		it "should create a micropost" do
  			expect { click_button "Post" }.to change(Micropost, :count).by(1)
  		end
  	end
  end

  describe "micropost destruction" do
    before do
      FactoryGirl.create(:micropost, user: user)
      visit root_path
    end

    it "should delete a micropost" do
      expect { click_link "delete" }.to change(Micropost, :count).by(-1)
    end

    describe "should not see links to delete another user's posts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: other_user)
        visit user_path(other_user)
      end

      it { should_not have_link('delete', href: root_path)}
    end
  end
end
