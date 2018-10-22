class RatingCalcWorker
  include Sidekiq::Worker

  def perform(n, d)
    Rule.create(name: n, data: d)
  end
end
