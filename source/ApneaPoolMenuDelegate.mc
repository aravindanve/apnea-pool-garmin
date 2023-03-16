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
        var itemId = item.getId().toString();

        System.println("On menu select: " + itemId);

        if (itemId.equals("save")) {
            mController.save();
            System.println("Activity saved!");
        } else if (itemId.equals("discard")) {
            mController.discard();
            System.println("Activity discarded!");
        } else {
            mController.start();
            System.println("Activity resumed!");
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

    // Handle menu back
    function onBack() {
        System.println("On menu back");
        mController.start();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}