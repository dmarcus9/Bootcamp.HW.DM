import os
import csv

file_path = os.path.join('Resources','election_data.csv')

#The total number of votes cast
#A complete list of candidates who received votes
#The percentage of votes each candidate won
#The total number of votes each candidate won

total_votes = 0
Khan_votes = []
Correy_votes = []
Li_votes = []
OTooley_votes = []
Winning_votes = 0
Winner = ""

with open(file_path) as file:
    data = csv.reader(file,delimiter=',')
    next(data)
    for row in data:
        x = str(row[2]) 
        total_votes +=1
        
        if row[2] == "Khan":
            Khan_votes.append("Khan")
        elif row[2] == "Correy":
            Correy_votes.append("Correy")
        elif row[2] == "Li":
            Li_votes.append("Li")   
        elif row[2] == "O'Tooley":
             OTooley_votes.append("O'Tooley") 
    
if len(Khan_votes) > Winning_votes:
    Winning_votes = len(Khan_votes)
    Winner = "Khan"
if len(Correy_votes) > Winning_votes:
    Winning_votes = len(Correy_votes)
    Winner = "Correy"
if len(Li_votes) > Winning_votes:
    Winning_votes = len(Li_votes)
    Winner = "Li"
if len(OTooley_votes) > Winning_votes:
    Winning_votes = len(OTooley_votes)
    Winner = "O'Tooley"   
    
# '{:.2f}'.format shortened the percentages to 2 decimal places
# and I made a variable to hold the values
Khan_percent = '{:.2f}'.format(len(Khan_votes)/total_votes*100)
Correy_percent = '{:.2f}'.format(len(Correy_votes)/total_votes*100)
Li_percent = '{:.2f}'.format(len(Li_votes)/total_votes*100)
OTooley_percent = '{:.2f}'.format(len(OTooley_votes)/total_votes*100)

total_votes = '{:,}'.format(total_votes)

print ("Election Results") 
print ("----------------------") 
print ("Total Votes:", total_votes)
print ("----------------------")  

print ("Khan: " + Khan_percent + "%  " + str(len(Khan_votes)))
print ("Correy: " + Correy_percent + "%  " + str(len(Correy_votes)))
print ("Li: " + Li_percent + "%  " + str(len(Li_votes))) 
print ("O'Tooley: " + OTooley_percent + "%  " + str(len(OTooley_votes)))
print ("----------------------") 
print ("Winner: " + Winner)

with open("Resources/output.txt", "w") as text_file:
    text_file.write("Election Results\n")
    text_file.write("----------------------\n") 
    text_file.write("Total Votes: " + str(total_votes)+ "\n")
    text_file.write("----------------------\n") 
    text_file.write("Khan: " + str(Khan_percent) + "%  " + str(len(Khan_votes))+ "\n") 
    text_file.write("Correy: " + str(Correy_percent) + "%  " + str(len(Correy_votes))+ "\n")
    text_file.write("Li: " + str(Li_percent) + "%  " + str(len(Li_votes))+ "\n") 
    text_file.write("O'Tooley: " + str(OTooley_percent) + "%  " + str(len(OTooley_votes))+ "\n")
    text_file.write("----------------------\n") 
    text_file.write("Winner: " + Winner) 

