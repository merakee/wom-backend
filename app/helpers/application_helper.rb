module ApplicationHelper

  module APIHelper
    def invalid_action_for_anonymous_user?(user)
      return false unless user && user.is_anonymous?
      render :json=> {:success=>false, :message=> "Not a valid action for this user"}, :status =>   :bad_request
      return true
    end

    # def select_keys_for_content
    # [:id, :user_id, :content_category_id, :text, :photo_token, :total_spread, :spread_count, :kill_count, :comment_count, :new_comment_count, :created_at, :updated_at]
    # end
    #
    # def select_keys_for_comment
    # [:id, :user_id, :content_id, :text, :like_count, :new_like_count, :created_at, :updated_at]
    # end

    def convert_params_to_int(params,keys)
      keys.each{|key|
        params[key]=params[key].to_i if params[key].is_a?String
      }
    end

  end

end
