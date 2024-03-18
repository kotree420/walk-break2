class WithLineBreakValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # ビューのformでの改行コードとRailsでの改行コードの文字数の違いに対応する
    if current_text_length = value&.gsub(/\r\n/, "\n")&.length
      if current_text_length > options[:maximum]
        record.errors.add(attribute, "#{options[:maximum]}文字以内")
      end
    end
  end
end
