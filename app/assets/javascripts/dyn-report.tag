<dyn-report>
  <h1>{ title }</h1>

  <table class="table">
    <thead>
      <th>Contenido / Habilidad</th>
      <th>Contenido</th>
      <th>Interpretar</th>
      <th>Análisis</th>
      <th>Evaluación</th>
      <th>Inferencia</th>
      <th>Explicación</th>
      <th>Autoregulación</th>
      <th>N</th>
    </thead>
    <tbody>
      <tr each="{ trees }">
        <td onclick="{ selects(id) }">{ text }</td>
        <td onclick="{ selects(id) }">{ percent(content_sc) }</td>
        <td onclick="{ select_filter(id, 'Interpretación') }">{ percent(interpretation_sc) }</td>
        <td onclick="{ select_filter(id, 'Análisis') }">{ percent(analysis_sc) }</td>
        <td onclick="{ select_filter(id, 'Evaluación') }">{ percent(evaluation_sc) }</td>
        <td onclick="{ select_filter(id, 'Inferencia') }">{ percent(inference_sc) }</td>
        <td onclick="{ select_filter(id, 'Explicación') }">{ percent(explanation_sc) }</td>
        <td onclick="{ select_filter(id, 'Autoregulación') }">{ percent(selfregulation_sc) }</td>
        <td>{ total }</td>
      </tr>

      <tr>
        <td></td>
        <td each="{ averages }">{ percent(this.avg) }</td>
      </tr>
    </tbody>
  </table>

  <hr>

  <question-show each="{ detail.questions }" data="{ this }"></question-show>
  
  <style>
    /* The switch - the box around the slider */
    .switch {
      position: relative;
      display: inline-block;
      width: 60px;
      height: 34px;
    }

    /* Hide default HTML checkbox */
    .switch input {display:none;}

    /* The slider */
    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #ccc;
      -webkit-transition: .4s;
      transition: .4s;
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 26px;
      width: 26px;
      left: 4px;
      bottom: 4px;
      background-color: white;
      -webkit-transition: .4s;
      transition: .4s;
    }

    input:checked + .slider {
      background-color: #2196F3;
    }

    input:focus + .slider {
      box-shadow: 0 0 1px #2196F3;
    }

    input:checked + .slider:before {
      -webkit-transform: translateX(26px);
      -ms-transform: translateX(26px);
      transform: translateX(26px);
    }

    /* Rounded sliders */
    .slider.round {
      border-radius: 34px;
    }

    .slider.round:before {
      border-radius: 50%;
    }
  </style>

  <script>
    const course_id = opts.course_id;
    const report_id = opts.report_id;

    this.detail = [];
    this.averages = [];
    this.title = "Report";
    this.percent = (value) => {
      if (value)
        return Math.round(value * 100) + "%";
      else
        return "--";
    }
    this.average = (list) => {
      const avg = (elem) => {
        var elems = list.map((t) => t[elem]).filter((x) => x);
        return elems.reduce(((x, y) => x + y), null) / elems.length;
      };

      return ['content_sc', 'interpretation_sc', 'analysis_sc', 'evaluation_sc', 'inference_sc', 'explication_sc', 'selfregulation_sc'].map(   (elem) => {
          return { avg: avg(elem) };
        });
    }
    this.trees = [];
    this.on('mount', () => {
      $.ajax({
        url: "/courses/" + course_id + "/reports/" + report_id + ".json",
        success: (payload) => {
          var trees = payload.report.trees.sort((a,b) => a.text.localeCompare(b.text));
          this.update({ title: payload.report.name, trees: trees, averages: this.average(payload.report.trees) });
        }
      });
    });

    this.selects = (id) => {
      return () => {
        $.ajax({
          url: "/courses/1/trees/" + id + ".json",
          success: (payload) => {
            this.update({ detail: payload.tree });
          }
        })
      };
    }

    this.select_filter = (id, skill) => {
      return () => {
        $.ajax({
          url: "/courses/1/trees/" + id + ".json",
          success: (payload) => {
            var filtered = payload.tree.questions.filter((question) => question.skills.indexOf(skill) > -1);  // ugly as hell
            var tree     = Object.assign({}, payload.tree, { questions: filtered });

            this.update({ detail: tree });
          }
        })
      };
    }
  </script>
</dyn-report>