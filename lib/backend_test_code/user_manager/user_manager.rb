#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-
# Purpose:: create user db: user model based on content index
#
#
#
# Coptyright:: Indriam Inc.
# Created By:: Bijit Halder
# Created on:: 28 April 2010
# Last Modified:: 20 July 2014
# Modification History::
#
#
#

# Database set up
require 'sqlite3'

class UserManager
  # define all params
  # total number of users to be generated
  @@total_users = 1000
  # lower and upper limits of content index for centering
  @@content_index_limits = [1000, 109000]
  # size of the block around center index: half width
  @@block_size = 1000
  # number of responses for each user
  @@response_size_limits =[500, 2000]
  # range or like or hate
  @@alpha_limit = [0.7, 1.0]
  # fraction of likes hate and dont care
  @@response_ratio = [0.6 , 0.3 ,0.1]
  @@num_likes_range =[2, 4]
  @@num_hates_range = [2,4]

  @@db = nil
  @@table_name ="user_model"

  def total_users
    @@total_users
  end

  def rand_pick(llim, ulim)
    rand(ulim-llim+1)+llim
  end

  def email(userid)
    "testuser#{userid}@algotest.com"
  end

  def password
    "password"
  end

  def gen_alpha
    rand_pick(@@alpha_limit[0] * 1000, @@alpha_limit[1] * 1000)/1000.0
  end

  def gen_params
    nlikes= rand_pick(@@num_likes_range[0], @@num_likes_range[1])
    nhates= rand_pick(@@num_hates_range[0], @@num_hates_range[1])
    params = []
    (1..nlikes).each{
      index = rand_pick(@@content_index_limits[0], @@content_index_limits[1])
      alpha = gen_alpha
      param = [index, alpha]
      params << param
    }
    (1..nhates).each{
      index = rand_pick(@@content_index_limits[0], @@content_index_limits[1])
      alpha = -gen_alpha
      param = [index, alpha]
      params << param
    }
    params
  end

  def get_content_id_array(index,total_count)
    ([@@content_index_limits[0]-999,index-@@block_size].max..[@@content_index_limits[1]+1000,index+@@block_size].min).to_a.shuffle[0,total_count-1]
  end

  def get_random_content_id_array(total_count)
    (1..total_count).to_a.map{rand_pick(1,@@content_index_limits[1]+1000)}
  end

  def get_total_responses
    rand_pick( @@response_size_limits[0], @@response_size_limits[1])
  end

  def gen_response(alpha)
    alpha = alpha>0?alpha:1+alpha
    rand(10000)< (alpha*10000)
  end

  def get_response_for_user(content_id,params)
    alpha_values=[]
    params.each{|param|
      alpha_values << param[1] if ([@@content_index_limits[0]-999,param[0]-@@block_size].max..[@@content_index_limits[1]+1000,param[0]+@@block_size].min).include? content_id
    }
    if alpha_values.count == 0
    alpha = 0.5
    else
      alpha = alpha_values.map{|val| val>0?val:1+val}.inject(0.0){|sum,val| sum+val}/alpha_values.count
    end 
    gen_response(alpha)
  end

  # open db file
  def database_file_name
    "TestUserDb_IndexModel.sqlite3"
  end

  def open_db
    @@db || @@db = SQLite3::Database.new(database_file_name)
  end

  def close_db
    @@db.closed? || @@db.close
  end

  def set_up_db
    open_db
    #===============================================
    # create table
    #========================================================
    # create store info table, drop if
    # execute sqlStatement
    @@db.execute("DROP TABLE IF EXISTS #{@@table_name}")
    sqlStatement = <<SQL
CREATE TABLE IF NOT EXISTS user_model (
  user_id INTEGER NOT NULL,
  cindex INTEGER  NOT NULL,
  alpha REAL NOT NULL)
SQL

    # execute sqlStatement
    @@db.execute(sqlStatement)
  end

  #===============================================
  # insert method
  #========================================================
  def insert_inDB(table_name,col_array,val_array)
    # convert col_array to text
    col_text="("
    col_array.each {|v|
      col_text += " '" + "#{v}" + "',"
    }
    col_text.chomp!(",")
    col_text +=") "

    # convert val_array to text
    val_text="("
    val_array.each {|v|
      val_text += " '" + "#{v}" + "',"
    }
    val_text.chomp!(",")
    val_text +=") "

    # insert into Data based
    sqlStatement = "INSERT INTO " + "#{table_name}" + "#{col_text}" + " VALUES " + "#{val_text}"

    #puts sqlStatement

    # execute sqlStatement
    @@db.execute(sqlStatement)
  end

  # save in db
  def add_to_user_table(user_id,index,alpha)
    col_array = ["user_id","cindex","alpha"]
    val_array = [user_id,index,alpha]
    insert_inDB(@@table_name,col_array,val_array)
  end

  def create_user_db
    puts "*** user db already exists***"
    if false
      # open db
      set_up_db
      (1.. @@total_users).each{|userid|
        prams = gen_params
        prams.each{|param|
          add_to_user_table(userid, param[0], param[1])
        }
      }

      # close db
      close_db
    end
  end

  def get_params_for_user(user_id)
    open_db
    sql_statement = "SELECT cindex, alpha FROM #{@@table_name} WHERE user_id = #{user_id}"
    #puts sql_statement
    @@db.execute(sql_statement)
  end

  def get_likes_count(params,total_count)
    (@@response_ratio[0]*total_count/params.select{|param| param[1]>0}.count).round
  end

  def get_hates_count(params,total_count)
    (@@response_ratio[1]*total_count/params.select{|param| param[1]<0}.count).round
  end

  def gen_responses_for_user(user_id)
    params = get_params_for_user(user_id)
    total_responses = get_total_responses
    like_responses = get_likes_count(params,total_responses)
    hate_responses = get_hates_count(params,total_responses)
    responses=[]
    params.each{|param|
      cidarray = get_content_id_array(param[0],param[1]>0?like_responses:hate_responses)
      responses  += cidarray.map{|id| [id, gen_response(param[1])]}
    }
    cidarray = get_random_content_id_array(total_responses-responses.count)
    responses += cidarray.map{|id| [id, gen_response(0.5)]}
  end
end

