package com.example.minder;

import android.app.Application;

import com.parse.Parse;

public class MinderApplication extends Application {

	public void onCreate() {
		  Parse.initialize(this, "CPiLmo26xJ7gbZF6SrmNN9heZcXGyLkTOcu5QStw", "tKczmTHzK3s2S4dDp8valehdT6teSBdOv9E93rzy");
		}
	
	
}
