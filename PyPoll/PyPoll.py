# importing dependencies
import pandas as pd 
import numpy
import csv 
import os 
import sys

# getting file name from user input and reading into dataframe using pandas
file_name = input("What's name of the file you want to analyse? ")
poll_csv = os.path.join('raw_data',file_name)
poll_df = pd.read_csv(poll_csv) 
poll_df.head()

# getting unique candidates and total votes by candidate into dataframe
results_df = pd.DataFrame({"Candidate" :poll_df["Candidate"].unique() , "Total Votes" : poll_df["Candidate"].value_counts()})
results_df

# appending percent vote value by candidate into dataframe
results_df["Percent Vote"] = round(results_df["Total Votes"]/results_df["Total Votes"].sum() *100,2)
results_df.sort_values("Percent Vote")

# printing output into external file and on to terminal..
temp = sys.stdout
sys.stdout = open('Output_Results.txt', 'w') 

print ("Election Results")
print("---------------------")
print("Total Votes : " + str(results_df["Total Votes"].sum()))
print("---------------------")

i = 0
for row in results_df:
    print( str(results_df["Candidate"][i]) + " :" + str(results_df["Percent Vote"][i]) + "%" + " (" + str(results_df["Total Votes"][i]) + ")")
    i = i+1
print( str(results_df["Candidate"][i]) + " :" + str(results_df["Percent Vote"][i]) + "%" + " (" + str(results_df["Total Votes"][i]) + ")")
print("---------------------")
print ("Winner : " + str(results_df["Candidate"][0]))
print("---------------------")

sys.stdout.close()
sys.stdout = temp
print ("Election Results")
print("---------------------")
print("Total Votes : " + str(results_df["Total Votes"].sum()))
print("---------------------")

i = 0
for row in results_df:
    print( str(results_df["Candidate"][i]) + " :" + str(results_df["Percent Vote"][i]) + "%" + " (" + str(results_df["Total Votes"][i]) + ")")
    i = i+1
print( str(results_df["Candidate"][i]) + " :" + str(results_df["Percent Vote"][i]) + "%" + " (" + str(results_df["Total Votes"][i]) + ")")
print("---------------------")
print ("Winner : " + str(results_df["Candidate"][0]))
print("---------------------")
