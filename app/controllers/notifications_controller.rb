class NotificationsController < ApplicationController
  def index
    @notifications = current_user.public_activities.order(created_at: 'desc').paginate(page: params[:page])
  end

  def read_all
    current_user.public_activities.update(readed: true)
    redirect_to notifications_path
  end

  def destroy
    @activity = current_user.public_activities.find(params[:id]).destroy
    redirect_back fallback_location: notifications_path
    flash[:notice] = 'notification deleted'
  end
end
