import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class ApneaPoolApp extends Application.AppBase {

    var model;
    var controller;

    function initialize() {
        AppBase.initialize();
        model = new $.ApneaPoolModel();
        controller = new $.ApneaPoolController();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new RestView(), new RestDelegate() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as ApneaPoolApp {
    return Application.getApp() as ApneaPoolApp;
}
