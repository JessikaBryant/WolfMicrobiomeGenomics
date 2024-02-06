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
setwd("/Users/jessikagrindstaff/Documents/Documents - Jessika’s MacBook Air/School2324/Research/Enterococcus/AnnotationTables/")

#Read in the tree
tree<-read.tree(file = "/Users/jessikagrindstaff/Documents/Documents - Jessika’s MacBook Air/School2324/Research/Enterococcus/AnnotationTables/RAxML_bipartitions.AllEntero16sWithWae7")

#Look at tree
plot.phylo(tree)
tree$tip.label

#Root the tree
root_tree<-root(tree, outgroup = "Enterococcus_faecium_16346_CP021849", resolve.root = TRUE)
#root_tree$edge.length<-c(1,1,1,1,1,1,1,1,1,1,1,1)
finaltree<-plot.phylo(root_tree)

#Read in table
df<-read.csv(file = "Cog_cat_count_transpose.tsv", sep = "\t", header = TRUE)

#Add row names
row.names(df)<-df$Taxon_ID

#Remove the taxon ID column
df_new<-df[,-1]

#Make plots
rec_tree<-ggtree(root_tree)
p1<-rec_tree + geom_tiplab()

p2<-gheatmap(p1, df_new, offset = 0.05, width = 2.5)+scale_fill_viridis_c(option="G", name="Number of genes\n in COG category", direction = -1)
