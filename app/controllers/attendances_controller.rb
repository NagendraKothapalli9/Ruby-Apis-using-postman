class AttendancesController < ApplicationController
  before_action :authenticate_request
  before_action :set_attendance, only: [:show, :update]
  
  load_and_authorize_resource
 
  def index
    if current_user.role == "hr"
      @attendances = Attendance.joins(:employee)
                               .where(employees: { department_id: current_user.department_id })
                              .order(created_at: :desc)
    else  
      @attendances = Attendance.all.order(date: :desc)
    end
    render json: @attendances, status: :ok
  end

  def show
    render json: @attendance, status: :ok
  end

  
  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      render json: { message: "Attendance recorded successfully", attendance: @attendance }, status: :created
    else
      render json: { errors: @attendance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @attendance.update(attendance_params)
      render json: { message: "Attendance updated successfully", attendance: @attendance }, status: :ok
    else
      render json: { errors: @attendance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @attendance.employee_id == @current_employee.id || @current_employee.role == "hr"
      @attendance.destroy
      render json: { message: "Leave request deleted successfully" }, status: :ok
    else
      render json: { error: "Permission denied" }, status: :forbidden
    end
  end

  private

  def set_attendance
    @attendance = Attendance.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Attendance record not found" }, status: :not_found
  end

  def attendance_params
    params.permit(:employee_id, :date, :status)
  end


  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JWT.decode(header, Rails.application.secret_key_base)[0]
      @current_employee = Employee.find(decoded['employee_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: "Unauthorized access" }, status: :unauthorized
    end
  end
end