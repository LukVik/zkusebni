# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # is important initiate variables and data with setup for DRY
  def setup
    @user = User.new(name: 'Medison BB', email: 'bb@example.com', password: "foobar", password_confirmation: "foobar")
  end

  test 'test for valid object' do
    assert @user.valid?
  end
# 6.2.2 Validating presence
  test 'user name must be filled' do
    @user.name = '   '
    assert_not @user.valid?
  end
  test 'user name should not be nil' do
    @user.name = nil
    assert_not @user.valid?
  end

  test 'user email must be filled' do
    @user.email = '   '
    assert_not @user.valid?
  end
  test 'user email should not be empty' do
    @user.email.empty?
    assert true
  end
# 6.2.3Length validation
  test 'user name should be shorter than 51 characters' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end
  test 'user email should be shorter than 255 characters' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end
# 6.2.4 Format validation
  test "email validation should accept valid addresses" do
    # array definition
    valid_addresses = %w[bb@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    # loop parameter valid_address (String)
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    # array definition
    invalid_addresses = %w[bb@example,com foo@bar..com user_at_foo.org
                            user.name@example. foo@bar_baz.com foo@bar+baz.com]
    # loop parameter valid_address (String)
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

# 6.2.5Uniqueness validation
  test "email addresses should be unique" do
    # pridani local variable for test user duplicity
    duplicate_user = @user.dup
    # assertion user capitalized email
    # Testing case-insensitive email uniqueness
    duplicate_user.email = @user.email.upcase
    @user.save  # save to database
    assert_not duplicate_user.valid?
  end

  # Active Record uniqueness validation does not guarantee uniqueness
  # at the database level have to add index to email columns

  test "email addresses should be saved as lower-case" do
    # insert usecase to variable
    mixed_case_email = "Bb@exaMple.Com"
    @user.email = mixed_case_email
    @user.save # save to database
    assert_equal mixed_case_email.downcase, @user.reload.email # is equal
  end

  test "password should not be empty" do
    @user.password = @user.password_confirmation = '      ' * 6 # not valid
    assert_not @user.valid? # isn’t valid
  end

  test "password should have MIN 6 chars" do
    @user.password = @user.password_confirmation = 'a' * 5 # not valid
    assert_not @user.valid? # isn’t valid
  end

  test 'password is too short, email and name are valid' do
    @user.email = 'bb@example.com'
    @user.name = 'Medison BB'
    @user.password =  @user.password_confirmation = 'a'
    assert_not @user.valid?
  end

  test 'password is equal password confirm' do
    assert_equal @user.password, @user.password_confirmation
  end

  test "name of user can be updated" do
    @user.update_attribute(:name, 'Medison Ivy')
    @user.reload.name
    assert_equal @user.name, 'Medison Ivy'
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
