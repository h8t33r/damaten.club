module GamesHelper
  def calc_uma(result)
    result -=25000
    case
    when result > 0
        render partial: "calc_result", locals: {color: "green", result: "+" + result.to_s}
    when result < 0
        render partial: "calc_result", locals: {color: "red", result: result}
    else
        render partial: "calc_result", locals: {color: "blue", result: "ERROR"}
    end
  end
end