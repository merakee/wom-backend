module ApplicationHelper
  
  
  module APIHelper
    def invalid_action_for_anonymous_user?(user)
      return false unless user && user.is_anonymous?
      render :json=> {:success=>false, :message=> "Not a valid action for this user"}, :status =>   :bad_request
      return true 
      end  
  end
  
  
end
