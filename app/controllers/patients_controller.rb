class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  before_action :set_patient_service

  def index
    @patients = @patient_service.list_patients(
      search_query: params[:search],
      status: params[:status]
    )
    @statistics = @patient_service.patient_statistics
  end

  def show
  end

  def new
    @patient = current_user.patients.build
  end

  def create
    result = @patient_service.create_patient(patient_params)
    
    if result[:success]
      redirect_to patients_path, notice: result[:message]
    else
      @patient = result[:patient]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    result = @patient_service.update_patient(@patient, patient_params)
    
    if result[:success]
      redirect_to patients_path, notice: result[:message]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = @patient_service.delete_patient(@patient)
    
    if result[:success]
      redirect_to patients_path, notice: result[:message]
    else
      redirect_to patients_path, alert: result[:errors].join(', ')
    end
  end

  private

  def set_patient
    @patient = @patient_service.find_patient(params[:id])
  end

  def set_patient_service
    @patient_service = PatientService.new(current_user)
  end

  def patient_params
    params.require(:patient).permit(:name, :email, :phone, :birth_date, :notes, :status)
  end
end
