class SearchMessagesController < ApplicationController
  def index
    @search_messages_form = SearchMessagesForm.new(message_params)
    @messages = @search_messages_form.search
  end

  private

  def message_params
    params[:q]&.permit(:body)
  end
end
