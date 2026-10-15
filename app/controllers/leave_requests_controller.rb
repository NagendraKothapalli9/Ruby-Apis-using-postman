class LeaveRequestsController < ApplicationController
  before_action :authenticate_request
  before_action :set_leave_request, only: [:show, :update, :destroy]
  load_and_authorize_resource
  
 def index
  if current_user.role == "hr"
    @leave_requests = LeaveRequest.joins(:employee).where(employees: { department_id: current_user.department_id })
     .order(created_at: :desc)
  else
    @leave_requests = LeaveRequest.all
  end
  render json: @leave_requests
 end
  def show
    render json: @leave_request, status: :ok
  end

  
  def create
    @leave_request = @current_employee.leave_requests.new(leave_request_params)
    @leave_request.status = "pending" 

    if @leave_request.save
      render json: { message: "Leave request submitted successfully", leave_request: @leave_request }, status: :created
    else
      render json: { errors: @leave_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  
  def update
    
    if @current_employee.role == "hr" 
      if @leave_request.update(leave_request_params)
        render json: { message: "Leave request updated successfully", leave_request: @leave_request }, status: :ok
      else
        render json: { errors: @leave_request.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Permission denied. Only HR can update leave status." }, status: :forbidden
    end
  end

  def destroy
    if @leave_request.employee_id == @current_employee.id || @current_employee.role == "hr"
      @leave_request.destroy
      render json: { message: "Leave request deleted successfully" }, status: :ok
    else
      render json: { error: "Permission denied" }, status: :forbidden
    end
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Leave request not found" }, status: :not_found
  end

  def leave_request_params
    params.permit(:start_date, :end_date, :reason, :status)
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