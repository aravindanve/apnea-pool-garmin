import Toybox.Lang;
import Toybox.WatchUi;

class ApneaPoolDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ApneaPoolMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}