package com.example.minder;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ToggleButton;

import com.parse.GetCallback;
import com.parse.ParseACL;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

public class DetailActivity extends Activity{

	private EditText _quote;
	private EditText _author;
	private Button _saveButton;
	private Button _cancelButton;
	private ToggleButton _shareButton;
	private Boolean _shared;
	private Intent _intent;
	private String _objectId;
	private ParseUser _currentUser;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.detail_activity);

		_currentUser = ParseUser.getCurrentUser();



		_quote = (EditText)findViewById(R.id.quote);
		_author  = (EditText)findViewById(R.id.author);


		_intent = getIntent();

		_objectId = _intent.getStringExtra("objectId");
		Log.i("ID", _objectId);
		_quote.setText(_intent.getStringExtra("quote"));
		_author.setText(_intent.getStringExtra("author"));





		_shareButton = (ToggleButton) findViewById(R.id.shareButton);

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

		_saveButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Log.i("Detail is HIT", "BOYAKAH");
				ParseQuery<ParseObject> query = ParseQuery.getQuery("Quote");
				query.getInBackground(_objectId, new GetCallback<ParseObject>() {
					public void done(ParseObject quoteObject, ParseException e) {
						if (e == null) {
							ParseACL postACL = new ParseACL(ParseUser.getCurrentUser());
							if (_shareButton.isChecked()) {
								postACL.setPublicReadAccess(true);	
								postACL.setPublicWriteAccess(true);
							} else {
								postACL.setPublicReadAccess(false);	
								postACL.setPublicWriteAccess(false);
							}
							quoteObject.setACL(postACL);
							quoteObject.put("quote", _quote.getText().toString());
							quoteObject.put("author", _author.getText().toString());
							quoteObject.saveEventually();
							finish();
						} else {
							Log.i("SAVE ERROR", e.getLocalizedMessage());
						}
					}
				});

			}
		});


		_cancelButton = (Button)findViewById(R.id.cancelButton);
		_cancelButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});

		
		// UI elements 
		_quote.setFocusableInTouchMode(false);
		_author.setFocusableInTouchMode(false);
		 
		Log.i("USER NAME", _currentUser.getUsername()); 
		Log.i("INTENT STRING", _intent.getStringExtra("username"));
		

		if (_currentUser.getUsername() != _intent.getStringExtra("username")) {
			_shareButton.setVisibility(View.GONE);
			_saveButton.setVisibility(View.GONE);
			_cancelButton.setVisibility(View.GONE);
		} else  {
			
		}



	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.detail, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getItemId() == R.id.action_edit) {
			_quote.setFocusableInTouchMode(true);
			_author.setFocusableInTouchMode(true);
			
			if (_currentUser.getUsername().equals(_intent.getStringExtra("username"))) {
				_shareButton.setVisibility(View.VISIBLE);
				
			} 
			
			_saveButton.setVisibility(View.VISIBLE);
			_cancelButton.setVisibility(View.VISIBLE);
			
 
		} 

		return super.onOptionsItemSelected(item);
	}

}
