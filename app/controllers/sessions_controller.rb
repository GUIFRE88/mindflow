class SessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patients, only: [:new, :create, :edit, :update]
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  def index
    @sessions = current_user.sessions.includes(:patient).order(session_date: :desc, start_time: :desc)
  end

  def show
  end

  def new
    @session = current_user.sessions.build
    @session.session_date = params[:date] if params[:date]
    @session.start_time = params[:time] if params[:time]
    @session.patient_id = params[:patient_id] if params[:patient_id]
  end

  def create
    @session = current_user.sessions.build(session_params)
    
    if @session.save
      redirect_to agenda_path(date: @session.session_date), notice: 'Sessão criada com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @session.update(session_params)
      redirect_to agenda_path(date: @session.session_date), notice: 'Sessão atualizada com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    session_date = @session.session_date
    @session.destroy
    
    redirect_to agenda_path(date: session_date), notice: 'Sessão removida com sucesso!'
  end

  def confirm
    @session = current_user.sessions.find(params[:id])
    @session.confirm!
    
    redirect_to patient_path(@session.patient), notice: 'Sessão confirmada com sucesso!'
  end

  def unconfirm
    @session = current_user.sessions.find(params[:id])
    @session.unconfirm!
    
    redirect_to patient_path(@session.patient), notice: 'Confirmação removida com sucesso!'
  end

  private

  def set_session
    @session = current_user.sessions.find(params[:id])
  end

  def set_patients
    @patients = current_user.patients.active.order(:name)
  end

  def session_params
    params.require(:session).permit(:patient_id, :session_date, :start_time, :end_time, :session_type, :notes, :status, :confirmed)
  end
end

