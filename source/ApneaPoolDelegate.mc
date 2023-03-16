import Toybox.Lang;
import Toybox.WatchUi;

class ApneaPoolDelegate extends WatchUi.BehaviorDelegate {

    hidden var mController;

    function initialize() {
        BehaviorDelegate.initialize();
        mController = Application.getApp().controller;
    }

    // Input handling of start/stop is mapped to onSelect
    function onSelect() {
        mController.onStartStop();
        return true;
    }

    // Block access to the menu button
    function onMenu() {
        return true;
    }

}