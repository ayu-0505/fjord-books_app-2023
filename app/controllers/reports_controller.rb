# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  # GET users/{user_id}/reports or /reports.json
  def index
    @reports = Report.where(user_id: params[:user_id])
  end

  # GET users/{user_id}/reports/1 or /reports/1.json
  def show
    @user = current_user
  end

  # GET users/{user_id}/reports/new
  def new
    @user = User.find(params[:user_id])
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
    @user = current_user
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to user_reports_url(@report), notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to user_reports_url(@report), notice: 'Report was successfully updated.' }
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
      format.html { redirect_to user_reports_url(@report), notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :content).merge(user_id: current_user.id)
  end
end
