class Video < ActiveRecord::Base

  belongs_to :category
  has_many :reviews, -> {order("created_at DESC")}, dependent: :destroy
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of  :title, :description

 def self.search_by_title(search_term)
  where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    if self.reviews.any?
      review_count = reviews.count
      scores_array = self.reviews.each.map(&:rating)

      total_score = scores_array.inject(:+)
      mean_score = total_score.to_f / review_count
      return mean_score.round(1)
    else
      "N/A"
    end
  end

  #UNIMPLEMENTED FEATURE
  # def self.search_by_title(search_term)
  #   search_array = []
  #   results_hash = {}
  #   length = search_term.length

  #   #gets matches
  #   matches = Video.where("title LIKE ?", "%#{search_term}%")

  #   #sorts matches by precision
  #   matches.each do |video|
  #     results_hash.merge( video => video.title.length - length  )
  #   end

  #   results_array = results_hash.sort_by{|k,v| v }
 
  #   results_array.map{|a| a[0] }
  # end


  # def self.search_by_title(search_term)
  #   @nada = [Video.first, Video.last]
      
  # end


end
