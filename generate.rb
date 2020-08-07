require "creek"
require "json"
require "faker"

Faker::Config.locale = "en-GB"

multi_choice_fields = %w[subjectTaughtId preferredTeachingSubjectId degreeSubject ukDegreeGradeId countryId]

workbook = Creek::Book.new "./Candidate Personna Data Profiles.xlsx"
worksheet = workbook.sheets.first
fixtures = worksheet.simple_rows.first(188)

field_labels = []
api_parameters = []
optionals = []

fixtures.each_with_index do |row, row_index|
  if row_index < 5
    field_labels = row    if row_index == 1
    api_parameters = row  if row_index == 3
    optionals = row       if row_index == 4

    next
  end

  html_fixture = {}
  api_fixture = {
    # some default values are sent by the clients to the API
    "countryId" => "0df4c2e6-74f9-e811-a97a-000d3a2760f2",
    "preferredEducationPhaseId" => 222_750_001,
  }

  row.keys.each do |key|
    api_param = api_parameters.fetch(key)
    field_label = field_labels.fetch(key)
    optional = optionals.fetch(key)
    value = row.fetch(key)

    # the following columns are not required by the contract tests
    next if %w[AI AJ AK AL].include? key

    # if none of the columne have an attribute set ignore it
    next if api_param.nil? && field_label.nil?

    # optional attribute values are only used if the spreadsheet column has a value
    next if value.nil? && optional.nil?

    # generate Faker profile values for specific fields
    case api_param
    when "firstName"
      value = Faker::Name.first_name
    when "lastName"
      value = Faker::Name.last_name
    when "email"
      value = Faker::Internet.safe_email
    when "dateOfBirth"
      value = Faker::Date.birthday(min_age: 18, max_age: 50).to_time.round(10).utc.iso8601(3).gsub("Z", "+00:00")
    when "telephone"
      value = Faker::PhoneNumber.phone_number
    when "addressLine1"
      value = Faker::Address.street_address
    when "addressLine2"
      value = Faker::Address.secondary_address
    when "addressCity"
      value = Faker::Address.city
    when "addressPostcode"
      value = Faker::Address.zip_code
    end

    # can't seem to get rid of the decimal zero on these text fields
    if %w[initialTeacherTrainingYearId teacherId].include?(api_param) && !value.nil?
      value = value.gsub(".0", "")
    end

    # muliple choice fields where certain value have no real effect on the journey are seperated by a single / character
    if multi_choice_fields.include?(api_param) || field_label == "Study year"
      value = value.split("/").sample.strip! || value
    end

    # JSON should not include NULL values
    next if value.nil?

    # add the values to the hashes
    html_fixture[field_label] = value   unless field_label.nil?
    api_fixture[api_param] = value      unless api_param.nil? || %w[Service Persona].include?(api_param)
  end

  html_fixture["apiSubmission"] = api_fixture

  File.write("./contracts/candidate_#{row_index}.json", JSON.pretty_generate(html_fixture))
end
