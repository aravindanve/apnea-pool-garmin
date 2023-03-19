import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ApneaPoolMenuDelegate extends WatchUi.Menu2InputDelegate {

    hidden var mController;

    function initialize() {
        Menu2InputDelegate.initialize();
        mController = Application.getApp().controller;

    }

    // Handle menu select
    function onSelect(item) {
        var itemId = item.getId();

        // System.println("On menu select: " + item.getLabel());

        if (itemId.equals(:Save)) {
            mController.save();
            // System.println("Activity saved!");
        } else if (itemId.equals(:Discard)) {
            mController.discard();
            // System.println("Activity discarded!");
        } else {
            mController.start();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            // System.println("Activity resumed!");
        }
    }

    // Handle menu back
    function onBack() {
        // System.println("On menu back");
        mController.start();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}