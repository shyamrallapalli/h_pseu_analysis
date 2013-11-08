GO Annotation of the TGAC Chalara fraxinea protein predictions
==============================================================
#### Date: 2013 November 8
## Introduction

Aim is to analyze the proteins predicted by TGAC for [Chalara fraxinea](https://github.com/ash-dieback-crowdsource/data/blob/master/ash_dieback/chalara_fraxinea/Kenninghall_wood_KW1/annotations/Gene_predictions/TGAC_Chalara_fraxinea_ass_s1v1_ann_v1.1/Chalara_fraxinea_ass_s1v1_ann_v1.1.protein.faa), to add GO annotations.

## Methods

The protein sequences were submitted to the [InterPRO5 webservice](http://www.ebi.ac.uk/Tools/webservices/services/pfa/iprscan5_rest) using the [run_iprscn5_async.rb](https://github.com/shyamrallapalli/h_pseu_analysis/blob/14926f40c9fc6d4039d8c2c7ee62836548f7c044/Interpro5_scan_go_analysis/run_iprscn5_async.rb) script which wraps the EBI provided Perl script [iprscan5_lwp.pl](iprscan5_lwp.pl) downloaded from [EBI iprscan5_rest service](http://www.ebi.ac.uk/Tools/webservices/download_clients/perl/lwp/iprscan5_lwp.pl).

Command to submit jobs

* `ruby run_iprscn5_async.rb Chalara_fraxinea_ass_s1v1_ann_v1.1.protein.faa submit` 

script submits job in a batch of 25 sequences and job submission and Interpro scan was done overnight. 

Next morning the same script was used to get results with following command to retrieve annotations

Batch of jobs were submitted on 5th November and data was retried on 6th November

* `ruby run_iprscn5_async.rb Chalara_fraxinea_ass_s1v1_ann_v1.1.protein.faa get_results` 


Interprocan5 produces 5 types of out files and more details can be found at [OutputFormats](https://code.google.com/p/interproscan/wiki/OutputFormats)
Main differences in service from previous version of Interproscan at [InterProScanVersions](https://code.google.com/p/interproscan/wiki/MigratingInterProScanVersions)

The GO terms predicted were parsed from xml using a dirty ruby method as the files were retrieved, and the GO information was wrritten to the file `results.csv`

Header row for results csv file is `gene,GOterm,GOdescription,GOdomain`

SVG files created by Interproscan5 holds interesting information, therefore SVG files for the proteins with GO terms are saved in the folder "SVG-out"

An example of svg file produced
[SVG-out/CHAFR746836.1.1_0032310.1.svg](SVG-out/CHAFR746836.1.1_0032310.1.svg)
SVG file links for 5961 proteins with domains detected are provided at [ash-dieback-crowdsource](https://github.com/ash-dieback-crowdsource/data/blob/bb7b68bd8a20cbf542a88f9a47340cfd2302cd7f/ash_dieback/chalara_fraxinea/Kenninghall_wood_KW1/annotations/Gene_predictions/TGAC_Chalara_fraxinea_ass_s1v1_ann_v1.1/Interproscan5-go-analysis/Interproscan5-svg-files.txt) github
