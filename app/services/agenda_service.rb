class AgendaService
  def initialize(user)
    @user = user
  end

  def get_week_calendar(date = nil)
    current_date = date ? Date.parse(date.to_s) : Date.current
    week_start = current_date.beginning_of_week
    week_end = current_date.end_of_week
    
    {
      current_date: current_date,
      week_start: week_start,
      week_days: (0..6).map { |i| week_start + i.days },
      time_slots: generate_time_slots,
      sessions: get_sessions_for_week(week_start, week_end)
    }
  end

  def get_sessions_for_date(date)
    @user.sessions
         .includes(:patient)
         .where(session_date: date)
         .order(:start_time)
  end

  def get_available_time_slots(date)
    # Horários disponíveis das 8h às 18h
    available_slots = (8..18).map { |hour| Time.zone.parse("#{hour}:00") }
    
    # Remove horários já ocupados
    occupied_times = @user.sessions
                         .where(session_date: date)
                         .pluck(:start_time, :end_time)
                         .flat_map { |start, end_time| (start.to_i..end_time.to_i).step(1.hour) }
                         .map { |time| Time.zone.at(time) }
    
    available_slots - occupied_times
  end

  private

  def generate_time_slots
    # Gera os horários (01:00 às 00:00 - 24 horas)
    (1..23).map { |hour| Time.zone.parse("#{hour}:00") } + [Time.zone.parse("00:00")]
  end

  def get_sessions_for_week(week_start, week_end)
    @user.sessions
         .includes(:patient)
         .where(session_date: week_start..week_end)
         .map do |session|
           {
             id: session.id,
             patient_name: session.patient.name,
             session_type: session.session_type,
             date: session.session_date,
             time: session.start_time,
             end_time: session.end_time,
             status: session.status,
             notes: session.notes,
             patient_id: session.patient_id,
             confirmed: session.confirmed
           }
         end
  end
end
