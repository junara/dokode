# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show create]

  def show
    @communication = Communication.new
    respond_to do |format|
      format.html
      format.ics do
        headers['Content-Type'] = 'text/calendar; charset=UTF-8'
        render plain: @event.ical and return
      end
    end
  end

  def create
    @communication = Communication.new(event_id: @event.id, body: communication_params[:body])
    if @communication.save
      @communication = Communication.new
      redirect_to event_path(token: @event.token), notice: 'メッセージが送信されました。サイト発展へのご協力ありがとうございました。'
    else
      flash[:danger] = @communication.errors.full_messages
      render action: :show and return
    end
  end

  private

  def communication_params
    params.require(:communication).permit(:body)
  end

  def set_event
    @event = Event.find_by(token: params[:token]).decorate
    @related_events = EventDecorator.decorate_collection(
      Event.where(id: @event.related_events['rank'].map { |related_event| related_event['id'] })
          .includes(:venues)
    )
  end
end
