package com.example.minder;

import android.app.Application;

import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseUser;

public class MinderApplication extends Application {

	public void onCreate() {	
		  Parse.initialize(this, "CPiLmo26xJ7gbZF6SrmNN9heZcXGyLkTOcu5QStw", "tKczmTHzK3s2S4dDp8valehdT6teSBdOv9E93rzy");
		  
		  
		  
		  
//			ParseACL defaultACL = new ParseACL();
//		    
//			// If you would like all objects to be private by default, remove this line.
//			defaultACL.setPublicReadAccess(true);
//			
//			ParseACL.setDefaultACL(defaultACL, true);
//		  
		  
		}
	
	
}
