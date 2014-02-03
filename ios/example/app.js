// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
win.open();

// TODO: write your module tests here
var CEStripeIOS = require('co.coolelephant.stripe');

var stripeView = CEStripeIOS.createView({
	top: 40,
	width: Ti.UI.FILL,
	height: Ti.UI.FILL,
	paymentKey: '<YOUR PUBLISHABLE KEY>' //Required: Stripe PublishableKey, set based on test/live
});

stripeView.addEventListener('error', function(e){

	Ti.API.debug('error: ', e.value);
	
});
stripeView.addEventListener('receivedToken', function(e){

	Ti.API.debug('receivedToken: ', e.value);
	getTokenButton.enabled = true;
	
});
stripeView.addEventListener('cardIsValid', function(e){

	Ti.API.debug('cardIsValid: ', e.value);
	getTokenButton.enabled = e.value;
	
});

//Add a button to get the token
var getTokenButton = Ti.UI.createButton({
	width: 150, 
	height: 100,
	title: 'GET TOKEN',
	enabled: false
});
stripeView.add(getTokenButton);

getTokenButton.addEventListener('click', function(e){
	getTokenButton.enabled = false;
	
	stripeView.createToken();
});


win.add(stripeView);

