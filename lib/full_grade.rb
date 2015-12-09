class FullGrade

  def self.full_list(client)
    entries_columns = ''
    gradebook_entries = ''
    class_selection = ''
    client.user.eclasses_teaching['items'].each do |eclass|
      # Starts a loop to go through each element of the "items" hash within the client.user.eclasses_teaching method in the API
      client.user.eclasses_teaching['items'].each do |eclass|
        # Sets variable gradebooks equal to all gradebooks, accepts argument that says the eclass_id is equal to an "id" within "items" - in other words, it loops through and grabs gradebooks from each class belonging to the user
        gradebooks = client.gradebooks.all(eclass_id: eclass['id'])
        # Now that we have a list of gradebooks from all classes, go through the items hash in those gradebooks
        gradebooks['items'].each do |gradebook|
          # And, for each one, define entries within
          gradebook_entries = client.gradebooks.entries(eclass_id: eclass['id'], gradebook_id: gradebook['id'], include_scores: true)
          # Now we want to go through each entry and look int he items hash
          gradebook_entries['items'].each do |entry|
            # And we want to define columns (for use in a csv) as the keys for gradebook_entries - items, in the first array, then in the gradebook_entry_scores hash, then in the first array within that hash (since we just need column names)
            entries_columns = gradebook_entries['items'][0]['gradebook_entry_scores'][0].keys
          end
        end
      end
    # Now, we need to make a csv for entries - we are using the shortname of the class to name the file so the same file is not overwritten each time,
    # instead, a new file is created for each class
    CSV.open("entries_.csv", 'wb') do |csv|
      # Add a row for the column names defined above
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