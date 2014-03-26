package com.example.minder;


import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ToggleButton;

import com.parse.ParseACL;
import com.parse.ParseObject;
import com.parse.ParsePush;
import com.parse.ParseUser;

public class AddNewQuoteActivity extends Activity {

	private EditText quote;
	private EditText author;
	private Button saveButton;
	private Button cancelButton;
	private ToggleButton shareButton;
	Boolean shared;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.detail_activity);

		quote = (EditText)findViewById(R.id.quote);
		author  = (EditText)findViewById(R.id.author);

		shareButton = (ToggleButton) findViewById(R.id.shareButton);
		shareButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				if (isChecked) {
					shared = true; 
				} else {
					shared = false; 
				}
			}
		});

		saveButton = (Button)findViewById(R.id.saveButton);
		saveButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				ParseObject quoteObject = new ParseObject("Quote");
				ParseACL quoteACL = new ParseACL(ParseUser.getCurrentUser());
				if (shareButton.isChecked()) {
					quoteACL.setPublicReadAccess(true);	
					quoteACL.setPublicWriteAccess(true);
				} else {
				
					quoteACL.setPublicReadAccess(false);	
					quoteACL.setPublicWriteAccess(false);
				}
				quoteObject.setACL(quoteACL);
				quoteObject.put("quote", quote.getText().toString());
				quoteObject.put("author", author.getText().toString());
				quoteObject.put("fromUser", ParseUser.getCurrentUser());
				quoteObject.put("username", ParseUser.getCurrentUser().get("username"));
				quoteObject.saveEventually();
				
				
				ParsePush push = new ParsePush();
				String message = quote.getText().toString();
				push.setChannel("updates");
				push.setMessage(message);
				push.sendInBackground();
				
				
				finish();
			}
		});


		cancelButton = (Button)findViewById(R.id.cancelButton);
		cancelButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				  finish();
			}
		});
	}

}
