

```python
# Import the dependencies
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import csv
import os
from sklearn import preprocessing #Used for Normalized calculations
import seaborn as sns

# PyMySQL 
import pymysql
pymysql.install_as_MySQLdb()

# Import SQL Alchemy
from sqlalchemy import create_engine

# Import and establish Base for which classes will be constructed 
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

#Importing the Object Relationship Mapper (ORM)
from sqlalchemy.orm import Session

# Import modules to declare columns and column data types
from sqlalchemy import Column, Integer, String, Float
```

# Step 1 - Data Engineering (Data Importing and Data Cleaning)


```python
# Create path references for our input Data Sets (Hawaii Measurements and Hawaii Stations) 
hawaii_measurements_path = "Resources/hawaii_measurements.csv"
hawaii_stations_path = "Resources/hawaii_stations.csv"
```


```python
# Import the CSV file to their respective dataframes
hawaii_measurements_df = pd.read_csv(hawaii_measurements_path, low_memory = False)
hawaii_stations_df = pd.read_csv(hawaii_stations_path, low_memory = False)
```


```python
# Print the first 10 rows of data to the screen - just to be sure we have imported the CSV correctly
hawaii_measurements_df.head(10)
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
      <th>station</th>
      <th>date</th>
      <th>prcp</th>
      <th>tobs</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>USC00519397</td>
      <td>2010-01-01</td>
      <td>0.08</td>
      <td>65</td>
    </tr>
    <tr>
      <th>1</th>
      <td>USC00519397</td>
      <td>2010-01-02</td>
      <td>0.00</td>
      <td>63</td>
    </tr>
    <tr>
      <th>2</th>
      <td>USC00519397</td>
      <td>2010-01-03</td>
      <td>0.00</td>
      <td>74</td>
    </tr>
    <tr>
      <th>3</th>
      <td>USC00519397</td>
      <td>2010-01-04</td>
      <td>0.00</td>
      <td>76</td>
    </tr>
    <tr>
      <th>4</th>
      <td>USC00519397</td>
      <td>2010-01-06</td>
      <td>NaN</td>
      <td>73</td>
    </tr>
    <tr>
      <th>5</th>
      <td>USC00519397</td>
      <td>2010-01-07</td>
      <td>0.06</td>
      <td>70</td>
    </tr>
    <tr>
      <th>6</th>
      <td>USC00519397</td>
      <td>2010-01-08</td>
      <td>0.00</td>
      <td>64</td>
    </tr>
    <tr>
      <th>7</th>
      <td>USC00519397</td>
      <td>2010-01-09</td>
      <td>0.00</td>
      <td>68</td>
    </tr>
    <tr>
      <th>8</th>
      <td>USC00519397</td>
      <td>2010-01-10</td>
      <td>0.00</td>
      <td>73</td>
    </tr>
    <tr>
      <th>9</th>
      <td>USC00519397</td>
      <td>2010-01-11</td>
      <td>0.01</td>
      <td>64</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Print the data to the screen - just to be sure we have imported the CSV correctly
hawaii_stations_df
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
      <th>station</th>
      <th>name</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>elevation</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>USC00519397</td>
      <td>WAIKIKI 717.2, HI US</td>
      <td>21.27160</td>
      <td>-157.81680</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>USC00513117</td>
      <td>KANEOHE 838.1, HI US</td>
      <td>21.42340</td>
      <td>-157.80150</td>
      <td>14.6</td>
    </tr>
    <tr>
      <th>2</th>
      <td>USC00514830</td>
      <td>KUALOA RANCH HEADQUARTERS 886.9, HI US</td>
      <td>21.52130</td>
      <td>-157.83740</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>USC00517948</td>
      <td>PEARL CITY, HI US</td>
      <td>21.39340</td>
      <td>-157.97510</td>
      <td>11.9</td>
    </tr>
    <tr>
      <th>4</th>
      <td>USC00518838</td>
      <td>UPPER WAHIAWA 874.3, HI US</td>
      <td>21.49920</td>
      <td>-158.01110</td>
      <td>306.6</td>
    </tr>
    <tr>
      <th>5</th>
      <td>USC00519523</td>
      <td>WAIMANALO EXPERIMENTAL FARM, HI US</td>
      <td>21.33556</td>
      <td>-157.71139</td>
      <td>19.5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>USC00519281</td>
      <td>WAIHEE 837.5, HI US</td>
      <td>21.45167</td>
      <td>-157.84889</td>
      <td>32.9</td>
    </tr>
    <tr>
      <th>7</th>
      <td>USC00511918</td>
      <td>HONOLULU OBSERVATORY 702.2, HI US</td>
      <td>21.31520</td>
      <td>-157.99920</td>
      <td>0.9</td>
    </tr>
    <tr>
      <th>8</th>
      <td>USC00516128</td>
      <td>MANOA LYON ARBO 785.2, HI US</td>
      <td>21.33310</td>
      <td>-157.80250</td>
      <td>152.4</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Checking the count of data elements
hawaii_measurements_df.count()
```




    station    19550
    date       19550
    prcp       18103
    tobs       19550
    dtype: int64



# Data Cleaning


```python
# As we see inconsistent counts, we realize that hawaii_measurements_df has NaN values (blank values) for some items in the prcp column. 
# Use dropna to delete all data with these values.

# Data Clean-up Logic
# As we see inconsistent counts, we will clean up our dataframe as below
hawaii_measurements_df = hawaii_measurements_df.dropna(how = 'any')
# Now showing the revised count
hawaii_measurements_df.count()
```




    station    18103
    date       18103
    prcp       18103
    tobs       18103
    dtype: int64



# Clean Data Exporting back to CSV Files


```python
# Writing our clean dataframe back into a CSV file
hawaii_measurements_df.to_csv("Resources/clean_hawaii_measurements.csv", index = False)
hawaii_stations_df.to_csv("Resources/clean_hawaii_stations.csv", index = False)
```
