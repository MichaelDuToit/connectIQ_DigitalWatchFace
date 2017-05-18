using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

class DigitalWatchFaceView extends Ui.WatchFace {
	var highPowerMode = false;
	
	
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        //Battery
        var battery = Sys.getSystemStats().battery;
        var batteryNum = battery.toNumber();
        var batteryStr = Lang.format("$1$%", [battery.format("%d")]);
        var batteryView = View.findDrawableById("batteryStatus");
        batteryView.setText(batteryStr);
        
        var batteryLow = 20;
        var batteryMedium = 50;
        
        if (batteryNum){
        	if (batteryNum > batteryMedium){
        		batteryView.setColor(Gfx.COLOR_DK_GREEN);
        	}
        	else if (batteryNum <= batteryMedium && batteryNum > batteryLow){
        		batteryView.setColor(Gfx.COLOR_ORANGE);
        	}
        	else if (batteryNum <= batteryLow){
        		batteryView.setColor(Gfx.COLOR_RED);
        	}
        }
        
        //Time-Clock
        var deviceSettings = Sys.getDeviceSettings();
        var userSetting24Hour = deviceSettings.is24Hour;
        var clockTime = Sys.getClockTime();
        var clockHours = clockTime.hour;
        var clockMin = clockTime.min;
        var clockSec = clockTime.sec;
        var mainClockView = View.findDrawableById("clockMain");
        var secondsClockView = View.findDrawableById("clockSeconds");
        
        //12 Hour vs 24 Hour display setting
        var view12Hour = View.findDrawableById("hour12");
        var militaryTime = clockHours;
        if(!userSetting24Hour){
        	if (clockHours > 12){
        		clockHours = clockHours - 12;
        		clockHours = clockHours.format("%02d");
        	}
        	if (militaryTime < 12){
        		view12Hour.setText("AM");
        	}
        	else {
        		view12Hour.setText("PM");
        	}
        	if (clockHours == 0){
        		clockHours = 12;
        	}
        }
        else {
        	clockHours = clockHours.format("%02d");
        }
        	
        var mainClockStr= Lang.format("$1$$2$", [clockHours, clockMin.format("%02d")]);
        mainClockView.setText(mainClockStr);
        
        if (highPowerMode){
        	var secClockStr = Lang.format("$1$", [clockSec.format("%02d")]);
        	secondsClockView.setText(secClockStr);
        	secondsClockView.setColor(Gfx.COLOR_WHITE);
       	}
       	else {
       		secondsClockView.setColor(Gfx.COLOR_TRANSPARENT);
		}
		
		//Date
		var timeNow = Time.now();
		var dateInfo = Time.Gregorian.info(timeNow, Time.FORMAT_LONG);
		var dateView = View.findDrawableById("date");
		dateView.setText(dateInfo.day_of_week + " " + dateInfo.day.format("%02d") + " " + dateInfo.month);
		
		
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	highPowerMode = true;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	highPowerMode = false;
    	Ui.requestUpdate();
    }

}
