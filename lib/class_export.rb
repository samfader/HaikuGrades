class ClassExport
  def self.class_list(client)
    hash = client.user.eclasses_teaching['items']

    column_names = hash.first.keys

    s = CSV.generate do |csv|
      csv << column_names
      hash.each do |x|
        csv << x.values
      end
    end
    File.write('class_list.csv', s)
    puts 'List exported to working directory.'
    puts ''
  end
end