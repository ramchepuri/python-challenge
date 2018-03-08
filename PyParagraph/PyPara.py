# importing dependencies
import pandas as pd 
import csv 
import re
import os 
import sys

# getting file name from user input
file_name = input("What's name of the file you want to analyse? ")
# reading file from the user input
boss_csv = os.path.join('raw_data',file_name)

# opening the file 
f = open(boss_csv, 'r')
# the file input into a string variable
string = f.read()
#  character count from the string variable value
ltrcount = len(string)
# word count from the string variable value
wcount = len(re.findall("[a-zA-Z_]+", string))
wcount
# Sentence count from the string variable value
sentences = re.split(r'[!?]+|(?<!\.)\.(?!\.)', string.replace('\n',''))
sentences = sentences[:-1]
sentence_count = len(sentences)
## Avg letter per word count 
avg_letter = ltrcount/wcount
## Avg word per sentence count
avg_sen = wcount/sentence_count
# printing the output into a file and terminal..
temp = sys.stdout
sys.stdout = open('Output.txt', 'w')

print("Approximate Word Count: " + str(wcount)) 
print("Approximate Sentence Count:  " + str(sentence_count))
print("Average Letter Count:  " + str(avg_letter)) 
print("Average Sentence Length: : " + str(avg_sen))  

sys.stdout.close()
sys.stdout = temp

print("Approximate Word Count: " + str(wcount)) 
print("Approximate Sentence Count:  " + str(sentence_count))
print("Average Letter Count:  " + str(avg_letter)) 
print("Average Sentence Length: : " + str(avg_sen)) 