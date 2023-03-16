import Toybox.Graphics;
import Toybox.WatchUi;

class ApneaPoolView extends WatchUi.View {

    hidden var mTimer;
    hidden var mModel;
    hidden var mController;

    hidden var mFieldOneLeftValue;
    hidden var mFieldOneRightValue;

    hidden var mFieldTwoValue;

    hidden var mFieldThreeValue;

    hidden var mFieldBattValue;


    function initialize() {
        View.initialize();
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;

        mTimer = new Timer.Timer();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));

        mFieldBattValue = View.findDrawableById("FieldBattValue");

        mFieldOneLeftValue = View.findDrawableById("FieldOneLeftValue");
        mFieldOneRightValue = View.findDrawableById("FieldOneRightValue");

        mFieldTwoValue = View.findDrawableById("FieldTwoValue");

        mFieldThreeValue = View.findDrawableById("FieldThreeValue");

        mFieldBattValue = View.findDrawableById("FieldBattValue");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        mTimer.start(method(:timerCallback), 1000, true);
    }

    // Update the view
    function onUpdate(dc) {
        // Update fields if running
        if (mController.isRunning() ) {
            // Update timer
            var time = mController.getElapsedTime() / 1000;

            // System.println("Elapsed Time: " + time);

            var hours = time / 3600;
            var hoursRemainder = time % 3600;
            var minutes = hoursRemainder / 60;
            var seconds = hoursRemainder % 60;

            var timerLeftValueString = "";
            if (hours > 0) {
                timerLeftValueString = hours.format("%d");
            }

            var timerRightValueString = Lang.format("$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);
            mFieldOneLeftValue.setText(timerLeftValueString);
            mFieldOneRightValue.setText(timerRightValueString);

            // Update pressure
            var pressure = mController.getAmbientPressure();
            var pressureValueString = pressure.format("%d");
            mFieldTwoValue.setText(pressureValueString);

            // Update temperature
            var temperature = mController.getTemperature();
            var temperatureValueString = Lang.format("$1$°C", [temperature.format("%d")]);
            mFieldThreeValue.setText(temperatureValueString);
        }

        // Update battery percentage
        var batteryPercentage = mController.getTemperature();
        var batteryPercentageValueString = Lang.format("$1$%", [batteryPercentage.format("%d")]);
        mFieldBattValue.setText(batteryPercentageValueString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        mTimer.stop();
    }

    // Handler for the timer
    function timerCallback() {
        WatchUi.requestUpdate();
    }

}
