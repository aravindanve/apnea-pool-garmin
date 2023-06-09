using Toybox.Timer;
using Toybox.Application;
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
        mModel.setOnLapCallback(method(:onLap));
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

        // NOTE: ProgressBar does not respect onBack override, so we need to push
        // a dummy view under the progress bar to prevent user from going back
        WatchUi.switchToView(new ExitView(), new ExitDelegate(), WatchUi.SLIDE_IMMEDIATE);
        WatchUi.pushView(new WatchUi.ProgressBar("Saving...", null), new ProgressDelegate(), WatchUi.SLIDE_DOWN);
        mTimer = new Timer.Timer();
        mTimer.start(method(:onExit), 3000, false);
    }

    function discard() {
        WatchUi.pushView(new Rez.Menus.DiscardMenu(), new DiscardMenuDelegate(), WatchUi.SLIDE_LEFT);
    }

    function discardConfirm() {
        mModel.discard();

        // Give the system some time to discard the recording. Push up a progress bar
        // and start a timer to allow all processing to finish

        // NOTE: ProgressBar does not respect onBack override, so we need to push
        // a dummy view under the progress bar to prevent user from going back
        WatchUi.switchToView(new ExitView(), new ExitDelegate(), WatchUi.SLIDE_IMMEDIATE);
        WatchUi.pushView(new WatchUi.ProgressBar("Discarding...", null), new ProgressDelegate(), WatchUi.SLIDE_DOWN);
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

    function getLapTime() {
        return mModel.getLapTime();
    }

    function getLapType() {
        return mModel.getLapType();
    }

    function getLapMaxDepth() {
        return mModel.getLapMaxDepth();
    }

    function getLastDiveTime() {
        return mModel.getLastDiveTime();
    }

    function getLastDiveDepth() {
        return mModel.getLastDiveDepth();
    }

    function getSessionDiveCount() {
        return mModel.getSessionDiveCount();
    }

    function onStartStop() {
        if (mRunning) {
            stop();
            WatchUi.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(), WatchUi.SLIDE_LEFT);
        } else {
            start();
        }
    }

    function onBack() {
        // // NOTE: uncomment for testing laps
        // if (true) {
        //     toggleTestDepth();
        //     return;
        // }

        if (mRunning) {
            stop();
            WatchUi.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(), WatchUi.SLIDE_LEFT);
        } else {
            System.exit();
        }
    }

    function onLap(lapType) {
        // System.println("onLap called with: " + lapType);
        if (lapType == LAP_TYPE_DIVE) {
            WatchUi.switchToView(new DiveView(), new DiveDelegate(), WatchUi.SLIDE_IMMEDIATE);
        } else {
            WatchUi.switchToView(new RestView(), new RestDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
    }

    function onExit() as Void {
        System.exit();
    }

}
