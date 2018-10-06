from flask import Flask, jsonify

# link to hawaii.sqlite
# Python SQL toolkit and Object Relational Mapper
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

# Use SQLAlchemy create_engine to connect to your sqlite database.
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# Use SQLAlchemy automap_base() to reflect your tables into classes 
# i.e. an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# save a reference to those classes/each table called Station & Measurement.
Measurement = Base.classes.measurement
Station = Base.classes.station

# Flask Setup
app = Flask(__name__)

# Flask Routes
# Query for the dates and temperature observations from the last year.
# Convert the query results to a Dictionary using `date` as the key and `prcp` as the value.
# Return the JSON representation of your dictionary.

@app.route("/")

def index():
    print("this is the home page")
    return(f"Welcome to the climate analysis API.<br/>"
           f"Available routes:<br/>"
           f"/api/v1.0/precipitation<br/>"
           f"/api/v1.0/stations<br/>"
           f"/api/v1.0/tobs<br/>"
           f"/api/v1.0/temp/<start><br/>"
           f"/api/v1.0/temp/<start>/<end>")


@app.route("/api/v1.0/precipitation")

def Precip():
    print("this is precip. data")
# Create our session (link) from Python to the DB
    session = Session(engine) 

    Recent_Measurements = session.query(Measurement.date, Measurement.prcp).\
    filter(Measurement.date >= '2016-08-23').all() 

    session.close() 

    return jsonify(Recent_Measurements) 

# Return a JSON list of stations from the dataset.


@app.route("/api/v1.0/stations")

def stations():
    print("this is station info.")

    session = Session(engine) 

    stations = session.query(Station.station).all() 

    session.close() 

    return jsonify(stations)  

# Return a JSON list of Temperature Observations (tobs) for the previous year.


@app.route("/api/v1.0/tobs")

def Temp():
    print("this is temp info.")

    session = Session(engine) 

    Recent_Temps = session.query(Measurement.date, Measurement.tobs).\
    filter(Measurement.date >= '2016-08-23').filter(Measurement.station=='USC00519281').all() 

    session.close() 

    return jsonify(Recent_Temps) 

# Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start or start-end range.
# When given the start only, calculate `TMIN`, `TAVG`, and `TMAX` for all dates greater than and equal to the start date.
# When given the start and the end date, calculate the `TMIN`, `TAVG`, and `TMAX` for dates between the start and end date inclusive.

@app.route("/api/v1.0/temp/<start>")

def Temp_summary(start):  

    print("this is temp info.") 

    session = Session(engine) 

    temp_stats = session.query(func.min(Measurement.tobs),func.max(Measurement.tobs),func.avg(Measurement.tobs)).\
    filter(Measurement.date >= start).all() 

    session.close() 

    return jsonify(temp_stats) 


@app.route("/api/v1.0/temp/<start>/<end>") 

def Temp_summary_2(start,end):   

    print("this is more temp info.") 

    session = Session(engine) 

    temp_stats = session.query(func.min(Measurement.tobs),func.max(Measurement.tobs),func.avg(Measurement.tobs)).\
    filter(Measurement.date >= start).filter(Measurement.date <= end).all()  

    session.close() 

    return jsonify(temp_stats) 


if __name__ == "__main__":
    app.run(debug=True)
