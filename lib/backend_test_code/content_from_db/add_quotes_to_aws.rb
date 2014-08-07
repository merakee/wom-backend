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
  puts "\n **Error ***: There is no text file specified. Please specify a file. \n\n"
  Process.exit
end
dbfile_path = ARGV[0]

# check if file exist
if !(File.exist?(dbfile_path))
  puts "\n **Error ***: Specified file " + dbfile_path + " does not exist \n\n"
  Process.exit
end

# set server location
uengine = ApiManager.new(ARGV[2]=="-l", false)
@start_index = ARGV[1].to_i || 1
puts "starting at index #{@start_index}...."
# sign up/sign_in user
uengine.sign_up_user

# open database file
databaseFileName = dbfile_path
@db = SQLite3::Database.new(databaseFileName)
table_name="quote_table"
col_name="quote"
# get total count
max_rowid = @db.get_first_value("SELECT MAX(rowid) FROM " + table_name).to_i

(@start_index..max_rowid).each{|ind|
# get quote and check
  quote = @db.get_first_value("SELECT #{col_name} FROM #{table_name} WHERE rowid = #{ind}")
  uengine.post_content(uengine.create_content(quote)) if quote.length < 300
  #puts quote if quote.length < 300
  puts "processed #{ind} quotes..." if ind%10000==0
}

# close db
@db.closed? || @db.close