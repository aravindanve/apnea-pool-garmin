import Toybox.Lang;
import Toybox.WatchUi;

// NOTE: ProgressBar does not respect onBack override, so we need to push
// a dummy view under the progress bar to prevent user from going back
class ExitDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Block start stop button
    function onSelect() {
        return true;
    }

    // Block back button
    function onBack() {
        return true;
    }

    // Block access to the menu button
    function onMenu() {
        return true;
    }

    // Block the next page button
    function onNextPage() as Boolean {
        return true;
    }

    // Block the previous page button
    function onPreviousPage() as Boolean {
        return true;
    }

}
