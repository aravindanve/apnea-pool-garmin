class DiveView extends BaseView {
    hidden var mTimerLeftValueLabel;
    hidden var mTimerRightValueLabel;
    hidden var mDepthValueLabel;
    hidden var mDiveCountValueLabel;
    hidden var mTempValueLabel;

    function initialize() {
        BaseView.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.DiveLayout(dc));

        mTempValueLabel = View.findDrawableById("TempValueLabel");
        mTimerLeftValueLabel = View.findDrawableById("TimerLeftValueLabel");
        mTimerRightValueLabel = View.findDrawableById("TimerRightValueLabel");
        mDepthValueLabel = View.findDrawableById("DepthValueLabel");
        mDiveCountValueLabel = View.findDrawableById("DiveCountValueLabel");
    }

    // Update the view
    function onUpdate(dc) {
        // Update fields if running
        if (mController.isRunning()) {
            // Update timer value
            var time = mController.getLapTime() / 1000;

            // System.println("Lap Time: " + time);

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

            // Update depth
            var depth = mController.getDepth();
            var depthValueString = depth.format("%.1f");
            mDepthValueLabel.setText(depthValueString);

            // Update dive count
            var diveCount = mController.getSessionDiveCount();
            var diveCountValueString = diveCount.format("%d");
            mDiveCountValueLabel.setText(diveCountValueString);
        }

        // Update temperature
        var temperature = mController.getTemperature();
        var temperatureValueString = temperature.format("%.1f");
        mTempValueLabel.setText(temperatureValueString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

}
