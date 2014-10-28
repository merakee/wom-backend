#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: collect feed from various sources and add to the wom back end content
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
# all sources of content
require '../api_manager.rb'

# Database set up
require 'sqlite3'

#====================================
# get dir name
if(ARGV.length==0)
  puts "\n **Error ***: There is no db file specified. Please specify a file. \n\n"
  Process.exit
end
if (ARGV[0]=="twitter")
	dbfile_path = "/Users/bijit/DesignAndDevelopment/BackEndEngine/WordOfMouth/NLP_Code/twitter/Twitter_feed.sqlite"
	table_name = "tweets"
	col_name = "tweet"
else
	dbfile_path = ARGV[0]
end

if((!defined?(table_name)) && ARGV.length<=1)
  puts "\n **Error ***: There is no table name specified. Please specify a table name. \n\n"
  Process.exit
end
table_name ||= ARGV[1]
if((!defined?(col_name)) && ARGV.length<=2)
  puts "\n **Error ***: There is no col name specified. Please specify a col name. \n\n"
  Process.exit
end
col_name ||= ARGV[2]

# check if file exist
if !(File.exist?(dbfile_path))
  puts "\n **Error ***: Specified file " + dbfile_path + " does not exist \n\n"
  Process.exit
end

# set server location
uengine = ApiManager.new(ARGV.last, false)
@start_index = ARGV[3]? ARGV[3].to_i : 1
puts "starting at index #{@start_index}...."
# sign up/sign_in user
uengine.sign_up_user

# open database file
databaseFileName = dbfile_path
@db = SQLite3::Database.new(databaseFileName)
# get total count
max_rowid = @db.get_first_value("SELECT MAX(rowid) FROM " + table_name).to_i

(@start_index..max_rowid).each{|ind|
# get quote and check
  text = @db.get_first_value("SELECT #{col_name} FROM #{table_name} WHERE rowid = #{ind}")
  #puts "#{ind}: #{text}" 
  uengine.post_content(uengine.create_content(text)) if text.length < 200
  #puts quote if quote.length < 300
  puts "processed #{ind} quotes...[#{Time.now}]" if ind%10000==0
}

# close db
@db.closed? || @db.close