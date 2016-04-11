class EditTestCasesController < ApplicationController
  unloadable
  #include JournalsHelper
  #helper :journals
  include EditTestCasesHelper
  helper :edit_test_cases

  include IssuesHelper
  helper :issues

  before_filter :require_login
  
  #before_filter :find_project_by_project_id
  before_filter :find_test_case
  before_filter :authorize

  before_filter :find_issue_by_issue_id
  before_filter :check_edit_test_cases, only: [:edit, :update]

  
  #def index
  #end

  #def new
  #end

  def edit
    @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
    @edit_allowed = User.current.allowed_to?(:edit_issues, @project)
  end

  #def create
  #end

  #def destroy
  #end

  def update

    @issue.init_journal(User.current)

    issue_attributes = params[:issue]
    #issue_attributes[:notes] = issue_attributes.slice(:notes)
    @issue.safe_attributes = issue_attributes
    @issue.save
  end

  def view_journal
    @journals = @issue.journals.includes(:user, :details).reorder("#{Journal.table_name}.id ASC").all
    @journals.each_with_index {|j,i| j.indice = i+1}
    @journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
    Journal.preload_journals_details_custom_fields(@journals)
    # TODO: use #select! when ruby1.8 support is dropped
    @journals.reject! {|journal| !journal.notes? && journal.visible_details.empty?}
    @journals.reverse! if User.current.wants_comments_in_reverse_order?

    respond_to do |format|
      format.html{render :view_journal}
      format.js{render :view_journal}
      
    end
  end

  
  private

    def find_issue_by_issue_id
        @issue = @test_case.issue
        raise Unauthorized unless @issue.visible?
      rescue ActiveRecord::RecordNotFound
        render_404
    end
    
    def check_edit_test_cases
      unless User.current.allowed_to?(:edit_issues, @issue.project)
        render_404
        #render_error :message => 'You can not edit issue', :status => 403
        #return false
      end
    end

    def find_test_case
      #roots
      #@test_case_parent = @project.test_cases.where("test_cases.id = ?", params["parent_id"]).first
      #render_404 if @test_case_parent.nil? and !@test_case_parent.root.nil?
      begin
        @test_case = TestCase.find(params[:test_case_id])
      rescue ActiveRecord::RecordNotFound
        render_404
      end 
      @project = @test_case.root.projects.find{|project|  "#{project.identifier}" == params["project_id"]}

       
    end
end
