# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user

    if @comment.save

      flash[:notice] = 'Comment has been made!'
    else

      flash[:alert] = 'No comment has made ( Comment body cannot be blank)'

    end
    redirect_to post_path(@post)
  end

  def update
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_url(@post), notice: 'Comment has been updated.' }
      else
        format.html { redirect_to post_url(@post), alert: 'Comment could not be updated.' }
      end
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
