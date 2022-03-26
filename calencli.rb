# frozen_string_literal: true

require 'date'
require 'colorize'
require_relative 'methods'

# actual date starting monday of each week

@actual_date = Date.today
day = @actual_date.wday > 1 ? @actual_date.wday - 1 : 0
@actual_date -= day

# data of events 

id = 0
@events = [
  { 'id' => (id = id.next),
    'start_date' => '2021-11-15T00:00:00-05:00',
    'title' => 'Ruby Basics 1',
    'end_date' => '',
    'notes' => 'Ruby Basics 1 notes',
    'guests' => %w[Teddy Codeka],
    'calendar' => 'web-dev' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-15T12:00:00-05:00',
    'title' => 'English Course',
    'end_date' => '2021-11-15T13:30:00-05:00',
    'notes' => 'English notes',
    'guests' => ['Stephanie'],
    'calendar' => 'english' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-16T00:00:00-05:00',
    'title' => 'Ruby Basics 2',
    'end_date' => '',
    'notes' => 'Ruby Basics 2 notes',
    'guests' => %w[Andre Codeka],
    'calendar' => 'web-dev' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-16T12:45:00-05:00',
    'title' => 'Soft Skills - Mindsets',
    'end_date' => '2021-11-15T13:30:00-05:00',
    'notes' => 'Some extra notes',
    'guests' => ['Diego'],
    'calendar' => 'soft-skills' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-17T00:00:00-05:00',
    'title' => 'Ruby Methods',
    'end_date' => '',
    'notes' => 'Ruby Methods notes',
    'guests' => %w[Diego Andre Teddy Codeka],
    'calendar' => 'web-dev' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-17T12:00:00-05:00',
    'title' => 'English Course',
    'end_date' => '2021-11-15T13:30:00-05:00',
    'notes' => 'English notes',
    'guests' => ['Stephanie'],
    'calendar' => 'english' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-18T09:00:00-05:00',
    'title' => 'Summary Workshop',
    'end_date' => '2021-11-19T13:30:00-05:00',
    'notes' => 'A lot of notes',
    'guests' => %w[Diego Teddy Andre Codeka],
    'calendar' => 'web-dev' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-18T09:00:00-05:00',
    'title' => 'Extended Project',
    'end_date' => '',
    'notes' => '',
    'guests' => [],
    'calendar' => 'web-dev' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-19T09:00:00-05:00',
    'title' => 'Extended Project',
    'end_date' => '',
    'notes' => '',
    'guests' => [],
    'calendar' => 'web-dev' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-19T12:00:00-05:00',
    'title' => 'English for Engineers',
    'end_date' => '2021-11-19T13:30:00-05:00',
    'notes' => 'English notes',
    'guests' => ['Stephanie'],
    'calendar' => 'english' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-20T10:00:00-05:00',
    'title' => 'Breakfast with my family',
    'end_date' => '2021-11-20T11:00:00-05:00',
    'notes' => '',
    'guests' => [],
    'calendar' => 'default' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-20T15:00:00-05:00',
    'title' => 'Study',
    'end_date' => '2021-11-20T20:00:00-05:00',
    'notes' => '',
    'guests' => [],
    'calendar' => 'default' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-25T09:00:00-05:00',
    'title' => 'Extended Project',
    'end_date' => '',
    'notes' => '',
    'guests' => [],
    'calendar' => 'web-dev' },
  { 'id' => (id = id.next),
    'start_date' => '2021-11-26T09:00:00-05:00',
    'title' => 'Extended Project',
    'end_date' => '',
    'notes' => '',
    'guests' => [],
    'calendar' => 'web-dev' }
]

# main flow

def start
  options = 'list | create | show | update | delete | next | prev | clear | exit'.split(' | ')
  print_title
  list(@events)
  print_menu
  action = get_inputs(options)
  validation = true

  # main loop

  until validation == false
    case action
    when 'list'
      @actual_date -= 7
      list(@events)
    when 'create'
      create(@events)
      @actual_date -= 7
      list(@events)
    when 'show' then puts show(@events)
    when 'update'
      update(@events)
      @actual_date -= 7
      list(@events)
    when 'delete'
      delete(@events)
      @actual_date -= 7
      list(@events)
    when 'next' then list(@events)
    when 'prev'
      prev_week
      list(@events)
    when 'clear' then system('clear')
    when 'exit'
      puts ' Thanks for using CalenCLI '.chomp.colorize(mode: :bold, background: :black)
      puts '   By: Enmanuel Chipana '.chomp.colorize(mode: :bold, background: :black)
      validation = false
      break
    end
    print_menu
    action = get_inputs(options)
  end
end

# start app

start
