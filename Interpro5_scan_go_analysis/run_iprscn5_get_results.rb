#!/usr/bin/ruby
# encoding: utf-8
#
#  untitled.rb
#
#  Created by Dan MacLean (TSL) on 2013-09-27.
#  Copyright (c). All rights reserved.
#

require 'rubygems'
require 'nokogiri'
require 'csv'
require 'bio'
require 'barmcakes'
require 'fileutils'
#require 'pp'
#require 'json'


## Get protein name from XML
def get_genename_xml(xml_file)
  geneid1 = ""
  if xml_file[0] =~ /\.xml$/
	@doc = Nokogiri::XML(File.open(xml_file[0]))
	geneid1 = (@doc.xpath("//xmlns:xref"))[0]['id']
  end
  geneid1
end


def get_annotations_xml(xmlfile)
  annos = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] ={} } }
  if xmlfile[0] =~ /\.xml$/
	@doc = Nokogiri::XML(File.open(xmlfile[0]))
	geneid = (@doc.xpath("//xmlns:xref"))[0]['id']
#	puts geneid
	(@doc.xpath("//xmlns:go-xref")).each do |p|
	  info = p['category'] + '","' + (p['name']).gsub(/\"/, "'")
	  ## Descriptions might have ["] characters that would results unexpected comma separation, so replace with [']
	  annos[geneid][p['db']][p['id']] = info
	end

	(@doc.xpath("//xmlns:signature")).each do |p|
	  library = ""
	  p.children.each do |k|
		k.to_s =~ /signature-library-release.*library="(.*)"/
		test = $1
		if test =~ /\w/
			library = test
		end
	  end
	  info = ""
	  next unless p['name'] =~ /\w/
	  if p['desc'] !~ /\w/
		info = (p['name']).gsub(/\"/, "'")
	  else
		info = (p['name']).gsub(/\"/, "'") + '","' + (p['desc']).gsub(/\"/, "'")
	  ## Descriptions might have ["] characters that would results unexpected comma separation, so replace with [']
	  end
#	  puts "#{geneid}"
	  annos[geneid][library][p['ac']] = info
	end
  end
  annos
end

def get_result_for job
  FileUtils.cd("#{job}")
  annos = get_annotations_xml Dir.glob("*.xml")
  genename = get_genename_xml Dir.glob("*.xml")
#  puts "#{genename}"
  outfile = File.open("../results.csv", "a+")

  annos[genename].each {|k,v|
  	annos[genename][k].each {|k2,v2|
#  	puts "\"#{geneid}\",\"#{k}\",\"#{k2}\",\"#{v2}\""
  	outfile.puts "\"#{genename}\",\"#{k}\",\"#{k2}\",\"#{v2}\""  }
  }
  if Dir.glob("*.svg")[0] =~ /\.svg$/
  	  puts "#{job}.svg.svg"
	  FileUtils.cp("#{job}.svg.svg", "../SVG-out/#{genename}.svg")
  end
  FileUtils.cd("../")
end

File.open("get_results.csv", "w").write("\"gene\",\"database\",\"id\",\"domain\",\"description\"\n")

FileUtils.mkdir("SVG-out")

lines = File.read(ARGV[0])
results = lines.split("\n")
results.each do |job|
	puts job
	next unless job =~ /\w/
	get_result_for job
end 
