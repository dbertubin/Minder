package com.example.minder;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.ListView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseInstallation;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQuery.CachePolicy;
import com.parse.ParseQueryAdapter;
import com.parse.ParseUser;
import com.parse.PushService;

public class MainActivity extends Activity {

	ListView _listView;
	Context _context;
	ArrayList<String> _quotes = new ArrayList<String>();
	CustomParseQueryAdapter _adapter;
	ParseQuery<ParseObject> _query;
	Boolean _connected;
	Timer _timer;
	int _oldCount;
	int _position;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		
	
		Timer showTimer = new Timer();
		showTimer.schedule(new TimerTask() {			
			@Override
			public void run() {
				TimerMethod();
			}
			
		}, 0, 3000);
	
		
		
		
//		PushService.setDefaultPushCallback(this, MainActivity.class);
//		ParseInstallation installation = ParseInstallation.getCurrentInstallation();
//		installation.put("user",ParseUser.getCurrentUser());
//		installation.saveInBackground();
//		PushService.subscribe(MainActivity.this, "updates", MainActivity.class);
		
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
						 _query.setCachePolicy(CachePolicy.NETWORK_ELSE_CACHE);
						 try {
							_oldCount = _query.count();
						} catch (ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
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
				showDetail.putExtra("objectId", quote.getObjectId());	
				showDetail.putExtra("username", quote.getString("username"));
				startActivity(showDetail);
			}
		});
		
		_listView.setOnItemLongClickListener(new OnItemLongClickListener() {

			@Override
			public boolean onItemLongClick(AdapterView<?> arg0, View arg1,
					int position, long arg3) {
				
				_position = position;
				
				AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(
						MainActivity.this);
		 
					// set title
					alertDialogBuilder.setTitle("Whoa!");
		 
					// set dialog message
					alertDialogBuilder
						.setMessage("Do you really want to delete?")
						.setCancelable(false)
						.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,int id) {
								// if this button is clicked, close
								// current activity
								ParseObject quote = _adapter.getItem(_position);
								quote.deleteEventually();
								dialog.cancel();
							}
						  })
						.setNegativeButton("No",new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,int id) {
								// if this button is clicked, just close
								// the dialog box and do nothing
								dialog.cancel();
							}
						});
				
					AlertDialog alertDialog = alertDialogBuilder.create();
					
					alertDialog.show();
			
				return false;
			}
		});
		
	}

	
	private void TimerMethod()
	{
		
	    this.runOnUiThread(Timer_Tick);
	}

	private Runnable Timer_Tick = new Runnable() {
	    public void run() {

	    	ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Quote");
	    	try {
				if (_oldCount < query.count()) {
					showData();
				} else {
					// do nothingd
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    }  
	};
	
	
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		showData();

	}
	
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();

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
