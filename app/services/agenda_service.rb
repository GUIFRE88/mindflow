class AgendaService
  def initialize(user)
    @user = user
  end

  def get_week_calendar(date = nil)
    current_date = date ? Date.parse(date.to_s) : Date.current
    week_start = current_date.beginning_of_week
    
    {
      current_date: current_date,
      week_start: week_start,
      week_days: (0..6).map { |i| week_start + i.days },
      time_slots: generate_time_slots,
      sessions: generate_fake_sessions(week_start)
    }
  end

  private

  def generate_time_slots
    # Gera os horários (01:00 às 00:00 - 24 horas)
    (1..23).map { |hour| Time.zone.parse("#{hour}:00") } + [Time.zone.parse("00:00")]
  end

  def generate_fake_sessions(week_start)
    week_days = (0..6).map { |i| week_start + i.days }
    
    [
      {
        id: 1,
        patient_name: "Ana Costa",
        session_type: "online",
        date: week_days[1], # Segunda-feira
        time: Time.zone.parse("14:00"),
        status: "confirmed"
      },
      {
        id: 2,
        patient_name: "Maria Oliveira", 
        session_type: "online",
        date: week_days[2], # Terça-feira
        time: Time.zone.parse("10:00"),
        status: "confirmed"
      },
      {
        id: 3,
        patient_name: "Carla Mendes",
        session_type: "online", 
        date: week_days[4], # Quinta-feira
        time: Time.zone.parse("9:00"),
        status: "confirmed"
      },
      {
        id: 4,
        patient_name: "João Silva",
        session_type: "presencial",
        date: week_days[0], # Domingo
        time: Time.zone.parse("2:00"),
        status: "confirmed"
      },
      {
        id: 5,
        patient_name: "Pedro Santos",
        session_type: "online",
        date: week_days[6], # Sábado
        time: Time.zone.parse("23:00"),
        status: "confirmed"
      }
    ]
  end
end
