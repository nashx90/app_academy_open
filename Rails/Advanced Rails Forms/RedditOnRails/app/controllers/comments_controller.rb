class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :ensure_logged_in, except: [:show]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    if params[:comment_id]
      @parent_comment = Comment.friendly.find(params[:comment_id])
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    if params[:comment_id]
      parent_comment = Comment.friendly.find(params[:comment_id])
      parent_post = parent_comment.post
      @comment.parent_comment = parent_comment
      @comment.post = parent_post
    elsif params[:post_id]
      parent_post = Post.friendly.find(params[:post_id])
      @comment.post = parent_post
    end
    if @comment.save
      flash[:notice] = "Comment successfully posted!"
      redirect_to @comment.post
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to @comment.post
    end

  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    flash[:notice] = "Comment successfully deleted!"
    redirect_back(fallback_location: @comment.post)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content)
    end
end
