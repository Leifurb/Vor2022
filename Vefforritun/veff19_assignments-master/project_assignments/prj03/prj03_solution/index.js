const express = require('express');

const app = express();
const apiPath = '/api/';
const version = 'v1';
const port = 3000;

//Import a body parser module to be able to access the request body as json
const bodyParser = require('body-parser');
//Tell express to use the body parser module
app.use(bodyParser.json());

let nextStationId = 3;
let nextObservationId = 3;

//The following is an example of an array of two stations. 
//The observation array includes the ids of the observations belonging to the specified station
var stations = [
    { id: 1, description: "Reykjavik", lat: 64.1275, lon: 21.9028, observations: [2] },
    { id: 2, description: "Akureyri", lat: 65.6856, lon: 18.1002, observations: [1] }
];

//The following is an example of an array of two observations.
//Note that an observation does not know which station it belongs to!
var observations = [
    { id: 1, date: 1551885104266, temp: -2.7, windSpeed: 2.0, windDir: "ese", prec: 0.0, hum: 82.0 },
    { id: 2, date: 1551885137409, temp: 0.6, windSpeed: 5.0, windDir: "n", prec: 0.0, hum: 50.0 },
];

//Station endpoints
app.get(apiPath + version + '/stations', (req, res) => {
    let returnArray = [];
    for (let i=0;i<stations.length;i++) {
        returnArray.push({id:stations[i].id, description: stations[i].description});
    }
    res.status(200).json(returnArray);
});

app.get(apiPath + version + '/stations/:stationId', (req, res) => {
    for (let i = 0; i < stations.length; i++) {
        if (stations[i].id == req.params.stationId) {
            return res.status(200).json(stations[i]);
        }
    }
    res.status(404).json({ 'message': "Station with id " + req.params.stationId + " does not exist." });
});

app.post(apiPath + version + '/stations', (req, res) => {
    if (req.body === undefined || req.body.description === undefined || req.body.lat === undefined || req.body.lon === undefined) {
        res.status(400).json({ 'message': "Stations require a description, lat and lon in the request body" });
    } else {
        let lat = Number(req.body.lat);
        let lon = Number(req.body.lon);

        if (isNaN(lat) || lat < -90.0 || lat > 90.0) {
            return res.status(400).json({ 'message': "Latitude values must be in the interval [-90,90]." });
        }

        if (isNaN(lon) || lon < -180.0 || lat > 180.0) {
            return res.status(400).json({ 'message': "Longitude values must be in the interval [-180,180]." });
        }

        let newStation = { description: req.body.description, lat: lat, lon: lon, id: nextStationId, observations: [] };
        stations.push(newStation);
        nextStationId++;
        res.status(201).json(newStation);
    }
});

app.put(apiPath + version + '/stations/:stationId', (req, res) => {
    if (req.body === undefined || req.body.description === undefined || req.body.lat === undefined || req.body.lon === undefined) {
        res.status(400).json({ 'message': "Stations require a description, lat and lon in the request body" });
    } else {
        for (let i = 0; i < stations.length; i++) {
            if (stations[i].id == req.params.stationId) {

                let lat = Number(req.body.lat);
                let lon = Number(req.body.lon);

                if (isNaN(lat) || lat < -90.0 || lat > 90.0) {
                    return res.status(400).json({ 'message': "Latitude values must be in the interval [-90,90]." });
                }

                if (isNaN(lon) || lon < -180.0 || lat > 180.0) {
                    return res.status(400).json({ 'message': "Longitude values must be in the interval [-180,180]." });
                }

                stations[i].description = req.body.description;
                stations[i].lat = lat;
                stations[i].lon = lon;
                return res.status(200).json(stations[i]);
            }
        }
        res.status(404).json({ 'message': "Station with id " + req.params.stationId + " does not exist." });
    }
});

app.delete(apiPath + version + '/stations/:stationId', (req, res) => {
    for (let i = 0; i < stations.length; i++) {
        if (stations[i].id == req.params.stationId) {
            let obsIds = stations[i].observations.slice();
            stations[i].observations = [];

            for (let j = observations.length - 1; j >= 0; j--) {
                if (obsIds.includes(observations[j].id)) {
                    stations[i].observations.push(observations.splice(j, 1));
                }
            }

            return res.status(200).json(stations.splice(i, 1));
        }
    }
    res.status(404).json({ 'message': "Station with id " + req.params.stationId + " does not exist." });
});

app.delete(apiPath + version + '/stations', (req, res) => {
    var returnArray = stations.slice();
    stations = [];

    for (let i = 0; i < returnArray.length; i++) {
        let obsIds = returnArray[i].observations.slice();
        returnArray[i].observations = [];

        for (let j = observations.length - 1; j >= 0; j--) {
            if (obsIds.includes(observations[j].id)) {
                returnArray[i].observations.push(observations.splice(j, 1));
            }
        }
    }

    res.status(200).json(returnArray);
});

//Observation endpoints
app.get(apiPath + version + '/stations/:stationId/observations', (req, res) => {
    for (let i = 0; i < stations.length; i++) {
        if (stations[i].id == req.params.stationId) {
            let returnArray = [];
            for (let j = 0; j < observations.length; j++) {
                if (stations[i].observations.includes(observations[j].id)) {
                    returnArray.push(observations[j]);
                }
            }
            return res.status(200).json(returnArray);
        }
    }
    res.status(404).json({ 'message': "Station with id " + req.params.stationId + "does not exist." });
});

app.get(apiPath + version + '/stations/:stationId/observations/:observationId', (req, res) => {
    for (let i = 0; i < stations.length; i++) {
        if (stations[i].id == req.params.stationId) {
            if (!stations[i].observations.includes(Number(req.params.observationId))) {
                return res.status(404).json({ 'message': "Observation with id " + req.params.observationId + " does not exist for the selected station." });
            }
            for (let j = 0; j < observations.length; j++) {
                if (observations[j].id == req.params.observationId) {
                    return res.status(200).json(observations[j]);
                }
            }
            return res.status(404).json({ 'message': "Observation with id " + req.params.observationId + "does not exist for the selected station." });
        }
    }
    res.status(404).json({ 'message': "Station with id " + req.params.stationId + "does not exist." });
});

app.post(apiPath + version + '/stations/:stationId/observations', (req, res) => {
    //id: 1, date: 1551885104266, temp: -2.7, windSpeed: 2.0, windDir: "ese", prec: 0.0, hum: 82.0
    if (req.body === undefined || req.body.temp === undefined || req.body.windSpeed === undefined
        || req.body.windDir === undefined || req.body.prec === undefined || req.body.hum === undefined) {
        res.status(400).json({ 'message': "Observations require temp, windSpeed, windDir, prec and hum parameters in the request body." });
    } else {
        for (let i = 0; i < stations.length; i++) {
            if (stations[i].id == req.params.stationId) {
                let temp = Number(req.body.temp);
                let windSpeed = Number(req.body.windSpeed);
                let prec = Number(req.body.prec);
                let hum = Number(req.body.hum);

                if (isNaN(temp)) {
                    return res.status(400).json({ 'message': "Temperature must be a number." });
                }

                if (isNaN(windSpeed)) {
                    return res.status(400).json({ 'message': "Wind Speed must be a number." });
                }

                if (isNaN(prec) || prec < 0.0) {
                    return res.status(400).json({ 'message': "Precipitation must be a positive number." });
                }

                if (isNaN(hum) || hum < 0.0 || hum > 100.0) {
                   return res.status(400).json({ 'message': "Humidity must be a percentage (Number between 0 and 100)." });
                }

                let newObs = {
                    id: nextObservationId, date: Date.now(), temp: temp, windSpeed: windSpeed,
                    windDir: req.body.windDir, prec: prec, hum: hum
                };
                stations[i].observations.push(nextObservationId);
                observations.push(newObs);
                nextObservationId++;
                res.status(201).json(newObs);
                return;
            }
        }
        res.status(404).json({ 'message': "Station with id " + req.params.stationId + " does not exist" });
    }
});

app.delete(apiPath + version + '/stations/:stationId/observations/:observationId', (req, res) => {
    for (let i = 0; i < stations.length; i++) {
        if (stations[i].id == req.params.stationId) {
            let found = false;
            for (let j = 0; j < stations[i].observations.length; j++) {
                if (stations[i].observations[j] == req.params.observationId) {
                    found = true;
                    stations[i].observations.splice(j, 1);
                }
            }
            if (found === false) {
                return res.status(404).json({ 'message': "Observation with id " + req.params.observationId + " does not exist for the selected station." });
            }

            for (let j = 0; j < observations.length; j++) {
                if (observations[j].id == req.params.observationId) {
                    return res.status(200).json(observations.splice(j, 1));
                }
            }
            return res.status(404).json({ 'message': "Observation with id " + req.params.observationId + " does not exist for the selected station." });
        }
    }
    res.status(404).json({ 'message': "Station with id " + req.params.stationId + "does not exist." });
});

app.delete(apiPath + version + '/stations/:stationId/observations', (req, res) => {
    for (let i = 0; i < stations.length; i++) {
        if (stations[i].id == req.params.stationId) {
            let returnArray = [];
            //iterate reverse, so that splice doesn't break the indexing
            for (let j = observations.length - 1; j >= 0; j--) {
                if (stations[i].observations.includes(observations[j].id)) {
                    returnArray.push(observations.splice(j, 1));
                }
            }
            stations[i].observations = [];
            return res.status(200).json(returnArray);
        }
    }
    res.status(404).json({ 'message': "Station with id " + req.params.stationId + " does not exist" });
});

//Default: Not supported
app.use('*', (req, res) => {
    res.status(405).send('Operation not supported.');
});

app.listen(port, () => {
    console.log('Weather app listening...');
});