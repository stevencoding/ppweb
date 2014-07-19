class IssuesController < ApplicationController
  def index
    @issues = Issue.recent
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def new
    @issue = Issue.new
  end

  def update
    issue = Issue.find(params[:id])
    issue.update_attributes(params[:issue])
    issue.save!
    redirect_to issue_path(issue)
  end

  def create
    issue = Issue.new(params[:issue])
    title = params[:issue][:title]
    issue.user_id = current_user.id if current_user
    if issue.save
      redirect_to issue_path(issue)
    else
      render "new"
    end
  end
end
