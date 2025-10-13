class Session < ApplicationRecord
  belongs_to :user
  belongs_to :patient

  # Enums
  enum session_type: { presencial: 'presencial', online: 'online' }
  enum status: { scheduled: 0, completed: 1, cancelled: 2, no_show: 3 }
  
  # Scopes
  scope :confirmed, -> { where(confirmed: true) }
  scope :pending_confirmation, -> { where(confirmed: false) }

  # Validações
  validates :session_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :session_type, presence: true
  validates :status, presence: true
  validate :end_time_after_start_time
  validate :no_overlapping_sessions

  # Scopes
  scope :by_user, ->(user) { where(user: user) }
  scope :by_date, ->(date) { where(session_date: date) }
  scope :by_date_range, ->(start_date, end_date) { where(session_date: start_date..end_date) }
  scope :scheduled, -> { where(status: :scheduled) }
  scope :completed, -> { where(status: :completed) }

  # Métodos
  def duration_minutes
    return 0 unless start_time && end_time
    
    start_minutes = start_time.hour * 60 + start_time.min
    end_minutes = end_time.hour * 60 + end_time.min
    end_minutes - start_minutes
  end

  def duration_hours
    duration_minutes / 60.0
  end

  def formatted_duration
    hours = duration_minutes / 60
    minutes = duration_minutes % 60
    
    if hours > 0 && minutes > 0
      "#{hours}h #{minutes}min"
    elsif hours > 0
      "#{hours}h"
    else
      "#{minutes}min"
    end
  end

  def display_time_range
    "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
  end

  def can_be_edited?
    scheduled? && session_date >= Date.current
  end

  def can_be_cancelled?
    scheduled? && session_date >= Date.current
  end

  def confirm!
    update!(confirmed: true)
  end

  def unconfirm!
    update!(confirmed: false)
  end

  def confirmation_status
    confirmed? ? 'Confirmada' : 'Pendente'
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time

    if end_time <= start_time
      errors.add(:end_time, 'deve ser posterior ao horário de início')
    end
  end

  def no_overlapping_sessions
    return unless session_date && start_time && end_time

    overlapping = Session.where(user: user)
                        .where(session_date: session_date)
                        .where.not(id: id)
                        .where(
                          '(start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?) OR (start_time >= ? AND end_time <= ?)',
                          end_time, start_time,
                          end_time, start_time,
                          start_time, end_time
                        )

    if overlapping.exists?
      errors.add(:base, 'Já existe uma sessão agendada neste horário')
    end
  end
end
