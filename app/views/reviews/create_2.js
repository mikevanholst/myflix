
$("#new_review").hide();

$("#reviews_count").html("<%= pluralize(@review.product.reviews.count, 'Review') %>");

$("#new_review").before('<div id="flash_notice"><%= escape_javascript(flash.delete(:notice)) %></div>');

$("#reviews").append("<%= escape_javascript(render(partial: 'reviews/display_review', review: review)) %>");
