package com.example.minder;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.parse.ParseObject;
import com.parse.ParseQueryAdapter;

public class CustomParseQueryAdapter extends ParseQueryAdapter<ParseObject> {

	public CustomParseQueryAdapter(Context context,
			com.parse.ParseQueryAdapter.QueryFactory<ParseObject> queryFactory
			) {
		super(context, queryFactory);
		// TODO Auto-generated constructor stub
	}


	@Override
	public View getItemView(ParseObject object, View v, ViewGroup parent) {
	  if (v == null) {
	    v = View.inflate(getContext(), R.layout.adapter_item, null);
	  }
	 
	  // Take advantage of ParseQueryAdapter's getItemView logic for
	  // populating the main TextView/ImageView.
	  // The IDs in your custom layout must match what ParseQueryAdapter expects
	  // if it will be populating a TextView or ImageView for you.
	  super.getItemView(object, v, parent);
	 
	  // Do additional configuration before returning the View.
	  TextView descriptionView = (TextView) v.findViewById(R.id.username);
	  descriptionView.setText(object.getString("username"));
	  
	  
	  TextView quoteView = (TextView) v.findViewById(R.id.quote);
	  quoteView.setText(object.getString("quote"));
	  return v;
	}
}
