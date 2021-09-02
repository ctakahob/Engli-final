class ExamplesController < ApplicationController
  before_action :check_like, only: %i[vote]

  def create
    @example = phrase.examples.new(example_params)
    if @example.save
      flash[:notice] = 'Example created!'
    else
      flash[:danger] = @example.errors.full_messages.to_sentence
    end
    redirect_to phrase_path(phrase)
  end

  def destroy
    example.destroy
    flash[:notice] = 'Example deleted!'
    redirect_back fallback_location: phrase_path(phrase)
  end

  def vote
    if params[:vote] == 'up'
      example.liked_by current_user
    else
      example.disliked_by current_user
    end
    if example.vote_registered?
      example.math_carma(params[:vote], current_user)
      message = params[:vote] == 'up' ? 'Liked your example' : 'Disliked your example'
      example.create_activity key: message, owner: current_user, recipient: example.user
      flash[:notice] = 'you voted'
    else
      flash[:danger] = 'You already voted that post'
    end
    redirect_back fallback_location: phrase_path(phrase)
  end

  private

  def example_params
    params.require(:example).permit(:example, :user_id)
  end

  def phrase
    @phrase ||= Phrase.friendly.find(params[:phrase_id])
  end

  def example
    @example ||= phrase.examples.find(params[:id])
  end

  def check_like
    if example.user == current_user
      redirect_back fallback_location: phrase_path(phrase), alert: 'You cant like or dislike yourself'
    end
  end
end
