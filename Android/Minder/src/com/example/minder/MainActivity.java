package com.example.minder;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.parse.Parse;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;
import com.parse.ParseUser;

public class MainActivity extends Activity {

	private static final int REQUEST_CODE = 0;
	ListView _listView;
	Context _context;
	ArrayList<String> _quotes = new ArrayList<String>();
	CustomParseQueryAdapter _adapter;
	ParseQuery<ParseObject> _query;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Parse.initialize(this, "CzPCqiJgXVlhAV9gCBdOMHvDtpUX4Hn0P83mH4Gh", "dSylRqP3qvFfyTZfuEG6unKc5Sj5DuRtKjkCvLjD");


		// Check to see if user is logged in .. if they are then display if not show LoginOrSignUp ... 
		ParseUser currentUser = ParseUser.getCurrentUser();
		if (currentUser == null) {

			startActivity(new Intent(MainActivity.this, LoginOrSignUpActivity.class));

		} else {

			showData();
		}
	}

	private void showData() {
		setContentView(R.layout.activity_main);
		_adapter = new CustomParseQueryAdapter(this, new ParseQueryAdapter.QueryFactory<ParseObject>() {
					public ParseQuery<ParseObject> create() {
						// Here we can configure a ParseQuery to our heart's desire.
						_query = new ParseQuery<ParseObject>("Quote");
						// This sorts by time updated so if a user updates it will push to the top .. this does not happen 
						// in IOS yet
						_query.addDescendingOrder("updatedAt");
						return _query;
					}
				});

		_listView = (ListView) findViewById(R.id.listView);
		_listView.setAdapter(_adapter);
		
		_listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int position,
					long arg3) {
				// TODO Auto-generated method stub
				Intent showDetail = new Intent(MainActivity.this, DetailActivity.class);
				ParseObject quote = _adapter.getItem(position);
				showDetail.putExtra("username", quote.getString("username"));
				showDetail.putExtra("quote", quote.getString("quote"));
				showDetail.putExtra("author", quote.getString("author"));
				showDetail.putExtra("objectId", quote.getString("objectId"));	
				showDetail.putExtra("username", quote.getString("username"));
				startActivity(showDetail);
			}
		});
		
	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		showData();
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
