class TestCasesController < ApplicationController
  unloadable

  helper :test_cases
  include TestCasesHelper

  include IssuesHelper
  helper :issues

  include CustomFieldsHelper
  helper :custom_fields

  before_filter :find_project, only: [:index]
  
  before_filter :find_project_by_project_id, except: [:index] #, :if => proc {|c| params.include?("project_id")}
  before_filter :authorize#, :if => proc {|c| params.include?("project_id")}
  before_filter :find_test_case_parent, only: [:new], :if => proc{|c| params.include?("parent_id")}
  #before_filter :require_admin, :if => proc {|c| !params.include?("project_id")}

  def index
    #visible_issues = Issue.visible.joins(:test_cases).where("test_cases.parent_id IS NULL")
    #  .joins('LEFT OUTER JOIN test_case_projects ON test_cases.id = test_case_projects.test_case_id')
    #  .where("test_case_projects.project_id = ?", @project.id)
    @test_cases = @project.test_cases.eager_load(:issue => [:attachments, :status]).where(nil)
    #if params["parent_id"].blank?
      @test_cases = @test_cases.where("test_cases.parent_id IS NULL")
    #else
    #@test_cases = @test_cases.where("test_cases.parent_id = ?", params["parent_id"])
    #end
    #{ "status_id" => "#color"}
    #@status_colors = Setting.plugin_wiki_redmine_quality_assurance["status_colols"] || {} 
  end

  def new
    #@test_case_parent = @project.test_cases.where("test_cases.id = ?", params["parent_id"]).first
    #@test_case = @test_case_parent.children.new({parent_id: params["parent_id"]})
    @test_case = TestCase.new( {parent_id: params["parent_id"]} )
  end

  def show
    @test_case = @project.test_cases.eager_load(:issue, children: [:issue => [:attachments, :status, :custom_values]]).where("test_cases.id = ?", params["id"]).first
    #@test_case = TestCase.eager_load(issue: [:project]).where(nil)
    #@test_case = @test_case.where("test_cases.id = ?", params["id"])
  end

  def edit
    @test_case = @project.test_cases.where("test_cases.id = ?", params["id"]).first
  end

  def create
    @test_case = @project.test_cases.create(params["test_case"])
    unless @test_case.errors.any?
      respond_to do |format|
        format.html{redirect_to test_cases_path(id: @project.identifier), notice: "Success Updated"}
      end
      return
    else
      respond_to do |format|
        format.html{redirect_to test_cases_path(id: @project.identifier), flash: {error: @test_case.errors.full_messages.join(', ')} }
      end
      return
    end
  end

  def update
    @test_case = @project.test_cases.where("test_cases.id = ?", params["id"]).first
    @test_case.update_attributes(params["test_case"])
    unless @test_case.errors.any?
      respond_to do |format|
        format.html{redirect_to test_cases_path(id: @project.identifier), notice: "Success Updated"}
      end
      return
    else
      respond_to do |format|
        format.html{redirect_to test_cases_path(id: @project.identifier), flash: {error: @test_case.errors.full_messages.join(', ')} }
      end
      return
    end
  end

  def destroy
    @test_case = @project.test_cases.where("test_cases.id = ?", params["id"]).first
    @test_case.destroy
    unless @test_case.errors.any?
      respond_to do |format|
        format.html{redirect_to test_cases_path(id: @project.identifier), notice: "Success Deleted"}
      end
      return
    else
      respond_to do |format|
        format.html{redirect_to test_cases_path(id: @project.identifier), flash: {error: @test_case.errors.full_messages.join(', ')} }
      end
      return
    end
  end

  private 
    def find_test_case_parent
      #roots
      #@test_case_parent = @project.test_cases.where("test_cases.id = ?", params["parent_id"]).first
      #render_404 if @test_case_parent.nil? and !@test_case_parent.root.nil?
      @test_case_parent = TestCase.where("test_cases.id = ?", params["parent_id"]).first

      render_404 if @test_case_parent.nil? 
      render_403 unless @test_case_parent.root.projects.map(&:id).include?(@project.id)

    end
    
end
