
## Game Analysis:
    
Gaming Players are mostly Male
Gaming productions/items are bought mostly by Male
People over 20 are looking more engaged into Gaming or buying gaming products.




```python
import pandas as pd
import numpy as np
import os
```

# Importing data 
Reading data from JSON file into Dataframe



```python
path = os.path.join('..', 'HeroesOfPymoli', 'purchase_data.json')
json_data = pd.read_json(path)
json_data.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>Gender</th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Price</th>
      <th>SN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>38</td>
      <td>Male</td>
      <td>165</td>
      <td>Bone Crushing Silver Skewer</td>
      <td>3.37</td>
      <td>Aelalis34</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>Male</td>
      <td>119</td>
      <td>Stormbringer, Dark Blade of Ending Misery</td>
      <td>2.32</td>
      <td>Eolo46</td>
    </tr>
    <tr>
      <th>2</th>
      <td>34</td>
      <td>Male</td>
      <td>174</td>
      <td>Primitive Blade</td>
      <td>2.46</td>
      <td>Assastnya25</td>
    </tr>
    <tr>
      <th>3</th>
      <td>21</td>
      <td>Male</td>
      <td>92</td>
      <td>Final Critic</td>
      <td>1.36</td>
      <td>Pheusrical25</td>
    </tr>
    <tr>
      <th>4</th>
      <td>23</td>
      <td>Male</td>
      <td>63</td>
      <td>Stormfury Mace</td>
      <td>1.27</td>
      <td>Aela59</td>
    </tr>
  </tbody>
</table>
</div>



# Player Count
• Total Number of Players



```python
# Total Players 
TotalPlayers = pd.DataFrame({"Total Players": [json_data["SN"].nunique()]})
TotalPlayers
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>573</td>
    </tr>
  </tbody>
</table>
</div>



# Purchasing Analysis (Total)
•	Number of Unique Items
•	Average Purchase Price
•	Total Number of Purchases
•	Total Revenue


```python
# Purchase Analysis 
Purchase_Analysis = pd.DataFrame({"Number of Unique Items": [json_data["Item ID"].nunique()],
                                   "Average Price": [json_data["Price"].mean()],
                                   "Number of Purchases": [json_data["Item ID"].count()],
                                   "Total Revenue": [json_data["Price"].sum()]
})
Purchase_Analysis = Purchase_Analysis[["Number of Unique Items", 
                                         "Average Price", 
                                         "Number of Purchases", 
                                        "Total Revenue"]]
Purchase_Analysis["Average Price"] = Purchase_Analysis["Average Price"].map("${0:,.2f}".format)
Purchase_Analysis["Total Revenue"] = Purchase_Analysis["Total Revenue"].map("${0:,.2f}".format)
Purchase_Analysis
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Unique Items</th>
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>183</td>
      <td>$2.93</td>
      <td>780</td>
      <td>$2,286.33</td>
    </tr>
  </tbody>
</table>
</div>



# Gender Demographics
•	Percentage and Count of Male Players
•	Percentage and Count of Female Players
•	Percentage and Count of Other / Non-Disclosed



```python
Gender_Demo = json_data.groupby(['Gender']).nunique()
Gender_Demo["Percentage Count of Players"] = Gender_Demo["SN"]/Gender_Demo["SN"].sum()*100
Gender_Demo["Total Count"] = Gender_Demo["SN"]
Gender_Demo = Gender_Demo[["Total Count", "Percentage Count of Players"]]
Gender_Demo["Percentage Count of Players"] = Gender_Demo["Percentage Count of Players"].map("{0:,.2f}%".format)
Gender_Demo = Gender_Demo.sort_values('Total Count', ascending = False)
Gender_Demo
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Count</th>
      <th>Percentage Count of Players</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>465</td>
      <td>81.15%</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>100</td>
      <td>17.45%</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>8</td>
      <td>1.40%</td>
    </tr>
  </tbody>
</table>
</div>



# Purchasing Analysis (Gender)
•	The below each broken by gender
o	Purchase Count
o	Average Purchase Price
o	Total Purchase Value
o	Normalized Totals


```python
count_df = json_data.groupby(['Gender']).count()
avg_df = json_data.groupby(['Gender']).mean()
total_df = json_data.groupby(['Gender']).sum()
total_df["Purchase Count"] = count_df["SN"]
total_df["Average Purchase Price"] = avg_df["Price"]
total_df = total_df.rename(columns = {"Price": "Total Purchase Value"})
total_df = total_df.drop(columns=['Age', 'Item ID'])
pd.to_numeric(total_df["Average Purchase Price"])
total_df["Normalized Value"] = (total_df["Average Purchase Price"] - total_df["Average Purchase Price"].min()) /(total_df["Average Purchase Price"].max() - total_df["Average Purchase Price"].min())
total_df["Total Purchase Value"] = total_df["Total Purchase Value"].map("${0:,.2f}".format)
total_df["Average Purchase Price"] = total_df["Average Purchase Price"].map("${0:,.2f}".format)
total_df["Normalized Value"] = total_df["Normalized Value"].map("{0:,.2f}".format)
total_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Purchase Value</th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Normalized Value</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Female</th>
      <td>$382.91</td>
      <td>136</td>
      <td>$2.82</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>Male</th>
      <td>$1,867.68</td>
      <td>633</td>
      <td>$2.95</td>
      <td>0.31</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>$35.74</td>
      <td>11</td>
      <td>$3.25</td>
      <td>1.00</td>
    </tr>
  </tbody>
</table>
</div>



# Age Demographics
The below each broken into four (4) bins of 4 years (i.e. <10, 10-14, 15-19, etc.) 
    o	Age Demographics
    o	Percentage of Players
    o	Total Count


```python
def age_band(Age):
    if Age < 10 : return '< 10'
    elif 10 <= Age < 15: return '10-14'
    elif 15 <= Age < 20: return '15-19'
    elif Age >= 20: return '20+'
    else: return 'None'
json_data["AgeBand"] = json_data['Age'].map(age_band)
ageband_df = json_data.groupby(['AgeBand']).nunique()
ageband_df = ageband_df.drop(columns=['AgeBand', 'Item ID', 'Item Name', 'Gender', 'Age', 'Price'])
AgeDemographics = ageband_df.reset_index()
AgeDemographics = AgeDemographics.rename(columns = {"AgeBand": "Age Demogrphics", "SN": "Total Counts"})
AgeDemographics = AgeDemographics.sort_values('Total Counts')
AgeDemographics["Percentage of Players"] = AgeDemographics["Total Counts"]/AgeDemographics["Total Counts"].sum()*100
AgeDemographics["Percentage of Players"] = AgeDemographics["Percentage of Players"].map("{0:,.2f}%".format)
AgeDemographics = AgeDemographics[["Age Demogrphics", "Percentage of Players", "Total Counts"]]
AgeDemographics
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age Demogrphics</th>
      <th>Percentage of Players</th>
      <th>Total Counts</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3</th>
      <td>&lt; 10</td>
      <td>3.32%</td>
      <td>19</td>
    </tr>
    <tr>
      <th>0</th>
      <td>10-14</td>
      <td>4.01%</td>
      <td>23</td>
    </tr>
    <tr>
      <th>1</th>
      <td>15-19</td>
      <td>17.45%</td>
      <td>100</td>
    </tr>
    <tr>
      <th>2</th>
      <td>20+</td>
      <td>75.22%</td>
      <td>431</td>
    </tr>
  </tbody>
</table>
</div>



# Age Demographics (contd.)

The below each broken into four (4) bins of 4 years (i.e. <10, 10-14, 15-19, etc.) 
    o	Purchase Count
    o	Average Purchase Price
    o	Total Purchase Value
    o	Normalized Totals




```python
count_df = json_data.groupby(['AgeBand']).count()
avg_df = json_data.groupby(['AgeBand']).mean()
total_df = json_data.groupby(['AgeBand']).sum()
total_df["Purchase Count"] = count_df["SN"]
total_df["Average Purchase Price"] = avg_df["Price"]
total_df = total_df.rename(columns = {"Price": "Total Purchase Value"})
total_df = total_df.drop(columns=['Age', 'Item ID'])
pd.to_numeric(total_df["Total Purchase Value"])
total_df["Normalized Totals"] = (total_df["Total Purchase Value"] - total_df["Total Purchase Value"].min()) /(total_df["Total Purchase Value"].max() - total_df["Total Purchase Value"].min())
total_df["Total Purchase Value"] = total_df["Total Purchase Value"].map("${0:,.2f}".format)
total_df["Average Purchase Price"] = total_df["Average Purchase Price"].map("${0:,.2f}".format)
total_df["Normalized Totals"] = total_df["Normalized Totals"].map("{0:,.2f}".format)
total_df = total_df.reset_index()
total_df = total_df.sort_values('Purchase Count')
total_df = total_df.rename(columns = {"AgeBand": "Age Demographics"})
total_df = total_df[["Age Demographics", "Purchase Count", "Average Purchase Price", "Total Purchase Value", "Normalized Totals"]]
total_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age Demographics</th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3</th>
      <td>&lt; 10</td>
      <td>28</td>
      <td>$2.98</td>
      <td>$83.46</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>0</th>
      <td>10-14</td>
      <td>35</td>
      <td>$2.77</td>
      <td>$96.95</td>
      <td>0.01</td>
    </tr>
    <tr>
      <th>1</th>
      <td>15-19</td>
      <td>133</td>
      <td>$2.91</td>
      <td>$386.42</td>
      <td>0.19</td>
    </tr>
    <tr>
      <th>2</th>
      <td>20+</td>
      <td>584</td>
      <td>$2.94</td>
      <td>$1,719.50</td>
      <td>1.00</td>
    </tr>
  </tbody>
</table>
</div>



# Top Spenders
Identify the top 5 spenders in the game by total purchase value, then list (in a table):
    o SN
    o Purchase Count
    o Average Purchase Price
    o Total Purchase Value



```python
spender_df = json_data.groupby(['SN']).sum()
avg_price = json_data.groupby(['SN']).mean()
purch_count =  json_data.groupby(['SN']).count()
spender_df["Average Purchase Price"] = avg_price["Price"]
spender_df["Purchase Count"] = purch_count["Item ID"]
spender_df = spender_df.sort_values('Price', ascending=False)
spender_df = spender_df.rename(columns = {"Price": "Total Purchase Value"})
#spender_df = spender_df.reset_index()
spender_df = spender_df[['Purchase Count', 'Average Purchase Price', 'Total Purchase Value' ]]
spender_df["Total Purchase Value"] = spender_df["Total Purchase Value"].map("${0:,.2f}".format)
spender_df["Average Purchase Price"] = spender_df["Average Purchase Price"].map("${0:,.2f}".format)
spender_df.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>SN</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Undirrala66</th>
      <td>5</td>
      <td>$3.41</td>
      <td>$17.06</td>
    </tr>
    <tr>
      <th>Saedue76</th>
      <td>4</td>
      <td>$3.39</td>
      <td>$13.56</td>
    </tr>
    <tr>
      <th>Mindimnya67</th>
      <td>4</td>
      <td>$3.18</td>
      <td>$12.74</td>
    </tr>
    <tr>
      <th>Haellysu29</th>
      <td>3</td>
      <td>$4.24</td>
      <td>$12.73</td>
    </tr>
    <tr>
      <th>Eoda93</th>
      <td>3</td>
      <td>$3.86</td>
      <td>$11.58</td>
    </tr>
  </tbody>
</table>
</div>



# Most Popular Items
•	Identify the 5 most popular items by purchase count, then list (in a table):
o	Item ID
o	Item Name
o	Purchase Count
o	Item Price
o	Total Purchase Value



```python
#item_df.sort_values('Price', ascending=False)
#item_df
item_df = json_data.groupby(['Item ID', 'Item Name', 'Price']).count()
item_df = item_df.sort_values('SN', ascending=False)
item_df = item_df.reset_index()
item_df = item_df.set_index('Item ID')
#item_df
item_total = json_data.groupby(['Item ID', 'Item Name']).sum()
item_total = item_total.reset_index()
item_total = item_total.set_index('Item ID')
item_df["Total Purchase Value"] = item_total["Price"]
item_df = item_df.drop(columns=['Age', 'AgeBand', 'SN'])
item_df = item_df.rename(columns = {"Gender": "Purchase Count", "Price": "Item Price"})
item_df["Total Purchase Value"] = item_df["Total Purchase Value"].map("${0:,.2f}".format)
item_df["Item Price"] = item_df["Item Price"].map("${0:,.2f}".format)
item_df.head(5)

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Item Name</th>
      <th>Item Price</th>
      <th>Purchase Count</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>39</th>
      <td>Betrayal, Whisper of Grieving Widows</td>
      <td>$2.35</td>
      <td>11</td>
      <td>$25.85</td>
    </tr>
    <tr>
      <th>84</th>
      <td>Arcane Gem</td>
      <td>$2.23</td>
      <td>11</td>
      <td>$24.53</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Trickster</td>
      <td>$2.07</td>
      <td>9</td>
      <td>$18.63</td>
    </tr>
    <tr>
      <th>175</th>
      <td>Woeful Adamantite Claymore</td>
      <td>$1.24</td>
      <td>9</td>
      <td>$11.16</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Serenity</td>
      <td>$1.49</td>
      <td>9</td>
      <td>$13.41</td>
    </tr>
  </tbody>
</table>
</div>



# Most Profitable Items
•	Identify the 5 most profitable items by total purchase value, then list (in a table):
o	Item ID
o	Item Name
o	Purchase Count
o	Item Price
o	Total Purchase Value


```python
item_df = json_data.groupby(['Item ID', 'Item Name', 'Price']).count()

item_df = item_df.reset_index()
item_df = item_df.set_index('Item ID')
item_df
item_total = json_data.groupby(['Item ID', 'Item Name']).sum()
item_total = item_total.reset_index()
item_total = item_total.set_index('Item ID')
item_df["Total Purchase Value"] = item_total["Price"]
item_df = item_df.sort_values('Total Purchase Value', ascending=False)
item_df = item_df.drop(columns=['Age', 'AgeBand', 'SN'])
item_df = item_df.rename(columns = {"Gender": "Purchase Count", "Price": "Item Price"})
item_df["Total Purchase Value"] = item_df["Total Purchase Value"].map("${0:,.2f}".format)
item_df["Item Price"] = item_df["Item Price"].map("${0:,.2f}".format)
item_df.head(5)

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Item Name</th>
      <th>Item Price</th>
      <th>Purchase Count</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>34</th>
      <td>Retribution Axe</td>
      <td>$4.14</td>
      <td>9</td>
      <td>$37.26</td>
    </tr>
    <tr>
      <th>115</th>
      <td>Spectral Diamond Doomblade</td>
      <td>$4.25</td>
      <td>7</td>
      <td>$29.75</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Orenmir</td>
      <td>$4.95</td>
      <td>6</td>
      <td>$29.70</td>
    </tr>
    <tr>
      <th>103</th>
      <td>Singed Scalpel</td>
      <td>$4.87</td>
      <td>6</td>
      <td>$29.22</td>
    </tr>
    <tr>
      <th>107</th>
      <td>Splitter, Foe Of Subtlety</td>
      <td>$3.61</td>
      <td>8</td>
      <td>$28.88</td>
    </tr>
  </tbody>
</table>
</div>


