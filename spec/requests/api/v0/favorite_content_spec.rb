require 'rails_helper'

 def able_to_favorite(path,user,params,msg=nil)
  post path, auth_params(user).merge({params:params})
  expect_response_to_have(response,sucess=true,status=:created,msg)
  # check that the attributes are the same.
  expect(json['favorite_content']).to include('id','user_id','content_id')
  expect(json['favorite_content']['id']).not_to be nil
  expect(json['favorite_content']['user_id']).to eq(user.id)
  expect(json['favorite_content']['content_id']).to eq(params['content_id'])
end

def not_able_to_favorite(path,user,params,status=:unauthorized,msg=nil)
    post path, auth_params(user).merge({params:params})
    expect_response_to_have(response,sucess=false,status=status,msg)
end

 def able_to_unfavorite(path,user,params,msg=nil)
  post path, auth_params(user).merge({params:params})
  expect_response_to_have(response,sucess=true,status=:ok,msg)
  # check that the attributes are the same.
  expect(json['message']).to eq("Favorite content deleted")
end

def not_able_to_unfavorite(path,user,params,status=:unauthorized,msg=nil)
    post path, auth_params(user).merge({params:params})
    expect_response_to_have(response,sucess=false,status=status,msg)
end

def able_to_getlist(path,user,params,count=-1,msg=nil)
  post path, auth_params(user).merge({params:params})
  expect_response_to_have(response,sucess=true,status=:ok,msg)
  # check that the attributes are the same.
  expect(json['contents'].count).to eq(count) if count >=0 
end

def not_able_to_getlist(path,user,params,status=:unauthorized,msg=nil)
    post path, auth_params(user).merge({params:params})
    expect_response_to_have(response,sucess=false,status=status,msg)
end

shared_examples "can favorite a content" do
  it 'can post favorite_content' do
     for ind in 1..10 do 
       content = create(:content, user_id: user_content.id)
       favorite_content= build(:favorite_content, content:content,user:user)
       able_to_favorite(pathfav,user,favorite_content.as_json)
      end
   end
     
   it 'cannot post favorite_content without user email' do
      user.email=nil
      not_able_to_unfavorite(pathfav,user,favorite_content.as_json)
    end
     
     it 'cannot post favorite_content without auth token' do
      user.authentication_token=nil
      not_able_to_unfavorite(pathfav,user,favorite_content.as_json)
     end
     
     it 'cannot post favorite_content with empty user email' do
     user.email =""
      not_able_to_favorite(pathfav,user,favorite_content.as_json)
     end
     
     it 'cannot post favorite_content with empty auth token' do
     user.authentication_token =""
      not_able_to_favorite(pathfav,user,favorite_content.as_json)
     end
     
     it 'cannot post favorite_content with nil content_id' do
      favorite_content.content_id = nil
      not_able_to_favorite(pathfav,user,favorite_content.as_json,:unprocessable_entity)
     end
     
     it 'cannot post favorite_content with empty content_id' do
      favorite_content.content_id = ""
      not_able_to_favorite(pathfav,user,favorite_content.as_json,:unprocessable_entity)
     end

     it 'cannot post favorite_content without content_id' do
      favorite_content.content_id = ""
      not_able_to_favorite(pathfav,user,favorite_content.as_json,:unprocessable_entity)
     end
     
     it 'cannot post the favorite_content more than once' do
      able_to_favorite(pathfav,user,favorite_content.as_json)
      not_able_to_favorite(pathfav,user,favorite_content.as_json,:unprocessable_entity)
     end   
end

shared_examples "can unfavorite a content" do
  it 'can post unfavorite_content' do
     for ind in 1..10 do 
       content = create(:content, user_id: user_content.id)
       favorite_content= create(:favorite_content, content:content,user:user)
       able_to_unfavorite(pathunfav,user,favorite_content.as_json)
      end
   end
          
     it 'cannot post unfavorite_content with nil content_id' do
      favorite_content.content_id = nil
      not_able_to_unfavorite(pathunfav,user,favorite_content.as_json,:unprocessable_entity)
     end
     
     it 'cannot post unfavorite_content with empty content_id' do
      favorite_content.content_id = ""
      not_able_to_unfavorite(pathunfav,user,favorite_content.as_json,:unprocessable_entity)
     end

     it 'cannot post unfavorite_content without content_id' do
      favorite_content.content_id = ""
      not_able_to_unfavorite(pathunfav,user,favorite_content.as_json,:unprocessable_entity)
     end
     
     it 'cannot post the unfavorite_content more than once' do
      able_to_unfavorite(pathunfav,user,favorite_content.as_json)
      not_able_to_unfavorite(pathunfav,user,favorite_content.as_json,:unprocessable_entity)
     end   
end

shared_examples "can get favorite content list" do
  it 'can get list with 10 contents' do
    count =10 
     for ind in 1..count do 
       content = create(:content, user_id: user_content.id)
       favorite_content= create(:favorite_content, content:content,user:user_fav)
      end
      able_to_getlist(pathgetlist,user,{user_id: user_fav.id},count)    
   end
   
  it 'can get list with 50 contents' do
    count =50 
     for ind in 1..count do 
       content = create(:content, user_id: user_content.id)
       favorite_content= create(:favorite_content, content:content,user:user_fav)
      end
      able_to_getlist(pathgetlist,user,{user_id: user_fav.id},count)    
   end
   
  it 'can get list with 100 contents' do
    count =100
     for ind in 1..count do 
       content = create(:content, user_id: user_content.id)
       favorite_content= create(:favorite_content, content:content,user:user_fav)
      end
      able_to_getlist(pathgetlist,user,{user_id: user_fav.id},count)    
   end

  it 'can get list with more than contents' do
    count =200
     for ind in 1..count do 
       content = create(:content, user_id: user_content.id)
       favorite_content= create(:favorite_content, content:content,user:user_fav)
      end
      able_to_getlist(pathgetlist,user,{user_id: user_fav.id},100)    
   end

  it 'cannot get list without user id' do
    count =10
     for ind in 1..count do 
       content = create(:content, user_id: user_content.id)
       favorite_content= create(:favorite_content, content:content,user:user_fav)
      end
      not_able_to_getlist(pathgetlist,user,{},:unprocessable_entity)    
   end
   
     it 'can get empty list with wrong user id' do
      able_to_getlist(pathgetlist,user,{user_id: 0},0)     
   end
   
            
end

 describe "API " do
  let(:pathfav) {"/api/v0/favorite_contents/favorite"}
  let(:pathunfav) {"/api/v0/favorite_contents/unfavorite"}
  let(:pathgetlist) {"/api/v0/favorite_contents/getlist"}

  describe "Favorite Content " do
    let(:user){create(:user)}
    let(:user_content){create(:user)}
    let(:content){create(:content, user_id: user_content.id)}
    let(:favorite_content){build(:favorite_content, content:content,user:user)}
    it_behaves_like  "can favorite a content"
  end
  
  describe "UnFavorite Content " do
    let(:user){create(:user)}
    let(:user_content){create(:user)}
    let(:content){create(:content, user_id: user_content.id)}
    let(:favorite_content){create(:favorite_content, content:content,user:user)}
    it_behaves_like  "can unfavorite a content"
  end
  
  describe "Get Favorite Content List " do
    let(:user){create(:user)}
    let(:user_content){create(:user)}
    let(:user_fav){create(:user)}
    it_behaves_like  "can get favorite content list"
  end
  
end

          

