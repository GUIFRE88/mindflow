class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  def index
    @patients = current_user.patients.includes(:user)
    
    # Filtro por busca
    if params[:search].present?
      @patients = @patients.where("name ILIKE ? OR email ILIKE ?", 
                                 "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    # Filtro por status
    if params[:status].present?
      @patients = @patients.where(status: params[:status])
    end
    
    @patients = @patients.order(:name)
  end

  def show
  end

  def new
    @patient = current_user.patients.build
  end

  def create
    @patient = current_user.patients.build(patient_params)
    
    if @patient.save
      redirect_to patients_path, notice: 'Paciente criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: 'Paciente atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_path, notice: 'Paciente removido com sucesso!'
  end

  private

  def set_patient
    @patient = current_user.patients.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:name, :email, :phone, :birth_date, :notes, :status)
  end
end
