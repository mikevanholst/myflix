class VideoDecorator < Draper::Decorator

  delegate_all

  def average_rating
    if object.reviews.any?
      review_count = reviews.count
      scores_array = object.reviews.each.map(&:rating)

      total_score = scores_array.inject(:+)
      mean_score = total_score.to_f / review_count
      return mean_score.round(1)
    else
      "N/A"
    end
  end
end
