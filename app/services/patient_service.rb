class PatientService
  def initialize(user)
    @user = user
    @repository = PatientRepository.new(user)
  end

  def list_patients(search_query: nil, status: nil)
    @repository.search_and_filter(search_query, status)
  end

  def find_patient(id)
    @repository.find_patient(id)
  end

  def create_patient(attributes)
    patient = @repository.create(attributes)
    
    if patient.save
      { success: true, patient: patient, message: 'Paciente criado com sucesso!' }
    else
      { success: false, patient: patient, errors: patient.errors.full_messages }
    end
  end

  def update_patient(patient, attributes)
    if @repository.update(patient, attributes)
      { success: true, patient: patient, message: 'Paciente atualizado com sucesso!' }
    else
      { success: false, patient: patient, errors: patient.errors.full_messages }
    end
  end

  def delete_patient(patient)
    if @repository.destroy(patient)
      { success: true, message: 'Paciente removido com sucesso!' }
    else
      { success: false, errors: ['Erro ao remover paciente'] }
    end
  end

  def patient_statistics
    {
      total: @repository.total_count,
      active: @repository.active_count,
      closed: @repository.total_count - @repository.active_count
    }
  end

  private

  attr_reader :user, :repository
end
