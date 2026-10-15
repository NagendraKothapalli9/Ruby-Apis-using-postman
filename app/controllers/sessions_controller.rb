class SessionsController < ApplicationController
  def create
    employee = Employee.find_by(email: params[:email])

    if employee && employee.authenticate(params[:password])
     
      payload = { employee_id: employee.id, exp: 24.hours.from_now.to_i }
      token = JWT.encode(payload, Rails.application.secret_key_base)

      
      render json: { 
        message: "Logged in successfully", 
        token: token, 
        id: employee.id, 
        name: employee.name, 
        email: employee.email, 
        role: employee.role 
        
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end