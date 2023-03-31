using Toybox.WatchUi;

class ProgressDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Block the back button handling while the progress bar is up
    function onBack() {
        // System.println("onBack called");

        // NOTE: ProgressBar does not respect onBack override, so we need to push
        // a dummy view under the progress bar to prevent user from going back
        return true;
    }

}
