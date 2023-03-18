import Toybox.Lang;
import Toybox.WatchUi;

class ApneaPoolDelegate extends WatchUi.BehaviorDelegate {

    hidden var mController;

    function initialize() {
        BehaviorDelegate.initialize();
        mController = Application.getApp().controller;
    }

    // handle start stop button
    function onSelect() {
        mController.onStartStop();
        return true;
    }

    // Handle back button
    function onBack() {
        mController.onBack();
        return true;
    }

    // Block access to the menu button
    function onMenu() {
        return true;
    }

}