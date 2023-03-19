using Toybox.Activity;
using Toybox.Sensor;
using Toybox.System;
using Toybox.Attention;
using Toybox.FitContributor;
using Toybox.ActivityRecording;

// assume water density at 25 °C for freshwater
// https://en.wikipedia.org/wiki/Properties_of_water
const WATER_DENSITY = 997.0474; // kg/m^3

// assume gravity defined by the standard
// https://en.wikipedia.org/wiki/Standard_gravity
const GRAVITY = 9.8066; // m/s^2

class ApneaPoolModel
{
    hidden var mTimer;
    hidden var mSession;

    hidden var mElapsedTime;
    hidden var mAltitude;
    hidden var mAbsolutePressure;
    hidden var mAbsolutePressureMin;
    hidden var mDepth;
    hidden var mTemperature;
    hidden var mBatteryPercentage;
    hidden var mBatteryInDays;

    hidden var mAbsolutePressureField;
    hidden var mDepthField;
    hidden var mTemperatureField;

    function initialize() {
        // Create session
        mSession = ActivityRecording.createSession({:name=>"Apnea Pool",:sport=>Activity.SPORT_GENERIC,:subSport=>Activity.SUB_SPORT_GENERIC});

        // Create fields to record
        mAbsolutePressureField = mSession.createField("absolute_pressure", 0, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD,:units => "Pa"});
        mDepthField = mSession.createField("depth", 1, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD,:units => "m"});
        mTemperatureField = mSession.createField("temperature_2", 2, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD,:units => "C"});

        // Initialize data
        mElapsedTime = 0;
        mAltitude = 0;
        mAbsolutePressure = 100000;
        mAbsolutePressureMin = 100000;
        mDepth = 0;
        mTemperature = -1;
        mBatteryPercentage = -1;
        mBatteryInDays = -1;

        // Capture record fields
        captureRecordFields();
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

    // Capture record fields
    function captureRecordFields() {
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo has :elapsedTime) {
            mElapsedTime = activityInfo.elapsedTime;
        }
        if (activityInfo has :altitude && activityInfo.altitude != null) {
            mAltitude = activityInfo.altitude;
        }
        // NOTE: only `activityInfo.rawAmbientPressure` seems to accurately reflect changes in pressure
        // `activityInfo.ambientPressure` increases when immersed in water, then stays elevated after being removed
        // `sensorInfo.pressure` decreases when immersed in water, possibly because it thinks the altitude is reducing
        if (activityInfo has :ambientPressure && activityInfo.rawAmbientPressure != null) {
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
        }

        // capture absolute pressure min to calculate depth
        if (mAbsolutePressure < mAbsolutePressureMin) {
            mAbsolutePressureMin = mAbsolutePressure;
        }

        // System.println("Absolute Pressure: " + mAbsolutePressure);
    }

    // Calculate depth using record fields
    function calculateDepth() {
        // h = P/pg where P is pressure, p (rho) is density, g is gravity, h is depth
        // https://en.wikipedia.org/wiki/Pressure#Liquid_pressure
        var pressure = mAbsolutePressure - mAbsolutePressureMin;
        var depth = pressure / (WATER_DENSITY * GRAVITY);

        mDepth = depth.format("%.3f").toFloat();
        mDepthField.setData(mDepth);
    }

    // Handle timer callback
    function timerCallback() as Void {
        captureRecordFields();
        calculateDepth();
    }

}