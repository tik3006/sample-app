require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:testuserr)
  end 
  
  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
   patch user_path(@user), params: { user: { name:  "",
                                              email: "test@test.jp ",
                                              password:              "testuser1",
                                              password_confirmation: "testuser1" } }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end