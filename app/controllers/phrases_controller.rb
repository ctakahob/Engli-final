class PhrasesController < ApplicationController
  before_action :check_user, only: %i[edit update destroy]
  before_action :check_user_before_example_deletion, only: %i[:delete_example]
  before_action :self_check, only: :like

  def new
    @phrase = Phrase.new
    @phrase.examples.new(user: current_user)
  end

  def create
    @phrase = current_user.phrases.new(phrase_params)
    if @phrase.save
      flash[:notice] = 'Phrase has been created'
      redirect_to phrases_path
    else
      flash[:danger] = @phrase.errors.full_messages.to_sentence
      render :new
    end
  end

  def index
    @phrases = Phrase.order(created_at: 'desc').paginate(page: params[:page])
  end

  def update
    if phrase.update(phrase_params)
      flash[:notice] = 'Phrase has been updated!'
      redirect_to user_path(phrase.user)
    else
      flash[:danger] = 'Phrase can`t be updated'
      render :edit
    end
  end

  def show
    @examples = phrase.examples.includes(:user).paginate(page: params[:page])
    @example = phrase.examples.build(user_id: current_user.id)
  end

  def destroy
    phrase.destroy
    flash[:notice] = 'Phrase has been deleted'
    redirect_back fallback_location: user_path(phrase.user)
  end

  def like
    if params[:like] == 'up'
      phrase.liked_by current_user
    else
      phrase.disliked_by current_user
    end

    if phrase.vote_registered?
      phrase.make_carma(params[:like], current_user)
      message = params[:like] == 'up' ? 'Liked your phrase' : 'Disliked your phrase'
      phrase.create_activity key: message, owner: current_user, recipient: phrase.user
      flash[:notice] = 'you voted!'
    else
      flash[:danger] = 'You already voted that phrase'
    end
    redirect_back fallback_location: root_path
  end

  private

  def phrase
    @phrase ||= Phrase.friendly.find(params[:id])
  end

  def phrase_params
    params.require(:phrase).permit(:phrase, :translation, :category, examples_attributes: %i[example user_id _destroy])
  end

  def check_user
    redirect_to root_path, alert: 'You dont author' unless phrase.author? current_user
  end

  def self_check
    if phrase.user == current_user
      redirect_back fallback_location: root_path, alert: 'You cant like or dislike yourself'
    end
  end
end
