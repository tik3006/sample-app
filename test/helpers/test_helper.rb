ENV['RAILS_ENV'] ||= 'test'


class ActiveSupport:: TestCase
  fixures :all
  include ApplicationHelper
 # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
end