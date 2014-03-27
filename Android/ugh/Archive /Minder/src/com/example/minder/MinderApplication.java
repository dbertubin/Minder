package com.example.minder;

import android.app.Application;

import com.parse.Parse;

public class MinderApplication extends Application {

	public void onCreate() {
		  Parse.initialize(this, "CzPCqiJgXVlhAV9gCBdOMHvDtpUX4Hn0P83mH4Gh", "dSylRqP3qvFfyTZfuEG6unKc5Sj5DuRtKjkCvLjD");
		}
	
	
}
