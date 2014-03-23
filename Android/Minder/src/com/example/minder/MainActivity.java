package com.example.minder;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.parse.FindCallback;
import com.parse.Parse;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;
import com.parse.ParseUser;

public class MainActivity extends Activity {

	private static final int REQUEST_CODE = 0;
	ListView _listView;
	Context _context;
	ArrayList<String> _quotes = new ArrayList<String>();


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Parse.initialize(this, "CzPCqiJgXVlhAV9gCBdOMHvDtpUX4Hn0P83mH4Gh", "dSylRqP3qvFfyTZfuEG6unKc5Sj5DuRtKjkCvLjD");


		// Check to see if user is logged in .. if they are then display if not show LoginOrSignUp ... 
		ParseUser currentUser = ParseUser.getCurrentUser();
		if (currentUser == null) {

			startActivity(new Intent(MainActivity.this, LoginOrSignUpActivity.class));

		} else {

			setContentView(R.layout.activity_main);



			CustomParseQueryAdapter adapter =
					new CustomParseQueryAdapter(this, new ParseQueryAdapter.QueryFactory<ParseObject>() {
						public ParseQuery<ParseObject> create() {
							// Here we can configure a ParseQuery to our heart's desire.
							ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Quote");
							return query;
						}
					});


			ListView listView = (ListView) findViewById(R.id.listView);
			listView.setAdapter(adapter);

		}

	}


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getItemId() == R.id.action_new) {
			Intent addNew = new Intent(MainActivity.this, AddNewQuoteActivity.class);
			startActivity(addNew);
		} else if (item.getItemId() == R.id.action_logout) {
			ParseUser.logOut();
			
			Intent showLogin = new Intent(MainActivity.this, LoginOrSignUpActivity.class);
			startActivity(showLogin);
			finish();
		}
		
		return super.onOptionsItemSelected(item);
	}
	
}
