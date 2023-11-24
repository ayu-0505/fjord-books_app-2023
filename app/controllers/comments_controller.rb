# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to [@commentable], notice: 'Your comment was successfully posted.'
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to [@commentable], notice: 'Comment was successfully destroyed.'
    else
      render @commentable
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:comment_content)
  end
end
