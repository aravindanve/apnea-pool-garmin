using Toybox.Activity;
using Toybox.Sensor;
using Toybox.System;
using Toybox.Attention;
using Toybox.FitContributor;
using Toybox.ActivityRecording;

// Assume water density at 25 °C for freshwater
// https://en.wikipedia.org/wiki/Properties_of_water
const WATER_DENSITY = 997.0474; // kg/m^3

// Assume gravity defined by the standard
// https://en.wikipedia.org/wiki/Standard_gravity
const GRAVITY = 9.8066; // m/s^2

const DIVE_MIN_TIME = 5000; // ms
const DIVE_START_DEPTH = 0.8; // m
const REST_START_DEPTH = 0.2; // m

class ApneaPoolModel
{
    hidden var mTimer;
    hidden var mSession;

    hidden var mElapsedTime;
    hidden var mAbsolutePressure;
    hidden var mAbsolutePressureMin;
    hidden var mDepth;
    hidden var mTemperature;
    hidden var mBatteryPercentage;
    hidden var mBatteryInDays;
    hidden var mLapStartTime;
    hidden var mLapType;
    hidden var mLapMaxDepth;
    hidden var mSessionDiveCount;

    hidden var mAbsolutePressureField;
    hidden var mDepthField;
    hidden var mTemperatureField;
    hidden var mLapTypeField;
    hidden var mLapMaxDepthField;
    hidden var mSessionDiveCountField;

    function initialize() {
        // Create session
        mSession = ActivityRecording.createSession({:name=>"Apnea Pool",:sport=>Activity.SPORT_GENERIC,:subSport=>Activity.SUB_SPORT_GENERIC});

        // Create fields to record
        mAbsolutePressureField = mSession.createField("absolute_pressure", 0, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD,:units => "Pa"});
        mDepthField = mSession.createField("depth", 1, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD,:units => "m"});
        mTemperatureField = mSession.createField("temperature_2", 2, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD,:units => "C"});
        mLapTypeField = mSession.createField("type", 3, FitContributor.DATA_TYPE_STRING, {:mesgType => FitContributor.MESG_TYPE_LAP,:count=>5});
        mLapMaxDepthField = mSession.createField("max_depth", 4, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_LAP,:units => "m"});
        mSessionDiveCountField = mSession.createField("dive_count", 5, FitContributor.DATA_TYPE_UINT32, {:mesgType => FitContributor.MESG_TYPE_SESSION});

        // Initialize data
        mElapsedTime = 0;
        mAbsolutePressure = 100000;
        mAbsolutePressureMin = 100000;
        mDepth = 0;
        mTemperature = -1;
        mBatteryPercentage = -1;
        mBatteryInDays = -1;
        mLapStartTime = 0;
        mLapType = LAP_TYPE_REST;
        mLapMaxDepth = 0;
        mSessionDiveCount = 0;

        // Capture data
        captureData();
    }

    // Begin sensor processing
    function start() {
        // Allocate timer
        mTimer = new Timer.Timer();
        // Process the sensors at 1 Hz
        mTimer.start(method(:timerCallback), 1000, true);
        // Start recording
        mSession.start();
    }

    // Stop sensor processing
    function stop() {
        // Stop the timer
        mTimer.stop();
        // Stop recording
        mSession.stop();
    }

    // Save the current session
    function save() {
        mSession.save();
    }

    // Discard the current session
    function discard() {
        mSession.discard();
    }

    // Return the total elapsed recording time
    function getElapsedTime() {
        return mElapsedTime;
    }

    // Return the ambient pressure
    function getAbsolutePressure() {
        return mAbsolutePressure;
    }

    // Return the depth
    function getDepth() {
        return mDepth;
    }

    // Return the temperature
    function getTemperature() {
        return mTemperature;
    }

    // Return the battery percentage
    function getBatteryPercentage() {
        return mBatteryPercentage;
    }

    // Return the battery in days
    function getBatteryInDays() {
        return mBatteryInDays;
    }

    // Return the total lap time
    function getLapTime() {
        return mElapsedTime - mLapStartTime;
    }

    // Return the lap type
    function getLapType() {
        return mLapType;
    }

    // Return the lap max depth
    function getLapMaxDepth() {
        return mLapMaxDepth;
    }

    // Return the session dive count
    function getSessionDiveCount() {
        return mSessionDiveCount;
    }

    // Capture data
    function captureData() {
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo has :elapsedTime && activityInfo.elapsedTime != null) {
            mElapsedTime = activityInfo.elapsedTime;
        }
        // NOTE: only `activityInfo.rawAmbientPressure` seems to accurately reflect changes in pressure
        // `activityInfo.ambientPressure` increases when immersed in water, then stays elevated after being removed
        // `sensorInfo.pressure` decreases when immersed in water, possibly because it thinks the altitude is reducing
        if (activityInfo has :rawAmbientPressure && activityInfo.rawAmbientPressure != null) {
            mAbsolutePressure = activityInfo.rawAmbientPressure;
            mAbsolutePressureField.setData(mAbsolutePressure);
        }

        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory)) {
            var sensorIter = SensorHistory.getTemperatureHistory({:period=>1,:order=>SensorHistory.ORDER_NEWEST_FIRST});
            if (sensorIter != null) {
                var sensorSample = sensorIter.next();
                if (sensorSample != null && sensorSample.data != null) {
                    var data = sensorSample.data;
                    mTemperature = data;
                    mTemperatureField.setData(data);
                }
            }
        }

        var systemStats = System.getSystemStats();
        if (systemStats has :battery && systemStats.battery != null) {
            mBatteryPercentage = systemStats.battery;
        }
        if (systemStats has :batteryInDays && systemStats.batteryInDays != null) {
            mBatteryInDays = systemStats.batteryInDays;
            // System.println("batteryInDays: " + systemStats.batteryInDays);
        }

        // Capture absolute pressure min to calculate depth
        if (mAbsolutePressure < mAbsolutePressureMin) {
            mAbsolutePressureMin = mAbsolutePressure;
        }

        // System.println("Absolute Pressure: " + mAbsolutePressure);

        // Calculate depth
        // h = P/pg where P is pressure, p (rho) is density, g is gravity, h is depth
        // https://en.wikipedia.org/wiki/Pressure#Liquid_pressure
        var pressure = mAbsolutePressure - mAbsolutePressureMin;
        var depth = pressure / (WATER_DENSITY * GRAVITY);

        mDepth = depth.format("%.3f").toFloat();
        mDepthField.setData(mDepth);

        // Start dive or rest
        if (mLapType == LAP_TYPE_REST && depth > DIVE_START_DEPTH) {
            mSession.addLap();
            mLapStartTime = mElapsedTime;
            mLapType = LAP_TYPE_DIVE;
        } else if (mLapType == LAP_TYPE_DIVE && depth < REST_START_DEPTH) {
            var time = getLapTime();
            mSession.addLap();
            mLapStartTime = mElapsedTime;
            mLapType = LAP_TYPE_REST;

            // Count dive only if exceeds min time
            if (time >= DIVE_MIN_TIME) {
                mSessionDiveCount++;
            }
        }

        // Set lap fields
        switch (mLapType) {
        case LAP_TYPE_REST:
            mLapTypeField.setData("rest");
            break;
        case LAP_TYPE_DIVE:
            mLapTypeField.setData("dive");
            break;
        default:
        }
        mLapMaxDepthField.setData(mLapMaxDepth);

        // Set session fields
        mSessionDiveCountField.setData(mSessionDiveCount);
    }

    // Handle timer callback
    function timerCallback() as Void {
        captureData();
    }

}
