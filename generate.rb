require "creek"
require "json"
require "faker"
require "fileutils"

Faker::Config.locale = "en-GB"
number_of_candidates_required = 150

# clean
FileUtils.rm_rf("./contracts")
Dir.mkdir("./contracts")

# reference data sets
privacy_policy = {
  text: "Privacy Notice: Get Into Teaching Information Service",
  createdAt: "2020-01-13T09:44:50",
  id: "0a203956-e935-ea11-a813-000d3a44a8e9",
}
File.write("./contracts/privacy_policy.json", JSON.pretty_generate(privacy_policy))

degree_status = [
  { id: 222_750_000, value: "Graduate or postgraduate" },
  { id: 222_750_001, value: "Final year" },
  { id: 222_750_002, value: "Second year" },
  { id: 222_750_003, value: "First year" },
  { id: 222_750_004, value: "I don''t have a degree and am not studying for one" },
  { id: 222_750_005, value: "Other" },
]
File.write("./contracts/degree_status.json", JSON.pretty_generate(degree_status))

uk_degree_grades = [
  { id: 222_750_000, value: "Not applicable" },
  { id: 222_750_001, value: "First class" },
  { id: 222_750_002, value: "2:1" },
  { id: 222_750_003, value: "2:2" },
  { id: 222_750_004, value: "Third class or below" },
  { id: 222_750_005, value: "Pass (grade unknown)" },
]
File.write("./contracts/uk_degree_grades.json", JSON.pretty_generate(uk_degree_grades))

teaching_subjects = [
  { id: "802655a1-2afa-e811-a981-000d3a276620", value: "Biology" },
  { id: "842655a1-2afa-e811-a981-000d3a276620", value: "Chemistry" },
  { id: "942655a1-2afa-e811-a981-000d3a276620", value: "English" },
  { id: "a42655a1-2afa-e811-a981-000d3a276620", value: "Maths" },
  { id: "ac2655a1-2afa-e811-a981-000d3a276620", value: "Physics" },
]
File.write("./contracts/teaching_subjects.json", JSON.pretty_generate(teaching_subjects))

countries = [
  { id: "0df4c2e6-74f9-e811-a97a-000d3a2760f2", value: "Australia" },
  { id: "19f4c2e6-74f9-e811-a97a-000d3a2760f2", value: "Barbados" },
  { id: "47f4c2e6-74f9-e811-a97a-000d3a2760f2", value: "China" },
  { id: "5df4c2e6-74f9-e811-a97a-000d3a2760f2", value: "Denmark" },
  { id: "83f4c2e6-74f9-e811-a97a-000d3a2760f2", value: "Germany" },
  { id: "85f4c2e6-74f9-e811-a97a-000d3a2760f2", value: "Ghana" },
  { id: "9ff4c2e6-74f9-e811-a97a-000d3a2760f2", value: "India" },
  { id: "0cf5c2e6-74f9-e811-a97a-000d3a2760f2", value: "Pakistan" },
  { id: "1cf5c2e6-74f9-e811-a97a-000d3a2760f2", value: "Poland" },
]
File.write("./contracts/countries.json", JSON.pretty_generate(countries))

education_phases = [
  { id: 222_750_000, value: "Primary" },
  { id: 222_750_001, value: "Secondary" },
]
File.write("./contracts/education_phases.json", JSON.pretty_generate(education_phases))

retake_gcse_status = [
  { id: 222_750_000, value: "Planning on Retaking GCSE" },
  { id: 222_750_001, value: "Not Answered" },
]
File.write("./contracts/retake_gcse_status.json", JSON.pretty_generate(retake_gcse_status))

initial_teacher_training_years = [
  { id: 12_907, value: "2009" },
  { id: 12_908, value: "2010" },
  { id: 12_909, value: "2011" },
  { id: 12_910, value: "2012" },
  { id: 12_911, value: "2013" },
  { id: 12_912, value: "2014" },
  { id: 12_913, value: "2015" },
  { id: 12_914, value: "2016" },
  { id: 12_917, value: "Not sure" },
  { id: 12_918, value: "2017" },
  { id: 22_300, value: "2018" },
  { id: 22_301, value: "2019" },
  { id: 22_302, value: "2020" },
  { id: 22_303, value: "2021" },
  { id: 22_304, value: "2022" },
  { id: 22_305, value: "2023" },
  { id: 22_306, value: "2024" },
]
File.write("./contracts/initial_teacher_training_years.json", JSON.pretty_generate(initial_teacher_training_years))

qualification_types = [
  { id: 222_750_000, value: "Degree" },
  { id: 222_750_001, value: "Professional/vocational" },
  { id: 222_750_002, value: "Teaching qualification" },
  { id: 222_750_003, value: "Undergraduate" },
  { id: 222_750_004, value: "Other" },
  { id: 222_750_005, value: "Degree Equivalent" },
  { id: 222_750_006, value: "Postgraduate" },
  { id: 222_750_007, value: "A level or equivalent" },
  { id: 222_750_008, value: "GCSE or equivalent" },
]
File.write("./contracts/qualification_types.json", JSON.pretty_generate(qualification_types))

def yes_no_options(option)
  case option
  when "Yes"
    222_750_000
  when "No"
    222_750_001
  else
    option
  end
end

def primary_secondary_options(option)
  case option
  when "Primary"
    222_750_000
  when "Secondary"
    222_750_001
  else
    option
  end
end

# create contract test fixture files

multi_choice_fields = %w[subjectTaughtId preferredTeachingSubjectId degreeSubject ukDegreeGradeId countryId]

workbook = Creek::Book.new "./Candidate Personna Data Profiles.xlsx"
worksheet = workbook.sheets.first
fixtures = worksheet.simple_rows.first(number_of_candidates_required)

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
      value = Faker::Date.birthday(min_age: 18, max_age: 50).to_time.round(10).iso8601(3).gsub("+01:00", "+00:00")
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

  # map values to ids for API

  unless api_fixture["subjectTaughtId"].nil?
    subject_taught = teaching_subjects.find { |entry| entry[:value] == api_fixture["subjectTaughtId"] } || {}
    api_fixture["subjectTaughtId"] = subject_taught[:id] || api_fixture["subjectTaughtId"]
  end

  unless api_fixture["preferredTeachingSubjectId"].nil?
    preferred_teaching_subject = teaching_subjects.find { |entry| entry[:value] == api_fixture["preferredTeachingSubjectId"] } || {}
    api_fixture["preferredTeachingSubjectId"] = preferred_teaching_subject[:id] || api_fixture["preferredTeachingSubjectId"]
  end

  unless api_fixture["degreeSubject"].nil?
    degree_subject = teaching_subjects.find { |entry| entry[:value] == api_fixture["degreeSubject"] } || {}
    api_fixture["degreeSubject"] = degree_subject[:id] || api_fixture["degreeSubject"]
  end

  unless api_fixture["countryId"].nil?
    country = countries.find { |entry| entry[:value] == api_fixture["countryId"] } || {}
    api_fixture["countryId"] = country[:id] || api_fixture["countryId"]
  end

  # CRM sees things differently from candidates for degrees

  # Do you have a degree? degreeStatusId & ukDegreeGradeId
  case api_fixture["degreeStatusId"]
  when "Yes"
    api_fixture["degreeStatusId"] = (degree_status.find { |x| x[:value] == "Graduate or postgraduate" } || {})[:id]
    api_fixture["degreeTypeId"] = (uk_degree_grades.find { |x| x[:value] == "Not applicable" } || {})[:id]
  when "No"
    api_fixture["degreeStatusId"] = (degree_status.find { |x| x[:value] == "I don''t have a degree and am not studying for one" } || {})[:id]
    api_fixture["degreeTypeId"] = (uk_degree_grades.find { |x| x[:value] == "Not applicable" } || {})[:id]
  when "I'm studying for a degree"
    api_fixture["degreeStatusId"] = (degree_status.find { |x| x[:value] == api_fixture["studyYear"] } || {})[:id]
    api_fixture["degreeTypeId"] = (uk_degree_grades.find { |x| x[:value] == "Not applicable" } || {})[:id]
  when "I have an equivalent qualification from another country"
    api_fixture["degreeStatusId"] = (degree_status.find { |x| x[:value] == "Graduate or postgraduate" } || {})[:id]
    api_fixture["degreeTypeId"] = (uk_degree_grades.find { |x| x[:value] == "Pass (grade unknown)" } || {})[:id]
  end

  api_fixture.delete "studyYear"

  unless api_fixture["ukDegreeGradeId"].nil?
    uk_degree_grade = uk_degree_grades.find { |entry| entry[:value] == api_fixture["ukDegreeGradeId"] } || {}
    api_fixture["ukDegreeGradeId"] = uk_degree_grade[:id] || api_fixture["ukDegreeGradeId"]
  end

  unless api_fixture["initialTeacherTrainingYearId"].nil?
    initial_teacher_training_year = initial_teacher_training_years.find { |entry| entry[:value] == api_fixture["initialTeacherTrainingYearId"] } || {}
    api_fixture["initialTeacherTrainingYearId"] = (initial_teacher_training_year[:id] || api_fixture["initialTeacherTrainingYearId"]).to_i
  end

  api_fixture["acceptedPolicyId"] = privacy_policy[:id]

  unless api_fixture["preferredEducationPhaseId"].nil?
    api_fixture["preferredEducationPhaseId"] = primary_secondary_options api_fixture["preferredEducationPhaseId"]
  end

  unless api_fixture["hasGcseMathsAndEnglishId"].nil?
    api_fixture["hasGcseMathsAndEnglishId"] = yes_no_options api_fixture["hasGcseMathsAndEnglishId"]
  end

  unless api_fixture["hasGcseScienceId"].nil?
    api_fixture["hasGcseScienceId"] = yes_no_options api_fixture["hasGcseScienceId"]
  end

  unless api_fixture["planningToRetakeGcseMathsAndEnglishId"].nil?
    api_fixture["planningToRetakeGcseMathsAndEnglishId"] = yes_no_options api_fixture["planningToRetakeGcseMathsAndEnglishId"]
  end

  unless api_fixture["planningToRetakeGcseScienceId"].nil?
    api_fixture["planningToRetakeGcseScienceId"] = yes_no_options api_fixture["planningToRetakeGcseScienceId"]
  end

  html_fixture["apiSubmission"] = api_fixture

  File.write("./contracts/candidate_#{row_index}.json", JSON.pretty_generate(html_fixture))
end
