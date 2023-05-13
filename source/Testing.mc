import Toybox.Application;

function toggleTestDepth() {
    var mModel = Application.getApp().model;
    if (mModel.getTestDepth() == 1.1) {
        mModel.setTestDepth(0.1);
        return;
    } else {
        mModel.setTestDepth(1.1);
        return;
    }
}
