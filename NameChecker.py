####Make sure that names Tsv and Tree files == same

###load any needed modules
import pandas as pd
import os
from os import sys
import sys
import glob
from Bio import Phylo
#import matplotlib.pyplot as plt

###set working directory
os.chdir('/scratch/bryantj2/wolfmicrobiomes/enterococcus/Figure')

###read in each file
newickfile="/scratch/bryantj2/wolfmicrobiomes/enterococcus/Raxml/RAxML_bipartitions.EnterococcusTree"
Tablepath="/scratch/bryantj2/wolfmicrobiomes/enterococcus/Figure/Parsed_Table_output/EnterococcusTableWithFaecalis.tsv"

#convert table to df
tabledf=pd.read_csv(str(Tablepath), sep="\t")

#finish reading in tree
tree = Phylo.read(newickfile, 'newick')
#root tree
root_taxon = "Wae2aContigs"
tree.root_with_outgroup({'name': root_taxon})

#get tip labels
#print(tree.get_terminals())
speciesnames=list() #make empty list for names to go

#loop through terminals to get names
for n in tree.get_terminals():
    speciesnames.append(n.name)

#print(len(speciesnames))

#create list to put erroneous species IDs
tableerror=list()

#print(speciesnames)
#loop through table to get a list of species names and ask if same as list of names from tree
for row in tabledf.iloc[:,0]: #loop through table using indexing
    if not bool(row in speciesnames):#as if table name and tree ID are NOT the same
        print(row +" ID error") #print error message
        tableerror.append(row) #append error list

print(tableerror)  #print erroneous species IDs
print(speciesnames)

        