class ClassExport
  def self.class_list(client)
    hash = client.user.eclasses_teaching['items']

    # Pulls just the keys of the hash (the first values) to be used as
    # column names
    column_names = hash.first.keys

    # Sets variable s to be a CSV, starts a loop
    s = CSV.generate do |csv|
      # For each item csv, adds a row (which is what '<<' does) with
      # column_names (so one row)
      csv << column_names
      # For each item in hash (which is the list above that contains items
      # within the classes the user teaches)
      hash.each do |x|
        # Add the values (remember, key-value pair in a hash) to a new row
        # underneath the column headers
        csv << x.values
      end
    end
    # Writes the data (s) to a new file called "data.csv"
    File.write('class_list.csv', s)
    puts 'List exported to working directory.'
    puts ''
  end
end