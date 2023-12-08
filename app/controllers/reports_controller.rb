# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      update_mentions(mentioning_id_list)
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      update_mentions(mentioning_id_list)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    update_mentions(mentioning_id_list)

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def update_mentions(id_list)
    old_id_list = @report.mentioning_relations.map(&:mentioned_id)
    list_to_create = id_list.difference(old_id_list)
    list_to_delete = old_id_list.difference(id_list)

    create_mentions(list_to_create) unless list_to_create.empty?
    delete_mentions(list_to_delete) unless list_to_delete.empty?
  end

  def create_mentions(id_list)
    id_list.each do |id|
      mention = @report.mentioning_relations.build(mentioned_id: id)
      mention.save
    end
  end

  def delete_mentions(id_list)
    id_list.each do |id|
      mention = @report.mentioning_relations.find_by(mentioned_id: id)
      mention.delete
    end
  end

  # 言及した日報のidリスト
  def mentioning_id_list
    paths = URI.extract(@report.content, %w[http https])
    return [] if paths == []

    paths.select { |path| path.match?(('127.0.0.1:3000' && %r{reports/(\d+)})) }.map do |path|
      match = path.match(%r{reports/(\d+)})
      match[1].to_i
    end.uniq
  end

  # def create_mentions(id_list = [])
  #   old_id_list = @report.mentioning_relations.map(&:mentioned_id)
  #   mentions_to_create = id_list.difference(old_id_list)
  #   return if mentions_to_create.empty?

  #   mentions_to_create.each do |id|
  #     mention = @report.mentioning_relations.build(mentioned_id: id)
  #     mention.save
  #   end
  # end

  # def delete_mentions(id_list = [])
  #   old_id_list = @report.mentioning_relations.map(&:mentioned_id)
  #   mentions_to_delete = old_id_list.difference(id_list)
  #   return if mentions_to_delete.empty?

  #   mentions_to_delete.each do |id|
  #     mention = @report.mentioning_relations.find_by(mentioned_id: id)
  #     mention.delete
  #   end
  # end
end
