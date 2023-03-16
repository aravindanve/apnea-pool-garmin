using Toybox.Activity;
using Toybox.Sensor;
using Toybox.System;
using Toybox.Attention;
using Toybox.FitContributor;
using Toybox.ActivityRecording;

class ApneaPoolModel
{
    hidden var mTimer;
    hidden var mSession;

    hidden var mElapsedTime;
    hidden var mAltitude;
    hidden var mAmbientPressure;
    hidden var mAmbientPressureRaw;
    hidden var mTemperature;
    hidden var mSensorAltitude;
    hidden var mSensorPressure;
    hidden var mBatteryPercentage;
    hidden var mBatteryInDays;

    hidden var mAltitudeField;
    hidden var mAmbientPressureField;
    hidden var mAmbientPressureRawField;
    hidden var mTemperatureField;
    hidden var mSensorAltitudeField;
    hidden var mSensorPressureField;
    hidden var mBatteryPercentageField;
    hidden var mBatteryInDaysField;

    function initialize() {
        // Create session
        mSession = ActivityRecording.createSession({:name=>"Apnea Pool"});

        // Create fields to record
        mAltitudeField = mSession.createField("Altitude", 1, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mAmbientPressureField = mSession.createField("Ambient Pressure", 2, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mAmbientPressureRawField = mSession.createField("Ambient Pressure Raw", 3, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mTemperatureField = mSession.createField("Temperature", 4, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mSensorAltitudeField = mSession.createField("Sensor Altitude", 5, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mSensorPressureField = mSession.createField("Sensor Pressure", 6, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mBatteryPercentageField = mSession.createField("Battery Percentage", 7, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mBatteryInDaysField = mSession.createField("Battery In Days", 8, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});

        // Initialize data to display
        mElapsedTime = 0;
        mAmbientPressure = 0;
        mTemperature = 0;

        var systemStats = System.getSystemStats();
        if (systemStats has :battery && systemStats.battery != null) {
            mBatteryPercentage = systemStats.battery;
        } else {
            mBatteryPercentage = -1;
        }
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
    function getAmbientPressure() {
        return mAmbientPressure;
    }

    // Return the temperature
    function getTemperature() {
        return mTemperature;
    }

    // Return the battery percentage
    function getBatteryPercentage() {
        return mBatteryPercentage;
    }

    // Process activity and sensor data
    function timerCallback() as Void {
        var activityInfo = Activity.getActivityInfo();
        var sensorInfo = Sensor.getInfo();
        var systemStats = System.getSystemStats();

        // Capture activity and sendor data
        if (activityInfo has :elapsedTime) {
            mElapsedTime = activityInfo.elapsedTime;
        } else {
            mElapsedTime = 0;
        }
        if (activityInfo has :altitude && activityInfo.altitude != null) {
            mAltitude = activityInfo.altitude;
        } else {
            mAltitude = -1;
        }
        if (activityInfo has :ambientPressure && activityInfo.ambientPressure != null) {
            mAmbientPressure = activityInfo.ambientPressure;
        } else {
            mAmbientPressure = -1;
        }
        if (activityInfo has :rawAmbientPressure && activityInfo.rawAmbientPressure != null) {
            mAmbientPressureRaw = activityInfo.rawAmbientPressure;
        } else {
            mAmbientPressureRaw = -1;
        }
        if (sensorInfo has :temperature && sensorInfo.temperature != null) {
            mTemperature = sensorInfo.temperature;
        } else {
            mTemperature = -1;
        }
        if (sensorInfo has :altitude && sensorInfo.altitude != null) {
            mSensorAltitude = sensorInfo.altitude;
        } else {
            mSensorAltitude = -1;
        }
        if (sensorInfo has :pressure && sensorInfo.pressure != null) {
            mSensorPressure = sensorInfo.pressure;
        } else {
            mSensorPressure = -1;
        }
        if (systemStats has :battery && systemStats.battery != null) {
            mBatteryPercentage = systemStats.battery;
        } else {
            mBatteryPercentage = -1;
        }
        if (systemStats has :batteryInDays && systemStats.batteryInDays != null) {
            mBatteryInDays = systemStats.batteryInDays;
        } else {
            mBatteryInDays = -1;
        }

        // System.println("Ambient Pressure: " + mAmbientPressure);

        // Update fields
        mAltitudeField.setData(mAltitude);
        mAmbientPressureField.setData(mAmbientPressure);
        mAmbientPressureRawField.setData(mAmbientPressureRaw);
        mTemperatureField.setData(mTemperature);
        mSensorAltitudeField.setData(mSensorAltitude);
        mSensorPressureField.setData(mSensorPressure);
        mBatteryPercentageField.setData(mBatteryPercentage);
        mBatteryInDaysField.setData(mBatteryInDays);
    }

}