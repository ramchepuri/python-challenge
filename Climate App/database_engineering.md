

```python
!rm hawaii.sqlite 
# This is so that we can continue to delete the sqlite database and keep creating it again as we rerun our code
# We can decide to comment this out later if needed
```


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
import sqlalchemy
from sqlalchemy import create_engine, MetaData

# Import and establish Base for which classes will be constructed 
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

#Importing the Object Relationship Mapper (ORM)
from sqlalchemy.orm import Session

# Import modules to declare columns and column data types
from sqlalchemy import Column, Integer, String, Numeric, Text, Float
```

# Step 2 - Database Engineering

# Database Creation


```python
# Create an engine to a SQLite database file called `hawaii.sqlite`
engine = create_engine("sqlite:///hawaii.sqlite")
```


```python
# Create a connection to the engine called `conn`
conn = engine.connect()
```


```python
# Use `declarative_base` from SQLAlchemy to model the Hawaii Stations table as an ORM class (Station)
# Make sure to specify types for each column, e.g. Integer, Text, etc.
# http://docs.sqlalchemy.org/en/latest/core/type_basics.html
Base = declarative_base()

class Station(Base):
    __tablename__ = 'stations'

    id = Column(Integer, primary_key=True)
    station = Column(Text)
    name = Column(Text)
    latitude = Column (Float)
    longitude = Column (Float)
    elevation = Column (Float)
   
    def __repr__(self):
        return f"id={self.id}, name={self.name}"
# More on __repr__: https://stackoverflow.com/questions/1984162/purpose-of-pythons-repr 
```


```python
class Measurement(Base):
    __tablename__ = 'measurements'

    id = Column(Integer, primary_key=True)
    station = Column(Text)
    date = Column(Text)
    prcp = Column (Float)
    tobs = Column (Float)
   
    def __repr__(self):
        return f"id={self.id}, name={self.name}"
# More on __repr__: https://stackoverflow.com/questions/1984162/purpose-of-pythons-repr 
```


```python
# Use `create_all` to create the stations and measurements tables in the database
Base.metadata.create_all(engine)
```


```python
# Load the cleaned clean_hawaii_stations.csv file into a pandas dataframe
hawaii_stations_df = pd.read_csv("Resources/clean_hawaii_stations.csv", low_memory = False)
```


```python
# Display the dataframe
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
# Display the data types of this dataframe
hawaii_stations_df.dtypes
```




    station       object
    name          object
    latitude     float64
    longitude    float64
    elevation    float64
    dtype: object




```python
# Load the cleaned clean_hawaii_measurements.csv file into a pandas dataframe
hawaii_measurements_df = pd.read_csv("Resources/clean_hawaii_measurements.csv", low_memory = False)
```


```python
# Display the top 5 records of the dataframe
hawaii_measurements_df.head()
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
      <td>2010-01-07</td>
      <td>0.06</td>
      <td>70</td>
    </tr>
  </tbody>
</table>
</div>




```python
hawaii_measurements_df.dtypes # Displaying the Data Types of this dataframe
```




    station     object
    date        object
    prcp       float64
    tobs         int64
    dtype: object




```python
# Use Orient='records' to create a list of data to write
# to_dict() cleans out DataFrame metadata as well
# http://pandas-docs.github.io/pandas-docs-travis/io.html#orient-options
stations_data = hawaii_stations_df.to_dict(orient='records')
measurements_data = hawaii_measurements_df.to_dict(orient='records')
# TUSHAAR COMMENTS -> THIS IS THE NEW CODE THAT ALLOWS US TO IMPORT LARGE CSV FILES.....
```


```python
# Data is just a list of dictionaries that represent each row of data - dispplaying the stations data dictionary
print(stations_data)
```

    [{'station': 'USC00519397', 'name': 'WAIKIKI 717.2, HI US', 'latitude': 21.2716, 'longitude': -157.8168, 'elevation': 3.0}, {'station': 'USC00513117', 'name': 'KANEOHE 838.1, HI US', 'latitude': 21.4234, 'longitude': -157.8015, 'elevation': 14.6}, {'station': 'USC00514830', 'name': 'KUALOA RANCH HEADQUARTERS 886.9, HI US', 'latitude': 21.5213, 'longitude': -157.8374, 'elevation': 7.0}, {'station': 'USC00517948', 'name': 'PEARL CITY, HI US', 'latitude': 21.3934, 'longitude': -157.9751, 'elevation': 11.9}, {'station': 'USC00518838', 'name': 'UPPER WAHIAWA 874.3, HI US', 'latitude': 21.4992, 'longitude': -158.0111, 'elevation': 306.6}, {'station': 'USC00519523', 'name': 'WAIMANALO EXPERIMENTAL FARM, HI US', 'latitude': 21.33556, 'longitude': -157.71139, 'elevation': 19.5}, {'station': 'USC00519281', 'name': 'WAIHEE 837.5, HI US', 'latitude': 21.45167, 'longitude': -157.84888999999995, 'elevation': 32.9}, {'station': 'USC00511918', 'name': 'HONOLULU OBSERVATORY 702.2, HI US', 'latitude': 21.3152, 'longitude': -157.9992, 'elevation': 0.9}, {'station': 'USC00516128', 'name': 'MANOA LYON ARBO 785.2, HI US', 'latitude': 21.3331, 'longitude': -157.8025, 'elevation': 152.4}]



```python
print (measurements_data[:5]) # Displaying the 5 records of our measurements data dictionary
```

    [{'station': 'USC00519397', 'date': '2010-01-01', 'prcp': 0.08, 'tobs': 65}, {'station': 'USC00519397', 'date': '2010-01-02', 'prcp': 0.0, 'tobs': 63}, {'station': 'USC00519397', 'date': '2010-01-03', 'prcp': 0.0, 'tobs': 74}, {'station': 'USC00519397', 'date': '2010-01-04', 'prcp': 0.0, 'tobs': 76}, {'station': 'USC00519397', 'date': '2010-01-07', 'prcp': 0.06, 'tobs': 70}]



```python
# Use MetaData from SQLAlchemy to reflect the tables
metadata = MetaData(bind=engine)
metadata.reflect()
```


```python
# Save the reference to the `stations` table as a variable called `stations_table`
stations_table = sqlalchemy.Table('stations', metadata, autoload=True)
```


```python
# Save the reference to the `measurements` table as a variable called `measurements_table`
measurements_table = sqlalchemy.Table('measurements', metadata, autoload=True)
```


```python
# Use `table.delete()` to remove any pre-existing data.
# Note that this is a convenience function so that you can re-run the code multiple times.
conn.execute(stations_table.delete())
conn.execute(measurements_table.delete())
```




    <sqlalchemy.engine.result.ResultProxy at 0x1a17fd7d30>




```python
# Use `table.insert()` to insert the data into the table
# Our SQL tables are populated during this step
conn.execute(stations_table.insert(), stations_data)
conn.execute(measurements_table.insert(), measurements_data)
```




    <sqlalchemy.engine.result.ResultProxy at 0x1a18b5e6a0>




```python
# Test that the insert works by fetching the first 5 rows for our stations table
conn.execute("select * from stations").fetchall()
```




    [(1, 'USC00519397', 'WAIKIKI 717.2, HI US', 21.2716, -157.8168, 3.0),
     (2, 'USC00513117', 'KANEOHE 838.1, HI US', 21.4234, -157.8015, 14.6),
     (3, 'USC00514830', 'KUALOA RANCH HEADQUARTERS 886.9, HI US', 21.5213, -157.8374, 7.0),
     (4, 'USC00517948', 'PEARL CITY, HI US', 21.3934, -157.9751, 11.9),
     (5, 'USC00518838', 'UPPER WAHIAWA 874.3, HI US', 21.4992, -158.0111, 306.6),
     (6, 'USC00519523', 'WAIMANALO EXPERIMENTAL FARM, HI US', 21.33556, -157.71139, 19.5),
     (7, 'USC00519281', 'WAIHEE 837.5, HI US', 21.45167, -157.84888999999995, 32.9),
     (8, 'USC00511918', 'HONOLULU OBSERVATORY 702.2, HI US', 21.3152, -157.9992, 0.9),
     (9, 'USC00516128', 'MANOA LYON ARBO 785.2, HI US', 21.3331, -157.8025, 152.4)]




```python
# Test that the insert works by fetching the first 5 rows for our measurements table
conn.execute("select * from measurements limit 5").fetchall()
```




    [(1, 'USC00519397', '2010-01-01', 0.08, 65.0),
     (2, 'USC00519397', '2010-01-02', 0.0, 63.0),
     (3, 'USC00519397', '2010-01-03', 0.0, 74.0),
     (4, 'USC00519397', '2010-01-04', 0.0, 76.0),
     (5, 'USC00519397', '2010-01-07', 0.06, 70.0)]


