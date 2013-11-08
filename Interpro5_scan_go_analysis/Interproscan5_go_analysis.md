GO Annotation of the TGAC Chalara fraxinea protein predictions
==============================================================
#### Date: 2013 November 8
## Introduction

Aim is to analyze the proteins predicted by TGAC for [Chalara](), to add GO annotations.

## Methods

The protein sequences were submitted to the InterPRO5 webservice using the [run_iprscn5_async.rb](run_iprscn5_async.rb) script which wraps the EBI provided Perl script [iprscan5_lwp.pl](iprscan5_lwp.pl).

Command to submit jobs

* `ruby run_iprscn5_async.rb Chalara_fraxinea_ass_s1v1_ann_v1.1.protein.faa submit` 

script submits job in a batch of 25 sequences and job submission and Interpro scan was done overnight. 

Next morning the same script was used to get results with following command to retrieve annotations

* `ruby run_iprscn5_async.rb Chalara_fraxinea_ass_s1v1_ann_v1.1.protein.faa get_results` 


Interprocan5 produces 5 types of out files and more details can be found at [OutputFormats](https://code.google.com/p/interproscan/wiki/OutputFormats)
Main differences in service from previous version of Interproscan at [InterProScanVersions](https://code.google.com/p/interproscan/wiki/MigratingInterProScanVersions)

The GO terms predicted were parsed from xml using a dirty ruby method as the files were retrieved, and the GO information was wrritten to the file `results.csv`

Header row for results csv file is `gene,GOterm,GOdescription,GOdomain`

SVG files created by Interproscan5 holds interesting information, therefore SVG files for the proteins with GO terms are saved in the folder "SVG-out"

An example of svg file produced
[SVG-out/CHAFR746836.1.1_0032310.1.svg](SVG-out/CHAFR746836.1.1_0032310.1.svg)
