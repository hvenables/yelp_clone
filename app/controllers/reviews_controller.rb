class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.new(review_params)
    @review.user_id = current_user.id
    unless @review.save
      flash[:notice] = 'You have already reviewed this restaurant'
    end
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

  # def build_review(review_params, current_user)
  #   review = self.reviews.create(review_params)
  #   review.user_id = current_user.id
  #   review.save
  # end



end
