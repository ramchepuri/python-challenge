import pandas as pd 
import csv 
import os 
import sys

file_name = input("What's name of the file you want to analyse? ")
boss_csv = os.path.join('raw_data',file_name)
boss_df = pd.read_csv(boss_csv) 
boss_df.head()

boss_df[['First Name','Last Name']] = boss_df['Name'].loc[boss_df['Name'].str.split().str.len() == 2].str.split(expand=True)
boss_df.head()

boss_df.drop('Name', axis=1, inplace=True)
boss_df.head()

boss_df['DOB'] = pd.to_datetime(boss_df['DOB'])
boss_df['DOB1'] = boss_df['DOB'].dt.strftime('%m/%d/%Y')
boss_df.drop('DOB', axis=1, inplace=True)
boss_df = boss_df.rename(columns={"DOB1":"DOB"})
boss_df.head()

us_state_abbrev = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
}

boss_df2 = boss_df.replace({"State": us_state_abbrev})
boss_df2.head()

boss_df3 = boss_df2["SSN"].str.split("-")
boss_df3.head()

i = 0
for row in boss_df3:
    ssn = boss_df3[i]
    ssn[0] = '***'
    ssn[1] = '**'
    new_ssn = ssn
    new_ssn = '-'.join(new_ssn)
    boss_df2.["SSN"][i] = new_ssn
    i = i + 1
boss_df2.head()

boss_df2.head()

final_df = boss_df2[['Emp ID', 'First Name', 'Last Name', 'DOB', 'SSN', 'State']]
final_df.head()

output_file = os.path.join("pyboss_result.csv")
final_df.to_csv(output_file, index=False)