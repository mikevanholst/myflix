page.replace_html :reviews_count, pluralize(@review.product.reviews.size, 'Review')

page.insert_html :bottom, :reviews, :partial => 'review', :object => @review
page.replace_html :reviews_count, pluralize(@review.product.reviews.size, 'Review')
page[:review_form].reset
page.replace_html :notice, flash[:notice]
flash.discard