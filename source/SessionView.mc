class SessionView extends BaseView {
    hidden var mTimerLeftValueLabel;
    hidden var mTimerRightValueLabel;
    hidden var mTimeOfDayValueLabel;
    hidden var mDiveCountValueLabel;
    hidden var mBattValueLabel;

    function initialize() {
        BaseView.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SessionLayout(dc));

        mBattValueLabel = View.findDrawableById("BattValueLabel");
        mTimerLeftValueLabel = View.findDrawableById("TimerLeftValueLabel");
        mTimerRightValueLabel = View.findDrawableById("TimerRightValueLabel");
        mTimeOfDayValueLabel = View.findDrawableById("TimeOfDayValueLabel");
        mDiveCountValueLabel = View.findDrawableById("DiveCountValueLabel");
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
            mTimerLeftValueLabel.setText(timerLeftValueString);
            mTimerRightValueLabel.setText(timerRightValueString);

            // Update time of day
            var timeOfDay = System.getClockTime();
            var timeOfDayValueString = timeOfDay.hour.format("%d") + ":" + timeOfDay.min.format("%02d");
            mTimeOfDayValueLabel.setText(timeOfDayValueString);

            // Update dive count
            var diveCount = mController.getSessionDiveCount();
            var diveCountValueString = diveCount.format("%d");
            mDiveCountValueLabel.setText(diveCountValueString);
        }

        // // TODO: show battery remaining in hours.
        // // `batteryInDays` seems to always return 0.0, 1.0 or 2.0 never a float value
        // var batteryInHours = mController.getBatteryInDays() * 24;
        // var batteryValueString = Lang.format("$1$h", [batteryInHours.format("%d")]);

        // Update battery value
        var batteryPercentage = mController.getBatteryPercentage();
        var batteryValueString = Lang.format("$1$%", [batteryPercentage.format("%d")]);
        mBattValueLabel.setText(batteryValueString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Update battery icon
        drawBatteryIcon(dc);
    }

}
