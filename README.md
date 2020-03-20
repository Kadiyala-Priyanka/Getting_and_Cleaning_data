Getting And Cleaning Data
======================

## Contents 
This repo contains 3 following files.
* run_analysis.R - R scrip to perform analysis
* CodeBook.md - document that describes the variables, data, and transformations
* tidy_data - Text file showing tidy data

## About run_analysis script
If the data files for this project is not in your working directory, the script will automatically donwnload it to your working directory, then will unzip it.

For creating tidy data, this script uses data.table and reshape2 packages, if they are not installed in your system, the script will automaticaly install.
