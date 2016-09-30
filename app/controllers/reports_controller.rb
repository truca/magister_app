class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_course, only: [:create, :new, :show]
  before_action :set_miscursos_visible, only: [:show, :edit, :new]
  before_action :set_ef_visible, only: [:show, :edit]
  before_action :set_reporte_visible, only: [:show, :edit]
  before_action :set_actividades_visible, only: [:show, :edit]
  before_action :set_configuraciones_visible, only: [:show, :edit]
  before_action :set_breadcrumbs

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report.content_sc = nil
    @report.interpretation_sc = nil
    @report.analysis_sc = nil
    @report.evaluation_sc = nil
    @report.inference_sc = nil
    @report.explanation_sc = nil
    @report.selfregulation_sc = nil
    @report.save

    total_trees_content = 0      
    total_trees_interpretation = 0
    total_trees_analysis = 0
    total_trees_evaluation = 0
    total_trees_inference = 0
    total_trees_explanation = 0
    total_trees_selfregulation = 0

    @report.trees.each do |tree| 
      puts "enviando arbooollllllllllllllllllllllllll"
      puts tree.inspect    
      #set_report_values_path([@course, tree], {method: :get, remote: true})
      set_report_values tree
      tree = Tree.find(tree.id)
      
      if tree.content_sc
        total_trees_content = total_trees_content + 1
        if @report.content_sc.nil?
          @report.content_sc = 0
        end

        @report.content_sc = @report.content_sc + tree.content_sc
        puts "valores del reporte anterior más el aporte del nuevo arboooooooo"
        puts @report.content_sc 
        puts tree.content_sc
      end
      if !tree.interpretation_sc.nil?
        total_trees_interpretation = total_trees_interpretation + 1
        if @report.interpretation_sc.nil?
          @report.interpretation_sc = 0
        end
        @report.interpretation_sc += tree.interpretation_sc
      end
      if !tree.analysis_sc.nil?
        total_trees_analysis = total_trees_analysis + 1
        if @report.analysis_sc.nil?
          @report.analysis_sc = 0
        end
       @report.analysis_sc += tree.analysis_sc
      end
      if !tree.evaluation_sc.nil?
        total_trees_evaluation = total_trees_evaluation + 1
        if @report.evaluation_sc.nil?
          @report.evaluation_sc = 0
        end
        @report.evaluation_sc += tree.evaluation_sc
      end
      if !tree.inference_sc.nil?
        total_trees_inference = total_trees_inference + 1
        if @report.inference_sc.nil?
          @report.inference_sc = 0
        end
        @report.inference_sc += tree.inference_sc
      end
      if !tree.explanation_sc.nil?
        total_trees_explanation = total_trees_explanation + 1
        if @report.explanation_sc.nil?
          @report.explanation_sc = 0
        end
        @report.explanation_sc += tree.explanation_sc
      end
      if !tree.selfregulation_sc.nil?
        total_trees_selfregulation = total_trees_selfregulation + 1
        if @report.selfregulation_sc.nil?
          @report.selfregulation_sc = 0
        end
        @report.selfregulation_sc += tree.selfregulation_sc
      end
    end

    if !@report.content_sc.nil?
      puts "valores de contenidooooooooooooooo"
      puts @report.content_sc
      puts total_trees_content
      @report.content_sc = @report.content_sc/total_trees_content
    end
    if !@report.interpretation_sc.nil?
      @report.interpretation_sc = @report.interpretation_sc/total_trees_interpretation
    end
    if !@report.analysis_sc.nil?
       @report.analysis_sc = @report.analysis_sc/total_trees_analysis
    end
    if !@report.evaluation_sc.nil?
      @report.evaluation_sc = @report.evaluation_sc/total_trees_evaluation
    end
    if !@report.inference_sc.nil?
      @report.inference_sc = @report.inference_sc/total_trees_inference
    end
    if  !@report.explanation_sc.nil?
      @report.explanation_sc = @report.explanation_sc/total_trees_explanation
    end
    if !@report.selfregulation_sc.nil?     
      @report.selfregulation_sc = @report.selfregulation_sc/total_trees_explanation
    end

    @report.save
    
  end

  # GET /reports/new
  def new
    @report = Report.new

    puts "new reporrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrt!"
    puts @report.inspect
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create

    puts "creandoooooooooooooooo el reporteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    @report = @course.reports.new(report_params)
    puts params[:tree_ids]
    respond_to do |format|
      if @report.save
          if params[:tree_ids]
              params[:tree_ids].each do |tree_id|
                puts "existen los parametrosssssssssssssssssssssssssssssssss"
                puts tree_id
                @report.trees << Tree.find(tree_id)
              end
          end
          @report.save
          puts @report.trees.inspect          
        format.html { redirect_to @course, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_report_values tree
      puts "llamaroooooooon al report valueeeeeeeeeeeeeeeeeeeeeeeee"
      tree.content_sc = nil
      tree.interpretation_sc = nil
      tree.analysis_sc = nil
      tree.evaluation_sc = nil
      tree.inference_sc = nil
      tree.explanation_sc = nil
      tree.selfregulation_sc = nil
      tree.save

      total_users_content = 0      
      total_users_interpretation = 0
      total_users_analysis = 0
      total_users_evaluation = 0
      total_users_inference = 0
      total_users_explanation = 0
      total_users_selfregulation = 0

      tree.user_tree_performances.each do |performance|        
        if !performance.content_sc.nil?
          total_users_content = total_users_content + 1
          if tree.content_sc.nil?
            tree.content_sc = 0
          end
          tree.content_sc += (performance.content_sc/performance.content_n)
        end
        if !performance.interpretation_sc.nil?
          total_users_interpretation = total_users_interpretation + 1
          if tree.interpretation_sc.nil?
            tree.interpretation_sc = 0
          end
          tree.interpretation_sc += (performance.interpretation_sc/performance.interpretation_n)
        end
        if !performance.analysis_sc.nil?
          total_users_analysis = total_users_analysis + 1
          if tree.analysis_sc.nil?
            tree.analysis_sc = 0
          end
          tree.analysis_sc += (performance.analysis_sc/performance.analysis_n)
        end
        if !performance.evaluation_sc.nil?
          total_users_evaluation = total_users_evaluation + 1
          if tree.evaluation_sc.nil?
            tree.evaluation_sc = 0
          end
          tree.evaluation_sc += (performance.evaluation_sc/performance.evaluation_n)
        end
        if !performance.inference_sc.nil?
          total_users_inference = total_users_inference + 1
          if tree.inference_sc.nil?
            tree.inference_sc = 0
          end
          tree.inference_sc += (performance.inference_sc/performance.inference_n)
        end
        if !performance.explanation_sc.nil?
          total_users_explanation = total_users_explanation + 1
          if tree.explanation_sc.nil?
            tree.explanation_sc = 0
          end
          tree.explanation_sc += (performance.explanation_sc/performance.explanation_n)
        end
        if !performance.selfregulation_sc.nil?
          total_users_selfregulation = total_users_selfregulation + 1
          if tree.selfregulation_sc.nil?
            tree.selfregulation_sc = 0
          end
          tree.selfregulation_sc += (performance.selfregulation_sc/performance.selfregulation_n)
        end
      end

      if !tree.content_sc.nil?
        tree.content_sc = tree.content_sc/total_users_content
      end
      if !tree.interpretation_sc.nil?
        tree.interpretation_sc = tree.interpretation_sc/total_users_interpretation
      end
      if !tree.analysis_sc.nil?
         tree.analysis_sc = tree.analysis_sc/total_users_analysis
      end
      if !tree.evaluation_sc.nil?
        tree.evaluation_sc = tree.evaluation_sc/total_users_evaluation
      end
      if !tree.inference_sc.nil?
        tree.inference_sc = tree.inference_sc/total_users_inference
      end
      if  !tree.explanation_sc.nil?
        tree.explanation_sc = tree.explanation_sc/total_users_explanation
      end
      if !tree.selfregulation_sc.nil?     
        tree.selfregulation_sc = tree.selfregulation_sc/total_users_explanation
      end

      tree.save
      puts "arbooooooooooool editadooooooooooooo"
      puts tree.inspect

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:id, :interpretation_sc, :analysis_sc, :evaluation_sc, :inference_sc, :explanation_sc,
      :selfregulation_sc, :name)
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_miscursos_visible
      @miscursos_visible = true
    end

    def set_ef_visible
      @ef_visible = true
    end

    def set_reporte_visible
      @reporte_visible = true
    end

    def set_actividades_visible
      @actividades_visible = true
    end

    def set_configuraciones_visible
      @Configuraciones_visible = true
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :description)
    end

    def set_breadcrumbs
      @breadcrumbs = []
    end
end