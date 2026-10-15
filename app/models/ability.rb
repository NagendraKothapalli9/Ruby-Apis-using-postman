class Ability
  include CanCan::Ability

  def initialize(employee)
    employee ||= Employee.new 

    if employee.role == "hr"
      
      can :manage, :all
    else
      
      can [:read], Attendance, employee_id: employee.id
      can [:read, :create], LeaveRequest, employee_id: employee.id
      can :read, Department
    end
  end
end