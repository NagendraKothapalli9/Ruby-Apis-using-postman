class RegistrationsController < ApplicationController
  def create
    employee = Employee.new(employee_params)
    
    employee.role ||= "hr" 

    if employee.save
      render json: { message: "HR registered successfully", employee: employee }, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def employee_params
   params.permit(:name, :email, :password, :password_confirmation, :department_id, :role)
  end
end
