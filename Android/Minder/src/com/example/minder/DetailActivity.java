package com.example.minder;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ToggleButton;

import com.parse.ParseACL;
import com.parse.ParseObject;
import com.parse.ParseUser;

public class DetailActivity extends Activity{

	private EditText _quote;
	private EditText _author;
	private Button _saveButton;
	private Button _cancelButton;
	private ToggleButton _shareButton;
	private Boolean _shared;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.detail_activity);

		
		
		
		_quote = (EditText)findViewById(R.id.quote);
		_quote.setFocusable(false);
		_author  = (EditText)findViewById(R.id.author);
		_author.setFocusable(false);
		
		Intent intent = getIntent();
		
		_quote.setText(intent.getStringExtra("quote"));
		_author.setText(intent.getStringExtra("author"));
		

		_shareButton = (ToggleButton) findViewById(R.id.shareButton);
		_shareButton.setEnabled(false);
		_shareButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				if (isChecked) {
					_shared = true; 
				} else {
					_shared = false; 
				}
			}
		});

		_saveButton = (Button)findViewById(R.id.saveButton);
		_saveButton.setEnabled(false);
		_saveButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				ParseObject quoteObject = new ParseObject("Quote");
				ParseACL postACL = new ParseACL(ParseUser.getCurrentUser());
				if (_shared == true) {
					postACL.setPublicReadAccess(true);	
					postACL.setPublicWriteAccess(true);
				} else {
					postACL.setPublicReadAccess(false);	
					postACL.setPublicWriteAccess(false);
				}
				quoteObject.setACL(postACL);
				quoteObject.put("quote", _quote.getText().toString());
				quoteObject.put("author", _author.getText().toString());
				quoteObject.put("fromUser", ParseUser.getCurrentUser());
				quoteObject.put("userName", ParseUser.getCurrentUser().toString());
				quoteObject.saveEventually();
				finish();
			}
		});


		_cancelButton = (Button)findViewById(R.id.cancelButton);
		_cancelButton.setEnabled(false);
		_cancelButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				  finish();
			}
		});
	}

}
