class FullGrade

  def self.full_list(client)
    entries_columns = ''
    gradebook_entries = ''
    class_selection = ''
      client.user.eclasses_teaching['items'].each do |eclass|
        gradebooks = client.gradebooks.all(eclass_id: eclass['id'])
        gradebooks['items'].each do |gradebook|
          gradebook_entries = client.gradebooks.entries(eclass_id: eclass['id'], gradebook_id: gradebook['id'], include_scores: true)
          gradebook_entries['items'].each do |entry|
            entries_columns = gradebook_entries['items'][0]['gradebook_entry_scores'][0].keys
          end
      end
    CSV.open("entries_#{eclass['id']}.csv", 'wb') do |csv|
      csv << entries_columns
      gradebook_entries['items'].each do |y|
        y['gradebook_entry_scores'].each do |y|
          csv << y.values
        end
      end
    end
  end
end
end