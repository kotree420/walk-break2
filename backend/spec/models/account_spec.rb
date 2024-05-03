require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account){ Account.new(name: 'example account', email: 'account@example.com',
                            password: 'foobar', password_confirmation: 'foobar') }

  it 'account should be valid' do
    expect(account).to be_valid
  end

  it 'name should be present' do
    account.name = ''
    expect(account).to be_invalid
  end

  it 'name should be unique' do
    account.save
    duplicate_name_account = Account.new(name: 'example account', email: 'account2@example.com')
    expect(duplicate_name_account).to be_invalid
  end

  it 'name should be less than 20' do
    account.name = 'a' * 21
    expect(account).to be_invalid
  end

  it 'email should be present' do
    account.email = ''
    expect(account).to be_invalid
  end

  it 'email should be less than 255' do
    account.email = 'a' * 244 + '@example.com'
    expect(account).to be_invalid
  end

  it 'email should accept valid addresses' do
    valid_emails = %w[user@example.com foo@foo.bar]

    valid_emails.each do |valid_email|
      account.email = valid_email
      expect(account).to be_valid, "#{valid_email.inspect} should be valid"
    end
  end

  it 'email should reject invalid addresses' do
    invalid_emails = %w[user@example,com user@example.com@com flXY8goaIkuMcaZyEpA]

    invalid_emails.each do |invalid_email|
      account.email = invalid_email
      expect(account).to be_invalid, "#{invalid_email.inspect} should be invalid"
    end
  end

  it 'email shoule be unique' do
    account.save
    duplicate_email_account = Account.new(name: 'example account2', email: 'account@example.com')
    duplicate_email_account.email.downcase! # 大文字小文字を区別しない
    expect(duplicate_email_account).to be_invalid
  end

  it 'password should be present' do
    account.password = account.password_confirmation = ''
    expect(account).to be_invalid
  end

  it 'password should be more than 6' do
    account.password = account.password_confirmation = '' * 5
    expect(account).to be_invalid
  end
end
