# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit create update destroy]

  # GET users/{user_id}/reports or /reports.json
  def index
    @reports = Report.order(created_at: 'DESC').includes(:user).all.page(params[:page])
  end

  # GET users/{user_id}/reports/1 or /reports/1.json
  def show; end

  # GET users/{user_id}/reports/new
  def new
    @user = current_user
    @report = Report.new
  end

  # GET users/{user_id}/reports/1/edit
  def edit; end

  # POST users/{user_id}/reports or users/{user_id}/reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to user_report_url(@report.user, @report), notice: t('controllers.common.notice_create', name: Report.model_name.human) }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT users/{user_id}/reports/1 or users/{user_id}/reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to user_report_url(@report.user, @report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(root_url, status: :see_other) unless @user == current_user
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :content).merge(user_id: current_user.id)
  end
end
