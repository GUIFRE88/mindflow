class AgendaController < ApplicationController
  before_action :authenticate_user!

  def index
    # Pega a data atual ou a data passada por parâmetro
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.current
    
    # Calcula o início da semana (domingo)
    @week_start = @current_date.beginning_of_week
    
    # Gera os dias da semana
    @week_days = (0..6).map { |i| @week_start + i.days }
    
    # Gera os horários (01:00 às 00:00 - 24 horas)
    @time_slots = (1..23).map { |hour| Time.zone.parse("#{hour}:00") } + [Time.zone.parse("00:00")]
    
    # Dados fictícios de sessões (substituir por dados reais depois)
    @sessions = [
      {
        id: 1,
        patient_name: "Ana Costa",
        session_type: "online",
        date: @week_days[1], # Segunda-feira
        time: Time.zone.parse("14:00"),
        status: "confirmed"
      },
      {
        id: 2,
        patient_name: "Maria Oliveira", 
        session_type: "online",
        date: @week_days[2], # Terça-feira
        time: Time.zone.parse("10:00"),
        status: "confirmed"
      },
      {
        id: 3,
        patient_name: "Carla Mendes",
        session_type: "online", 
        date: @week_days[4], # Quinta-feira
        time: Time.zone.parse("9:00"),
        status: "confirmed"
      },
      {
        id: 4,
        patient_name: "João Silva",
        session_type: "presencial",
        date: @week_days[0], # Domingo
        time: Time.zone.parse("2:00"),
        status: "confirmed"
      },
      {
        id: 5,
        patient_name: "Pedro Santos",
        session_type: "online",
        date: @week_days[6], # Sábado
        time: Time.zone.parse("23:00"),
        status: "confirmed"
      }
    ]
  end

  private

  def session_params
    params.require(:session).permit(:patient_name, :session_type, :date, :time, :status)
  end
end
