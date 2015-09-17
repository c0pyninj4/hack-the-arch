class ProblemsController < ApplicationController
	before_action :logged_in_user, only: [:index, :destroy, :create, :edit, :update, :new, :remove_hint]
	before_action :admin_user, only: [:destroy, :create, :edit, :update, :new, :remove_hint]
	before_action :belong_to_team, only: [:index]
	before_action :competition_active, only: [:index, :show]
	
	def index
		@problems = Problem.all
		if params[:problem_id]
			debugger
			@problem_view = Problem.find(params[:problem_id])
		end
	end

	def new
		@problem = Problem.new
	end

	def create
		@problem = Problem.new(problem_params)
		if @problem.save
      redirect_to problems_url
		else
			render 'new'
		end
	end

	def remove_hint
		# Hint implements reference counting (i.e., don't worry about it here)
		@problem = Problem.find(params[:problem_id])
		@problem.remove(params[:hint_id])
    flash[:success] = "Hint removed successfully"
    redirect_to edit_problem_path(@problem)
	end

	def destroy
    Problem.find(params[:id]).destroy
    flash[:success] = "Problem deleted"
    redirect_to problems_url
  end

	def edit
		@problem = Problem.find(params[:id])
	end

	def update
		@problem = Problem.find(params[:id])
		if @problem.update_attributes(problem_params)
			flash[:success] = "Changes saved successfully"
			redirect_to @problem
		else
			render 'edit'
		end
	end

	private
		def problem_params
			params.require(:problem).permit(:name, :category, :description, :points, :solution, :correct_message, :false_message)
		end

		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end
		
		def belong_to_team
			unless current_user.team_id
				flash[:danger] = "You must belong to a team to view the problems!"
				redirect_to current_user
			end
		end
		
		def admin_user
      unless logged_in? && current_user.admin?
				store_location
				flash[:danger] = "Access Denied."
				redirect_to root_url
			end
    end

		def competition_active
			start_time = Time.parse(Setting.find_by(name: 'start_time').value)
			end_time = Time.parse(Setting.find_by(name: 'end_time').value)

			unless (start_time < Time.zone.now && Time.zone.now < end_time)
				flash[:danger] = "The competition isn't active!"
				redirect_to root_url
			end
		end
end
