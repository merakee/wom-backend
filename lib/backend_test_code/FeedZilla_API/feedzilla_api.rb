#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: List of useful functions 
#
#
#
# Coptyright:: Indriam Inc.
# Created By:: Bijit Halder
# Created on:: 28 April 2010
# Last Modified:: 06 February 2012
# Modification History:: 
# 
# 
#

require 'rubygems'
require 'net/http'
require 'mechanize'

# set all local variables
@agent = Mechanize.new
@base_url = "http://api.feedzilla.com/v1"
@quote_count=0

# Create author list methods
#======================================
def create_file(file_name='LocalContentDatabase.txt')
    log_file = File.new(file_name,"w")
    get_category_ids.each{ |id|
        x= get_articles(id)
        x.each{|v| log_file.puts v} if x!=nil
    }
    log_file.close
    return ".......Done"
end

def get_category_list
    url = @base_url+"/categories.json"
    #puts url
    page=get_page(url)
    results = JSON.parse(page.body) if page!=nil    
end

def get_category_ids
    get_category_list.collect{|v| v["category_id"]}
end
def get_category_names
    get_category_list.collect{|v| v["display_category_name"]}.reject!{|v| v.empty?}
end
def get_articles(id)
    url = @base_url+"/categories/#{id}/articles.json"
    #puts url
    page=get_page(url)
    if page!=nil
        results = JSON.parse(page.body)
        results["articles"].collect{|v| v["summary"].strip.gsub("\n"," ")}
    end 
end

#======================================
# write to file
def add_to_file(text)
    if !text.empty?
        @quote_count +=1
        @log_file.puts "#{@quote_count}: #{text}"
        #puts "#{@quote_count}: #{text}"
    end
    
end

def write_header
    @log_file.puts "          List of Quotes"  
    @log_file.puts "#=====================================" 
end

def close_log_file
    @log_file.close    
end

#======================================

# get page for the given url
def get_page(url='http://api.feedzilla.com/v1')
    if !url.empty? 
        #agent = Mechanize.new
        begin
            @agent.get(url)
        rescue
            return nil
        end
        
    end
end

