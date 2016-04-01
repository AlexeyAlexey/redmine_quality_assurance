class TestCasesController < ApplicationController
  unloadable

  helper :test_cases
  include TestCasesHelper

  before_filter :find_project_by_project_id , :if => proc {|c| params.include?("project_id")}
  before_filter :authorize, :if => proc {|c| params.include?("project_id")}

  before_filter :require_admin, :if => proc {|c| !params.include?("project_id")}

  def index
    @test_cases = TestCase.eager_load(issue: [:project]).where(nil)
    if params["parent_id"].blank?
      @test_cases = @test_cases.where("test_cases.parent_id IS NULL")
    else
      @test_cases = @test_cases.where("test_cases.parent_id = ?", params["parent_id"])
    end
  end

  def new
    @test_case = TestCase.new( {parent_id: params["parent_id"]} )
  end

  def show
    @test_case = TestCase.eager_load(issue: [:project]).where(nil)
    @test_case = @test_case.where("test_cases.id = ?", params["id"])
  end

  def edit
    @test_case = TestCase.find_by_id(params["id"])
  end

  def create
    @test_case = TestCase.create(params["test_case"])
    unless @test_case.errors.any?
      respond_to do |format|
        format.html{redirect_to :back, notice: "Success Updated"}
      end
      return
    else
      respond_to do |format|
        format.html{redirect_to :back, flash: {error: @test_case.errors.full_messages.join(', ')} }
      end
      return
    end
  end

  def update
    @test_case = TestCase.find_by_id(params["id"])
    @test_case.update_attributes(params["test_case"])
    unless @test_case.errors.any?
      respond_to do |format|
        format.html{redirect_to :back, notice: "Success Updated"}
      end
      return
    else
      respond_to do |format|
        format.html{redirect_to :back, flash: {error: @test_case.errors.full_messages.join(', ')} }
      end
      return
    end
  end

  def destroy
    @test_case = TestCase.find_by_id(params["id"])
    @test_case.destroy
    unless @test_case.errors.any?
      respond_to do |format|
        format.html{redirect_to :back, notice: "Success Deleted"}
      end
      return
    else
      respond_to do |format|
        format.html{redirect_to :back, flash: {error: @test_case.errors.full_messages.join(', ')} }
      end
      return
    end
  end

  private 
    # Find project of id params[:project_id]
    def find_project_by_project_id
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
end
