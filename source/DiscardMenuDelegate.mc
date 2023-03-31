import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DiscardMenuDelegate extends WatchUi.Menu2InputDelegate {

    hidden var mController;

    function initialize() {
        Menu2InputDelegate.initialize();
        mController = Application.getApp().controller;

    }

    // Handle menu select
    function onSelect(item) {
        var itemId = item.getId();

        // System.println("On menu select: " + item.getLabel());

        if (itemId.equals(:Yes)) {
            mController.discardConfirm();
            // System.println("Discard confirmed!");
        } else {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            // System.println("Discard canceled!");
        }
    }

    // Handle menu back
    function onBack() {
        // System.println("On menu back");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
