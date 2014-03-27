package com.example.minder;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import com.parse.LogInCallback;
import com.parse.ParseAnonymousUtils;
import com.parse.ParseException;
import com.parse.ParseUser;

public class LoginOrSignUpActivity extends Activity{

	  @Override
	  protected void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.login_or_signup);

	    // Log in button click handler
	    ((Button) findViewById(R.id.logInButton)).setOnClickListener(new OnClickListener() {
	      public void onClick(View v) {
	        // Starts an intent of the log in activity
	    	  
				Intent intent = new Intent(LoginOrSignUpActivity.this, LoginActivity.class);
				startActivity(intent);
	      }
	    });

	    // Sign up button click handler
	    ((Button) findViewById(R.id.signUpButton)).setOnClickListener(new OnClickListener() {
	      public void onClick(View v) {
	        // Starts an intent for the sign up activity
	        startActivity(new Intent(LoginOrSignUpActivity.this, SignUpActivity.class));
	      }
	    });
	    
	  //SkipButton 
		  ((Button) findViewById(R.id.skipButton)).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				ParseAnonymousUtils.logIn(new LogInCallback() {
					  @Override
					  public void done(ParseUser user, ParseException e) {
					    if (e != null) {
					      Log.d("MyApp", "Anonymous login failed.");
					    } else {
					    	startActivity(new Intent(LoginOrSignUpActivity.this, MainActivity.class));
					    }
					  }
					});// TODO Auto-generated method stub
				
			}
		});
	  }
	  
	  

}
