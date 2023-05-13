class DiveDelegate extends BaseDelegate {

    function initialize() {
        BaseDelegate.initialize(0);
    }

    // Block start stop button
    function onSelect() {
        return true;
    }

    // Block back button
    function onBack() {
        // // NOTE: uncomment for testing laps
        // if (true) {
        //     toggleTestDepth();
        //     return true;
        // }

        return true;
    }

}
