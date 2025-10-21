class PatientRepository
  def initialize(user)
    @user = user
  end

  def all
    @user.patients.includes(:user)
  end

  def find(id)
    @user.patients.find(id)
  end

  def find_patient(id)
    Patient.find(id)
  end

  def search(query)
    return all if query.blank?
    
    all.where("name ILIKE ? OR email ILIKE ?", 
              "%#{query}%", "%#{query}%")
  end

  def filter_by_status(status)
    return all if status.blank?
    
    all.where(status: status)
  end

  def search_and_filter(search_query, status)
    patients = all
    
    patients = search(search_query) if search_query.present?
    patients = filter_by_status(status) if status.present?
    
    patients.order(:name)
  end

  def create(attributes)
    @user.patients.build(attributes)
  end

  def update(patient, attributes)
    patient.update(attributes)
  end

  def destroy(patient)
    patient.destroy
  end

  def active_count
    @user.patients.active.count
  end

  def total_count
    @user.patients.count
  end

  private

  attr_reader :user
end
