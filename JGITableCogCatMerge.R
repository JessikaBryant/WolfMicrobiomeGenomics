#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

###R Script to merge Cog Category letters with a genome annotation tsv file

#stringr is used for manipulating the dataframe's
#This is an nested forloop and if-statement that asks whether the package is already installed and installs if not
packages<-c("stringr","tidyr","dplyr","readr")

for (k in 1:length(packages)){
  library(packages[k], character.only=TRUE)
  if (!requireNamespace(packages[k], dependencies=TRUE)){
    install.packages(packages[k],character.only=TRUE)
  }
}

#set working directory
workingdirectory<-args[1]
setwd(workingdirectory)
#"/scratch/bryantj2/wolfmicrobiomes/enterococcus/Figure"

#load in COG Category File
COGCAT<-read.delim(file="Cog_Cat.tsv", sep="\t")
#print(names(COGCAT))

COGDir<-args[2]
#"/scratch/bryantj2/wolfmicrobiomes/enterococcus/Figure/Tables"

#load in genome annotation tsv file
temp <- list.files(path = COGDir, pattern="\\.tsv$")
#print(temp)

###For loop to read in files, manipulate dataframes, and save as new tsv files

#empty place to put the future dataframes
dataframelist<-list() #list of dataframes

#for loop 
#i<-1#remove after testing
for(i in seq_along(temp)){

  dataframelist[[i]] <- read.table(file = paste0(COGDir, temp[[i]]), sep = '\t', header = TRUE, quote="", fill=TRUE) #read in .tsv from temp list and add to list of data frames
  #names(dataframelist[[i]])
  
  #separate COG Column into two columns, Cog and Gene_Product 
  dataframelist[[i]]<-dataframelist[[i]] %>% separate(COG, c("COG", "Gene_Product"), "===")
  #names(dataframelist[[i]])
  # Merge Cog Cat letter with COG ID number
  dataframelist[[i]]<-merge(x=dataframelist[[i]], y=COGCAT, by ='COG', all.x = TRUE)
  #names(dataframelist[[i]])
  #Rearrange columns
  #col_order<-c("COG","Cat","Gene_Product","NCBI_Biosample_Accession","Genome_Name","Genome_ID","Gene_ID","Locus_Tag","Gene_Product_Name","Batch1","Start_Coord","End_Coord","X")
  #dataframelist[[i]]<-dataframelist[[i]][, c("COG","Cat","Gene_Product","NCBI_Biosample_Accession","Genome_Name","Genome_ID","Gene_ID","Locus_Tag","Gene_Product_Name","Batch1","Start_Coord","End_Coord")]

  dataframelist_Clean<-dataframelist[[i]][,-which(names(dataframelist[[i]])=="X")]

  dataframe_Clean<-data.frame(dataframelist_Clean)

# write each to new tsv

  outputpath=args[3]

  write_tsv(dataframelist_Clean, paste0(outputpath, temp[i]))
}

