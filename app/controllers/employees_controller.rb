class EmployeesController < ApplicationController
  before_action :authenticate_request
  before_action :set_employee, only: [:show, :update, :destroy]
   
  load_and_authorize_resource
  

  def index
   
    if current_user.role == "hr" 
      @employees = Employee.where(department_id: current_user.department_id) .order(created_at: :desc)
    else
      @employees = Employee.all
    end
    render json: @employees
  end

  def show
    render json: @employee, status: :ok
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: { message: "Employee created successfully", employee: @employee }, status: :created
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      render json: { message: "Employee updated successfully", employee: @employee }, status: :ok
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    render json: { message: "Employee deleted successfully" }, status: :ok
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Employee not found" }, status: :not_found
  end

  def employee_params
      params.permit(:name, :email, :password, :password_confirmation, :department_id, :role)
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