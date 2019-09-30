import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify


#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurement = Base.classes.measurement
Station = Base.classes.station

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def Home():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation <br/>"
        f"/api/v1.0/stations <br/>"
        f"/api/v1.0/tobs <br/>"
        f"/api/v1.0/&lt;start&gt; <br/>"
        f"/api/v1.0/&lt;start&gt;/&ltend&gt;<br/>"
    )


@app.route("/api/v1.0/precipitation")
def precipitation():
    # Create our session (link) from Python to the DB
    session = Session(engine)

    """Return a list of all precipitation values"""
    # Query all prcp
    session = Session(engine)
    results = session.query(Measurement.date, Measurement.prcp).all()

    session.close()

    #Create a dictionary from the row data and append to a list of all_prcp_values
   # all_prcp_values = []


    # for date, prcp in results:
    #     prcp_dict = {date: prcp}
    #     all_prcp_values.append(prcp_dict)

    # return jsonify(all_prcp_values)

    return jsonify(dict(results))


@app.route("/api/v1.0/stations")
def stations(): 
    # Create our session (link) from Python to the DB
    session = Session(engine)

    """Return a list of all Stations"""
    # Query all prcp
    session = Session(engine)
    stations_results = session.query(Station.station).all()

    session.close()
    
    all_stations= list(np.ravel(stations_results))

    return jsonify(all_stations)


@app.route("/api/v1.0/tobs")
def tobs(): 
    # Create our session (link) from Python to the DB
    session = Session(engine)

    """Return a list of all Temperature values"""
    # Query all prcp
    session = Session(engine)
    tobs_results = session.query(Measurement.tobs).\
     filter(Measurement.date.between('2016-08-23', '2017-08-23')).\
     order_by(Measurement.date).all()

    session.close()
    
    all_tobs= list(np.ravel(tobs_results))

    return jsonify(all_tobs)  

      

@app.route("/api/v1.0/<start>")
def temperature_from_start_date(start): 
    # Create our session (link) from Python to the DB
    session = Session(engine)

    """Return a list of all Min, Max, Avg temperature values"""
    # Query all prcp
    session = Session(engine)

    sel = [func.min(Measurement.tobs), 
       func.max(Measurement.tobs), 
       func.avg(Measurement.tobs),Measurement.date ]


    temperature_results = session.query(*sel).\
        filter(Measurement.date >= start).\
        group_by(Measurement.date).\
        order_by(Measurement.date).all()

    session.close()
    

    all_temps = []
    for min, max, avg, date in temperature_results:
        temp_dict = {}
        temp_dict["Date"] = date
        temp_dict["Min Temp"] = min
        temp_dict["Max Temp"] = max
        temp_dict["Avg Temp"] = avg 
        

        all_temps.append(temp_dict)

    return jsonify(all_temps)


@app.route("/api/v1.0/<start>/<end>")
def temperature_between_start_and_end_date(start,end): 
    # Create our session (link) from Python to the DB
    session = Session(engine)

    """Return a list of all Min, Max, Avg temperature values"""
    # Query all prcp
    session = Session(engine)

    sel = [func.min(Measurement.tobs), 
       func.max(Measurement.tobs), 
       func.avg(Measurement.tobs),Measurement.date ]

    temperature_results = session.query(*sel).\
     filter(Measurement.date.between(start, end)).\
     group_by(Measurement.date).\
     order_by(Measurement.date).all()
    

    session.close()
    
    all_temps = []
    for min, max, avg, date in temperature_results:
        temp_dict = {}
        temp_dict["Date"] = date
        temp_dict["Min Temp"] = min
        temp_dict["Max Temp"] = max
        temp_dict["Avg Temp"] = avg 
        

        all_temps.append(temp_dict)

    return jsonify(all_temps)

if __name__ == '__main__':
    app.run(debug=True)
