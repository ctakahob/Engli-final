module SharedMethods
  extend ActiveSupport::Concern

  def is_author?(user)
    self.user == user
  end

  def math_carma(vote, current_user)
    current_user_carma_rating = current_user.carma
    another_user_carma_rating = user.carma
    another_user = user
    votes = vote == 'up' ? self.class::UPVOTE : self.class::DOWNVOTE
    another_user.update_attribute('carma', another_user_carma_rating + votes)
    current_user.update_attribute('carma', current_user_carma_rating + 1)
  end

  def make_carma(like, current_user)
    current_user_carma_rating = current_user.carma
    another_user_carma_rating = user.carma
    another_user = user
    likes = like == 'up' ? self.class::LIKE : self.class::DISLIKE
    another_user.update_attribute('carma', another_user_carma_rating + likes)
    current_user.update_attribute('carma', current_user_carma_rating + 1)
  end
end
