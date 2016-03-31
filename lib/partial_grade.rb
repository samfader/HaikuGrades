class PartialGrade
  
  def self.partial_list(class_selection, client)
    entries_columns = ''
    gradebook_entries = ''
    gradebooks = client.gradebooks.all(eclass_id: class_selection)
    gradebooks['items'].to_a.each do |gradebook|
      gradebook_entries = client.gradebooks.entries(eclass_id: class_selection, gradebook_id: gradebook['id'], include_scores: true)
      gradebook_entries['items'].each do |entry|
        entries_columns = gradebook_entries['items'][0]['gradebook_entry_scores'][0].keys
      end
    end

    CSV.open("entries_#{class_selection}.csv", 'wb') do |csv|
      csv << entries_columns
      gradebook_entries['items'].each do |y|
        y['gradebook_entry_scores'].each do |y|
          csv << y.values
        end
      end
    end
  end
end