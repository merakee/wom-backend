#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: collect feed from BuzzFeed site
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
require 'open-uri'
require 'nokogiri'

# set all local variables
@buzzfeed_url = "http://www.buzzfeed.com/"

# nokogiri methods
def buzzfeed_url
	"http://www.buzzfeed.com/"
end

def get_doc(url)
	begin
		doc = Nokogiri::HTML(open(url)) do
			#return doc 
		end
	rescue OpenURI::HTTPError => e
		puts e.message 
		doc = nil
	end

	return doc
end

def get_titles(doc)
	doc.css("channel item title").map {|node| node.children.text} # title_array 
end

# get feed
def get_buzzfeed(all=true)
	topics =["animals", "celeb", "entertainment", "food", "fwd", "lgbt", "music", "politics", "rewind", "sports", 
		"viral", "lol", "win", "omg", "cute", "geeky", "trashy", "fail","wtf", "australia",  "bestof2012", 
		"books","brasil","breaking", "comics", "community","diy", "espanol",  "france","ideas","longform","tech",  
		"travel","quiz","world"]

	topics=[topics[1]] if !all

	feed =[]
	topics.each{ |topic|
		url = buzzfeed_url + topic + ".xml"
		puts "----------------- Accessing buzzfeed: #{topic} : #{url}--------------"
		doc = get_doc(url)
		if(doc)
			titles = get_titles(doc)
			#puts titles 
			feed += titles
		end
	}
	feed 
end
