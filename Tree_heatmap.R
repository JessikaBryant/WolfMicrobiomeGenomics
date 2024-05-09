#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#Script for making a tree heatmap figure

#The BiocManager package is needed in order to install some other packages
#This is an if-statement that asks whether the package is already installed and installs if not
if (!requireNamespace("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")
}
library("BiocManager")

#Install and load treeio if it isn't already
if (!requireNamespace("treeio", quietly = TRUE)){
  BiocManager::install("treeio")
  
}
library(treeio)

#Install and load ggtree if it isn't already
if (!requireNamespace("treeio", quietly = TRUE)){
  BiocManager::install("ggtree")
}
library(ggtree)

#install and load ggrepel
if (!requireNamespace("treeio", quietly = TRUE)){
  BiocManager::install("ggrepel")
}
library(ggrepel)

###Install and load several packages that are installed with the standard base install function
#Make a list of package names that we'll need
package_list<-c("ape", "ips", "igraph", "Biostrings", "phytools", "seqinr", "dplyr", "ggplot2", "ggnewscale")

#Loop to check if package is installed and loaded. If not, install/load
#If you get a warning saying "there is no package called <XYZ>", run the loop again
for(k in 1:length(package_list)){
  
  if (!require(package_list[k], character.only = TRUE)) {
    install.packages(package_list[k], dependencies = TRUE)
    library(package_list[k], character.only=TRUE)
  }
}

#Set working directory
workingdirectory<-args[1]
setwd(workingdirectory)

#Read in the tree
filepath<-args[2]
tree<-read.tree(file = filepath)

#Look at tree
plot.phylo(tree)
tree$tip.label

#Root the tree
outgroup1<-args[3]
root_tree<-root(tree, outgroup = outgroup1, resolve.root = TRUE)
#root_tree$edge.length<-c(1,1,1,1,1,1,1,1,1,1,1,1)
finaltree<-plot.phylo(root_tree)

#Read in table
file_from_parsing<-args[4]
df<-read.csv(file = file_from_parsing, sep = "\t", header = TRUE)

#Add row names
row.names(df)<-df$Taxon_ID

#Remove the taxon ID column
df_new<-df[,-1]



###Make plots
###write the figure to a pdf
#output argument
outputpath_andname=args[5]
#open pdf to write
pdf(file=outputpath_andname, width = 4, height = 4, )#width and height = in inches

#make tree
rec_tree<-ggtree(root_tree)
#add table
p1<-rec_tree + geom_tiplab()
#edit tree size, color and table color and size
p2<-gheatmap(p1, df_new, offset = 0.05, width = 2.5)+scale_fill_viridis_c(option="G", name="Number of genes\n in COG category", direction = -1)

#Run dev.off() to create the file!
dev.off()#necessary to write a file to pdf in R