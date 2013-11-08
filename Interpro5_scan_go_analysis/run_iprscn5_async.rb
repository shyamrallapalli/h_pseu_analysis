#!/usr/bin/ruby
# encoding: utf-8
#
#  untitled.rb
#
#  Created by Dan MacLean (TSL) on 2013-09-27.
#  Copyright (c). All rights reserved.
#
require 'pp'
require 'json'
require 'csv'
require 'bio'
require 'barmcakes'
require 'fileutils'

## This method to parse xml is a bit dirty at the moment
def get_go_annotations_from_xml(xmlfile)
  annos = Hash.new {|h,k| h[k] = {} }
  xml_string = File.open(xmlfile[0], "r").read
  xml_string =~ /xref\sname="gene=(.*)"\sid="(.*)"/
  geneid = $2
  File.open(xmlfile[0], "r").each do |xml|
	xml =~ /go-xref\scategory="(.*)"\sname="(.*)"\sid="(.*)"\sdb="GO"/
	category = $1
	name = $2
	id = $3
	if id =~ /^GO:\d+/
	  info = '"' + name + '","' + category + '"'
	  annos[geneid][id] = info
	end
  end
  annos
end

## Get protein name and check if out put has valid GO id information
def get_gene_from_svg(file_name)
  genename = {}
  file_name.each do |svg|
	#puts svg
	svg_string = File.open(svg, "r").read
	#puts svg_string
	svg_string =~ /<title>(.*)?<\/title>/
	genename = $1
	gos = svg_string.scan /xlink:href="http:\/\/www.ebi.ac.uk\/QuickGO\/GTerm\?id=(GO:\d+)"/
	if $1 !~ /\w/
		genename = ""
	end
  end
  genename
end

def read_submitted
  lines = File.open("submitted.log", "r").read
  lines.split("\n")
end

def submit_bundles
  File.open("submitted.log", "w").write("")
  File.open("done.log", "w").write("") # just create a file now to prevent error of not finding it
  File.open("results.csv", "w").write("gene,GOterm,GOdescription,GOdomain\n")
  FileUtils.mkdir("SVG-out")
  Bio::FastaFormat.open(ARGV[0]).each_slice(25).each_with_index do |seqs, batch|
	
	string = seqs.collect {|s| s.to_s}.join("")
	job = `echo '#{string}' | perl ./iprscan5_lwp.pl --email ghanasyam.rallapalli@tsl.ac.uk --async --goterms --multifasta -`
	puts job
	File.open("submitted.log", "a+").write("#{job}\n")
  end
end

def read_done
  lines = File.open("done.log", "r").read
  lines.split("\n")
end

def check_if_done
    submitted = read_submitted
    done = read_done

    submitted.each do |job|
      next unless job =~ /\w/
      next if done.include? job
      if `perl iprscan5_lwp.pl --status --jobid #{job}` =~ /FINISHED/
        get_result_for job
      end
    end 
    
end

def get_result_for job
  FileUtils.mkdir("#{job}")
  FileUtils.cd("#{job}")
  system("perl ../iprscan5_lwp.pl --polljob --jobid #{job}")
  genename = get_gene_from_svg Dir.glob("*.svg")
  if genename =~ /\w/
    FileUtils.mv("#{job}.svg.svg", "../SVG-out/#{genename}.svg")
    annos = get_go_annotations_from_xml Dir.glob("*.xml")
    outfile = File.open("../results.csv", "a+")
    puts genename
#    puts annos
    annos[genename].each {|k,v| 
    outfile.puts "\"#{genename}\",\"#{k}\",#{v}" }
  end
  FileUtils.cd("../")
  FileUtils.rm_rf("#{job}")
  File.open("done.log", "a").write("#{job}\n")
end



if ARGV[1] == 'submit'
  submit_bundles
elsif ARGV[1] == 'get_results'
  check_if_done
end
