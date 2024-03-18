class CheckGuestRegexValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value =~ Constants::GUEST_USER_EMAIL_REGEX
      record.errors.add(attribute, "@example.comのドメインは使用できません")
    end
  end
end
