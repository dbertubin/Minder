package com.example.minder;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
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

			//			ParseQueryAdapter<ParseObject> adapter = new ParseQueryAdapter<ParseObject>(this, "Quote");
			//			adapter.setTextKey("quote");
			//			//			  adapter.setImageKey("photo");

			ListView listView = (ListView) findViewById(R.id.listView);
			listView.setAdapter(adapter);

		}

	}





	//		_context = this;
	//		_listView = (ListView) findViewById(R.id.listView);
	//		ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(this,android.R.layout.simple_list_item_1, _quotes);
	//		_listView.setAdapter(arrayAdapter); 


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
