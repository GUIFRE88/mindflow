class Patient < ApplicationRecord
  belongs_to :user
  has_many :sessions, dependent: :destroy

  # Enum para status
  enum status: { active: 0, closed: 1 }

  # Validações
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }, allow_blank: true
  validates :status, presence: true

  # Scopes
  scope :active_patients, -> { where(status: :active) }
  scope :closed_patients, -> { where(status: :closed) }
  scope :by_user, ->(user) { where(user: user) }

  # Métodos
  def age
    return nil unless birth_date
    today = Date.current
    age = today.year - birth_date.year
    age -= 1 if today < birth_date + age.years
    age
  end

  def full_name
    name
  end

  def display_name
    "#{name} (#{age} anos)" if age
  end
end
