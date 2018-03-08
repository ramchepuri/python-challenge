
import pandas as pd 
import csv 
import os 
import sys
# Get the file name as input from user
file_name = input("What's name of the file you want to analyse? ")
# Read the file to be analyzed
bank_csv = os.path.join('raw_data',file_name)
bank_df = pd.read_csv(bank_csv) 
bank_df.head()

# Total No of date records as count
total_months = bank_df["Date"].count()
total_months
# Sum of revenue 
total_rev = bank_df["Revenue"].sum()
total_rev

# Rolling change 
bank_df["Avg Monthly"] = bank_df["Revenue"]- bank_df["Revenue"].shift(1) 
bank_df.head()
# Ave rolling change monthly
avg_monthly = bank_df["Avg Monthly"].mean()
avg_monthly

# Max rolling change between two months..
grt_inc = bank_df["Avg Monthly"].max() 
grt_inc
# Min rolling change between two months
grt_dec = bank_df["Avg Monthly"].min() 
grt_dec

# Getting the date corresponding to max change 
max_date = bank_df.loc[bank_df["Avg Monthly"] == grt_inc, "Date"].values[0]
max_date

# Getting the date corresponding to min change 
min_date = bank_df.loc[bank_df["Avg Monthly"] == grt_dec, "Date"].values[0]
min_date
# assinging the sysout to print to sys variable
temp = sys.stdout
# printing sys out to external file
sys.stdout = open('Output.txt', 'w')


print("Total Months : " + str(total_months)) 
print("Total Revenue : " + str(total_rev))
print("Average Monthly Change : " + str(avg_monthly)) 
print("Greatest Increase in Revenue : " + str(max_date) + " (" + str(grt_inc) + ")") 
print("Greatest Decrease in Revenue : " + str(min_date) + " (" + str(grt_dec) + ")") 

#closing the file 
sys.stdout.close()
# assinging sys out to print on terminal 
sys.stdout = temp
# printing out on terminal...
print("Total Months : " + str(total_months)) 
print("Total Revenue : " + str(total_rev))
print("Average Monthly Change : " + str(avg_monthly)) 
print("Greatest Increase in Revenue : " + str(max_date) + " (" + str(grt_inc) + ")") 
print("Greatest Decrease in Revenue : " + str(min_date) + " (" + str(grt_dec) + ")") 

