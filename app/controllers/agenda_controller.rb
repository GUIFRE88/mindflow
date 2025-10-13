class AgendaController < ApplicationController
  before_action :authenticate_user!
  before_action :set_agenda_service

  def index
    calendar_data = @agenda_service.get_week_calendar(params[:date])
    
    @current_date = calendar_data[:current_date]
    @week_start = calendar_data[:week_start]
    @week_days = calendar_data[:week_days]
    @time_slots = calendar_data[:time_slots]
    @sessions = calendar_data[:sessions]
  end

  private

  def set_agenda_service
    @agenda_service = AgendaService.new(current_user)
  end

  def session_params
    params.require(:session).permit(:patient_name, :session_type, :date, :time, :status)
  end
end
