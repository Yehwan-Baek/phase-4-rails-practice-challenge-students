class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        students = Student.all
        render json: students, include: 'instructor'
    end

    def show
        studnet = find_student
        render json: students, include: 'instructor'
    end

    def create
        student = Student.create!(student_params)
        render json: student, status: created
    end

    def update
        student = find_student
        if student.update(student_params)
            render json: student
        else
            render json: { errors: instructor.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        student = find_student
        student.destroy
        head :no_content
    end

    private
    def find_student
        Student.find(params[:id])
    end

    def student_params
        params.permit(:name, :major, :age)
    end

    def render_not_found_response
        render json: { error: "Camper not found" }, status: :not_found
    end
    
    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
