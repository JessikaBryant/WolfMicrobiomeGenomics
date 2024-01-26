###load any needed modules
import pandas as pd
import os
import re
import numpy as np
import matplotlib.pyplot as plt
import glob

###set working directory
os.chdir('//Users/jessikagrindstaff/Documents/Documents - Jessika’s MacBook Air/School2324/Research/Enterococcus/AnnotationTables/TableTSVFiles')

###create a list of filenames and a list of COG category letters
#module glob.glob
#give variable and pattern (such as *.tsv) and gives list of path to files
tsvfiles=glob.glob('*.tsv')

CatList=list('A''B''C''D''E''F''G''H''I''J''K''L''M''N''O''P''Q''R''S''T''U''V''W''X''Z')

###create dataframe with filename as first column
#Create COG Category as empty columns (title)
tsvfiles=glob.glob('*.tsv')

twowaytabledf=pd.DataFrame(tsvfiles)

#add Cat letter to dataframe
for letter in CatList:
    twowaytabledf[letter]= np.nan

#replace NaN with 0 
twowaytabledf.replace([np.nan, -np.inf], 0)

###forloop to make one dataframe containing species names, cog category letter 
###(will update to category meaning) and number of counts for each letter

##below is a work in progress not finished
for file in tsvfiles:
    #create a temporary dataframe to store matches
    tempemptydf=pd.DataFrame(tsvfiles)
    #read in each tsvfile as a temporary dataframe to easily read
    tempfulldf=pd.read_csv(str(file), sep="\t")
    #remove the NaN from each dataframe
    newtemfullpdf=tempfulldf.replace([np.nan, -np.inf], 0)
    #store the Cat column to lists
    tempcatlists=list(newtemfullpdf["Cat"])
    #loop through categories
    for letter in CatList:
        #add Cat letter to temporary dataframe
        tempemptydf[letter]=np.nan
        #remove the NaN and replace as 0
        tempemptydf.replace([np.nan, -np.inf], 0)
        #Use the findall function to ‘count’ the number of occurances of the letter in the list
        matches=re.findall(letter, str(tempcatlists))
        #Add the number of occurances to the temporary "empty" dataframe
        tempemptydf[letter]=len(matches)
        print(tempemptydf)
        #twowaytabledf[letter]=tempemptydf


###turn dicts/df back into TSV



