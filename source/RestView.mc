class RestView extends BaseView {
    hidden var mTimerTitleLabel;
    hidden var mTimerLeftValueLabel;
    hidden var mTimerRightValueLabel;
    hidden var mLastDiveTimeValueLabel;
    hidden var mLastDiveDepthValueLabel;
    hidden var mDiveCountValueLabel;
    hidden var mTempValueLabel;

    function initialize() {
        BaseView.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.RestLayout(dc));

        mTempValueLabel = View.findDrawableById("TempValueLabel");
        mTimerTitleLabel = View.findDrawableById("TimerTitleLabel");
        mTimerLeftValueLabel = View.findDrawableById("TimerLeftValueLabel");
        mTimerRightValueLabel = View.findDrawableById("TimerRightValueLabel");
        mLastDiveTimeValueLabel = View.findDrawableById("LastDiveTimeValueLabel");
        mLastDiveDepthValueLabel = View.findDrawableById("LastDiveDepthValueLabel");
        mDiveCountValueLabel = View.findDrawableById("DiveCountValueLabel");
    }

    // Update the view
    function onUpdate(dc) {
        // System.println("RestView.onUpdate() called");

        // Update fields if running
        if (mController.isRunning()) {
            // Update timer title
            var lapType = mController.getLapType();
            var timerTitleString;
            if (lapType == LAP_TYPE_REST) {
                timerTitleString = Rez.Strings.RestTimeTitle;
            } else {
                timerTitleString = Rez.Strings.DiveTimeTitle;
            }
            mTimerTitleLabel.setText(timerTitleString);

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

            // Update last dive time
            var lastDiveTime = mController.getLastDiveTime() / 1000;
            var lastDiveTimeMinutes = lastDiveTime / 60;
            var lastDiveTimeSeconds = lastDiveTime % 60;
            var lastDiveTimeValueString = Lang.format("$1$:$2$", [lastDiveTimeMinutes.format("%d"), lastDiveTimeSeconds.format("%02d")]);
            mLastDiveTimeValueLabel.setText(lastDiveTimeValueString);

            // Update last dive depth
            var lastDiveDepth = mController.getLastDiveDepth();
            var lastDiveDepthValueString = lastDiveDepth.format("%.1f");
            mLastDiveDepthValueLabel.setText(lastDiveDepthValueString);

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
