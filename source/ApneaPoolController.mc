using Toybox.Timer;
using Toybox.Application;
using Toybox.WatchUi;

using Toybox.WatchUi;
using Toybox.System;

class ApneaPoolController
{
    hidden var mTimer;
    hidden var mModel;
    hidden var mRunning;

    function initialize() {
        mTimer = null;
        mModel = Application.getApp().model;
        mRunning = false;
    }

    function start() {
        mModel.start();
        mRunning = true;
    }

    function stop() {
        mModel.stop();
        mRunning = false;
    }

    function save() {
        mModel.save();

        // Give the system some time to finish the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        WatchUi.pushView(new WatchUi.ProgressBar("Saving...", null), new ApneaPoolProgressDelegate(), WatchUi.SLIDE_DOWN);
        mTimer = new Timer.Timer();
        mTimer.start(method(:onExit), 3000, false);
    }

    function discard() {
        mModel.discard();

        // Give the system some time to discard the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        WatchUi.pushView(new WatchUi.ProgressBar("Discarding...", null), new ApneaPoolProgressDelegate(), WatchUi.SLIDE_DOWN);
        mTimer = new Timer.Timer();
        mTimer.start(method(:onExit), 3000, false);
    }

    function isRunning() {
        return mRunning;
    }

    function getElapsedTime() {
        return mModel.getElapsedTime();
    }

    function getAbsolutePressure() {
        return mModel.getAbsolutePressure();
    }

    function getDepth() {
        return mModel.getDepth();
    }

    function getTemperature() {
        return mModel.getTemperature();
    }

    function getBatteryPercentage() {
        return mModel.getBatteryPercentage();
    }

    function getBatteryInDays() {
        return mModel.getBatteryInDays();
    }

    function onStartStop() {
        if (mRunning) {
            stop();
            WatchUi.pushView(new Rez.Menus.MainMenu(), new ApneaPoolMenuDelegate(), WatchUi.SLIDE_LEFT);
        } else {
            start();
        }
    }

    function onBack() {
        if (mRunning) {
            stop();
            WatchUi.pushView(new Rez.Menus.MainMenu(), new ApneaPoolMenuDelegate(), WatchUi.SLIDE_LEFT);
        } else {
            System.exit();
        }
    }

    function onExit() as Void {
        System.exit();
    }

}