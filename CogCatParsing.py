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
CatList=list('A''B''C''D''E''F''G''H''I''J''K''L''M''N''O''P''Q''R''S''T''U''V''W''X''Z')


tsvfiles=glob.glob('*.tsv')

twowaytabledf=pd.DataFrame()

twowaytabledf.index=tsvfiles


#add Cat letter to dataframe
for letter in CatList:
    twowaytabledf[letter]= np.nan
     
#replace NaN with 0 
twowaytabledf.replace([np.nan, -np.inf], int(0))


for file in tsvfiles:
    #create a temporary dataframe to store matches
    #tempemptydf=pd.DataFrame(tsvfiles)
    
    #read in each tsvfile as a temporary dataframe to easily read
    tempfulldf=pd.read_csv(str(file), sep="\t")
    
    #Get the "Cat" column as a list
    cats_list_temp=list(tempfulldf['Cat'])
        
    cleanedList = [x for x in cats_list_temp if x == x]
    
    #remove the NaN from each dataframe
    #newtemfullpdf=tempfulldf.replace([np.nan, -np.inf], 0)
    
    #store the Cat column to lists
    #tempcatlists=list(newtemfullpdf["Cat"])
    
    #loop through categories
    for letter in CatList:
        #add Cat letter to temporary dataframe
        #tempemptydf[letter]=np.nan
        #remove the NaN and replace as 0
        #tempemptydf.replace([np.nan, -np.inf], 0)
        #Use the findall function to ‘count’ the number of occurances of the letter in the list
        print(letter)
        matches=re.findall(letter, str(cleanedList))
        #Add the number of occurances to the temporary "empty" dataframe
        #tempemptydf[letter]=len(matches)
        print(len(matches))
        
        #add values to 
        twowaytabledf.loc[file,letter]=int(len(matches))

print(twowaytabledf)

twowaytabledf.to_csv("twowaytabledf.tsv",sep="\t")

