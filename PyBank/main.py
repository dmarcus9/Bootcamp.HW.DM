import os
import csv

file_path = os.path.join('Resources','budget_data.csv')

total_months = 0
total_net = 0
changes = []
months = []
previous_profit = 0
average_change = 0
greatest_profit_increase = 0
greatest_loss_decrease = 0

with open(file_path) as file:
    data = csv.reader(file,delimiter=',')
    next(data)
    for row in data:
        x = float(row[1]) 
        total_months +=1
        total_net += x
        
        changes.append(x - previous_profit) 
        
        months.append(row[0]) 
        previous_profit = x
    
    greatest_profit_increase = max(changes) 
    greatest_loss_decrease = min(changes)
    
    changes.pop(0) 
    
    average_change = sum(changes) / len(changes)
        
    increase_index = changes.index(greatest_profit_increase)+1
    decrease_index = changes.index(greatest_loss_decrease)+1
    
    average_change = str(round(average_change, 2))
    
    total_net = '{:,}'.format(total_net)
    greatest_profit_increase = '{:,}'.format(greatest_profit_increase)
    greatest_loss_decrease = '{:,}'.format(greatest_loss_decrease)
    
print ("Total Months:", total_months)
print ("Total Net Amount: $", total_net)
print ("Average Change: $", average_change)
print ("Greatest Increase in Profits:", months[increase_index], greatest_profit_increase)
print ("Greatest Decrease in Losses:", months[decrease_index], greatest_loss_decrease)

output = ('Total Months: {}\n Total Net Amount: $ {} \n Average Change: $ {} \n Greatest Increase in Profits: {} \n Greatest Decrease in Losses: {}').format(total_months, total_net, average_change, (months[increase_index], greatest_profit_increase), (months[decrease_index], greatest_loss_decrease))  

#In addition, your final script should both 
#print the analysis to the terminal and 
#export a text file with the results.

# Specify the file to write to
output_path = os.path.join("Resources", "output.txt")

# Open the file using "write" mode. Specify the variable to hold the contents
with open(output_path, 'w', newline='') as txtfile:
    
    txtfile.write(output)
