import Toybox.WatchUi;
import Toybox.Lang;

class BaseView extends WatchUi.View {

    hidden var mTimer;
    hidden var mModel;
    hidden var mController;


    function initialize() {
        View.initialize();
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;
        mTimer = new Timer.Timer();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        mTimer.start(method(:timerCallback), 1000, true);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        mTimer.stop();
    }

    // Handler for the timer
    function timerCallback() {
        WatchUi.requestUpdate();
    }

    // Draw battery icon
    function drawBatteryIcon(dc) {
        var batteryPercentage = mController.getBatteryPercentage();
        var batteryIcon;
        if (batteryPercentage < 20) {
            batteryIcon = new Rez.Drawables.BattIcon10();
        } else if (batteryPercentage < 40) {
            batteryIcon = new Rez.Drawables.BattIcon25();
        } else if (batteryPercentage < 60) {
            batteryIcon = new Rez.Drawables.BattIcon50();
        } else if (batteryPercentage < 90) {
            batteryIcon = new Rez.Drawables.BattIcon75();
        } else {
            batteryIcon = new Rez.Drawables.BattIcon100();
        }
        batteryIcon.draw(dc);
    }
}
