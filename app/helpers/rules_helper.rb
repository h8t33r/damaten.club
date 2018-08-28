module RulesHelper
  def rule_qualifier(romaji_name, name, type, description)

    if type == "switch"
      render partial: "rule_form_switcher", locals: {name: name, romaji_name: romaji_name, description: description}
    elsif type == "numeric"
      render partial: "rule_form_field", locals: {name: name, romaji_name: romaji_name, description: description}
    else
      "have no field #{type}"
    end
  end
end
