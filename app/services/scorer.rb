class Scorer
  attr_accessor :reply, :tree

  def initialize(tree)
    @tree = tree
  end

  def call
    @tree
      .replies
      .map { |r| rate(r) }
      .reduce do |agg, r|
        {
          n:              agg[:n].to_i         + 1,
          content:        agg[:content]        + r[:content],
          interpretation: agg[:interpretation] + r[:interpretation],
          analysis:       agg[:analysis]       + r[:analysis],
          evaluation:     agg[:evaluation]     + r[:evaluation],
          inference:      agg[:inference]      + r[:inference],
          explication:    agg[:explication]    + r[:explication],
          selfregulation: agg[:selfregulation] + r[:selfregulation]
        }
      end
  end

  def rate reply
    # return {} if reply.attempts.count == 0
    p, a = reply.picks, reply.attempts
    {
      content:        p.content.correct.count.to_f / [a.count, 1].max,
      interpretation: p.of_type("Interpretación").select(&:right).count.to_f / [a.count, 1].max,
      analysis:       p.of_type("Análisis").select(&:right).count.to_f / [a.count, 1].max,
      evaluation:     p.of_type("Evaluación").select(&:right).count.to_f / [a.count, 1].max,
      inference:      p.of_type("Inferencia").select(&:right).count.to_f / [a.count, 1].max,
      explication:    p.of_type("Explicación").select(&:right).count.to_f / [a.count, 1].max,
      selfregulation: p.of_type("Autoregulación").select(&:right).count.to_f / [a.count, 1].max,
    }
  end
end