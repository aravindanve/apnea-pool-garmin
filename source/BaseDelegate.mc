import Toybox.Lang;
import Toybox.WatchUi;

class BaseDelegate extends WatchUi.BehaviorDelegate {

    hidden var mController;
    hidden var mPage;

    function initialize(page) {
        BehaviorDelegate.initialize();
        mController = Application.getApp().controller;
        mPage = page;
    }

    // Handle start stop button
    function onSelect() {
        // System.println("onSelect called");
        mController.onStartStop();
        return true;
    }

    // Handle back button
    function onBack() {
        // System.println("onBack called");
        mController.onBack();
        return true;
    }

    // Block access to the menu button
    function onMenu() {
        // System.println("onMenu called");
        return true;
    }

    // Handle the next page button
    function onNextPage() as Boolean {
        // System.println("onNextPage called");
        switchToPage(mPage + 1, WatchUi.SLIDE_UP);
        return true;
    }

    // Handle the previous page button
    function onPreviousPage() as Boolean {
        // System.println("onPreviousPage called");
        switchToPage(mPage - 1, WatchUi.SLIDE_DOWN);
        return true;
    }

    function switchToPage(page, transition) {
        // System.println("switchToPage called with " + page);

        var pageIndex = (page % 2).abs();
        switch (pageIndex) {
        case 0:
            WatchUi.switchToView(new DiveView(), new DiveDelegate(), transition);
            break;
        case 1:
            WatchUi.switchToView(new SessionView(), new SessionDelegate(), transition);
            break;
        default:
        }
    }

}
