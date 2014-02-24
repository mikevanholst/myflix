jQuery(function($) {
  alert("good")
  $('#payment-form').submit(function(event) {
    var $form = $(this);
    $form.find('stripe_submit').prop('disabled', true);
    // $form.find('button').prop('disabled', true);
    Stripe.card.createToken($form, stripeResponseHandler);
     alert("eshould have token");
     console.log("hi");
    return false;
  });
});

var stripeResponseHandler = function(status, response) {
  var $form = $('#payment-form');
  alert("enters form");
  if (response.error) {
    // Show the errors on the form
    $form.find('.payment-errors').text(response.error.message);
    $form.find('stripe_submit').prop('disabled', false);
    // $form.find('button').prop('disabled', false);
     alert("enters form");
  } else {
    // token contains id, last4, and card type

    var token = response.id;
     alert("stripe token present");
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
     alert("hidden element appendedd");
    // and submit
    $form.get(0).submit();
     alert("form submitted");
  }
};