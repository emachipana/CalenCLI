# frozen_string_literal: true

# select dates based on week

def select_dates(events)
  events.select do |event|
    Date.parse(event['start_date']) == @actual_date
  end
end

def print_title
  print '-'.colorize(mode: :bold, color: :blue) * 30
  print ' Welcome to CalenCLI '.colorize(mode: :bold, color: :blue)
  puts '-'.colorize(mode: :bold, color: :blue) * 30
  puts "\n"
end

def print_menu
  puts "\n"
  puts '-'.colorize(mode: :bold, color: :blue) * 81
  puts 'list | create | show | update | delete | next | prev | clear | exit'.colorize(mode: :bold, color: :green)
end

# title colorized by eventss

def title_colorized(type_event, title, id)
  case type_event
  when 'default'
    "#{title} (#{id})".colorize(mode: :bold)
  when 'tech'
    "#{title} (#{id})".colorize(color: :red, mode: :bold)
  when 'english'
    "#{title} (#{id})".colorize(color: :magenta, mode: :bold)
  when 'soft-skills'
    "#{title} (#{id})".colorize(color: :green, mode: :bold)
  when 'web-dev'
    "#{title} (#{id})".colorize(color: :yellow, mode: :bold)
  else
    "#{title} (#{id})".colorize(mode: :bold)
  end
end

def list(events)
  i = 0
  print " "*32
  puts @actual_date.strftime('%a %d %b %Y').colorize(color: :yellow, mode: :bold)
  puts "\n"
  events.each do |_event|
    puts "\n"
    print @actual_date.strftime('%a %b %d').colorize(color: :light_red, mode: :bold) unless i >= 7
    event = select_dates(events)
    event.each do |value|
      title = title_colorized(value['calendar'], value['title'], value['id'])
      start_date = DateTime.parse(value['start_date']).strftime('%H:%M')
      if value['end_date'].empty?
        print ' ' * 17
        puts title
      else
        print ' ' * 3
        end_date = DateTime.parse(value['end_date']).strftime('%H:%M')
        puts "#{start_date} - #{end_date} ".colorize(mode: :bold, color: :light_blue) + title.to_s
      end
      puts "\n"
      print ' ' * 10
    end
    print ' ' * 17 if event.empty?
    puts 'No events'.colorize(mode: :bold, background: :red) if event.empty?
    i += 1
    @actual_date += 1
    break if i >= 7
  end
end

def get_inputs(options)
  puts "\n"
  print 'action: '
  option = gets.chomp
  until options.include?(option)
    puts 'Please enter a valid option'.colorize(mode: :bold, background: :red)
    print 'action: '
    option = gets.chomp
  end
  option
end

def prev_week
  @actual_date -= 14
end

def create(events)
  values = get_values_event
  id = events.last['id'] + 1
  event = generate_hash(values, id)
  @events.push(event)
end

def generate_hash(values, id)
  {
    'id' => id,
    'start_date' => values[:start_date],
    'title' => values[:title],
    'end_date' => values[:end_date],
    'notes' => values[:notes],
    'guests' => values[:guests],
    'calendar' => values[:calendar]
  }
end

def get_values_event
  date = valid_date
  print 'Title: '
  title = gets.chomp
  title = not_empty(title, 'Title: ')
  print 'Calendar: '
  calendar = gets.chomp
  calendar = 'default' if calendar.empty?
  start_end = valid_hour
  print 'Notes: '
  notes = gets.chomp
  print 'Guests: '
  guests = gets.chomp.split(', ')
  dates = generate_dates(start_end, date)
  guests = [] if guests.size.zero?
  { start_date: dates[0], title: title, end_date: dates[1], notes: notes, guests: guests, calendar: calendar }
end

def generate_dates(start_end, date)
  start_date = ''
  end_date = ''
  if start_end.empty?
    start_date = DateTime.new(date[0].to_i, date[1].to_i, date[2].to_i, 0, 0, 0, '-05:00').to_s
  else
    start_date = start_end[0].split(':')
    end_date = start_end[1].split(':')
    start_date = DateTime.new(date[0].to_i, date[1].to_i, date[2].to_i, start_date[0].to_i, start_date[1].to_i, 0,
                              '-05:00').to_s
    end_date = DateTime.new(date[0].to_i, date[1].to_i, date[2].to_i, end_date[0].to_i, end_date[1].to_i, 0,
                            '-05:00').to_s
  end
  [start_date, end_date]
end

def valid_date
  print 'Date: '
  date = gets.chomp.split('-')
  date = not_empty(date, 'Date: ')
  until Date.valid_date?(date[0].to_i, date[1].to_i, date[2].to_i)
    puts 'Enter a valid date: YYYY-MM-DD'.colorize(mode: :bold, background: :red)
    print 'Date: '
    date = gets.chomp.split('-')
  end
  date
end

def valid_hour
  print 'Start-end: '
  hour = gets.chomp.split
  start = hour[0].nil? ? [1, 1] : hour[0].split(':')
  end_d = hour[1].nil? ? [0, 0] : hour[1].split(':')
  while ((start[0].to_i * 10) + (start[1].to_i / 10)) > ((end_d[0].to_i * 10) + (end_d[1].to_i / 10))
    break if hour.empty?

    puts "Format: 'HH:MM HH:MM' or leave it empty".colorize(mode: :bold, background: :red)
    print 'Start-end: '
    hour = gets.chomp.split
    start = hour[0].nil? ? [1, 1] : hour[0].split(':')
    end_d = hour[1].nil? ? [0, 0] : hour[1].split(':')
  end
  hour
end

def not_empty(value, name_input)
  while value.empty?
    puts 'Cannot be blank'.colorize(mode: :bold, background: :red)
    print name_input
    value = gets.chomp
  end
  value
end

def show(events)
  id = get_id(events)
  event = events.find { |event_f| event_f['id'] == id }
  date = Date.parse(event['start_date'])
  start_end = ''
  start_date = DateTime.parse(event['start_date']).strftime('%H:%M') unless event['end_date'].empty?
  end_date = DateTime.parse(event['end_date']).strftime('%H:%M') unless event['end_date'].empty?
  start_end = "#{start_date} #{end_date}" unless event['end_date'].empty?
  puts "Date: #{date.year}-#{date.mon}-#{date.mday}"
  puts "Title: #{event['title']}"
  puts "Calendar: #{event['calendar']}"
  puts "Star-end: #{start_end}"
  puts "Notes: #{event['notes']}"
  puts "Guests: #{event['guests'].join(', ')}"
end

def get_id(events)
  print 'Event ID: '
  id = gets.chomp
  id = not_empty(id, 'Event ID: ')
  valid_id(id.to_i, events)
end

def valid_id(id, events)
  verify = events.find { |event_f| event_f['id'] == id }
  while verify.nil?
    puts 'Please enter a valid ID'.colorize(mode: :bold, background: :red)
    print 'Event ID: '
    id = gets.chomp.to_i
    verify = events.find { |event_f| event_f['id'] == id }
  end
  id
end

def update(events)
  id = get_id(events)
  values = get_values_event
  @events.reject! { |event| event['id'] == id }
  event = generate_hash(values, id)
  @events.push(event)
end

def delete(events)
  id = get_id(events)
  @events.reject! { |event| event['id'] == id }
end
