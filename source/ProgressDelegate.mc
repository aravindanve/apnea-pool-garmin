using Toybox.WatchUi;

class ProgressDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Block the back button handling while the progress bar is up
    function onBack() {
        return true;
    }

}
