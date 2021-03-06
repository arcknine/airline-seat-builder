# frozen_string_literal: true

# build seating arrangement arg1 = 2d array, arg2 = total passengers
class SeatBuilder
  attr_reader :errors, :allocated_seats

  def initialize(seat_array = [], total_passengers = 0)
    @seat_array = seat_array
    @total_passengers = total_passengers.to_i
    @assigned_passenger = 0
    @errors = {}
  end

  def build
    return false unless valid?

    build_seats
    set_aisle_seats
    set_window_seats
    set_center_seats

    @allocated_seats = @sorted_seats

    true
  end

  def valid?
    if !@total_passengers =~ /\D/ || @total_passengers.to_i <= 0
      @errors[:argument2] = 'is invalid.'
    end

    begin
      validate_2d_array_and_max_seats
    rescue NoMethodError
      @errors[:argument1] = 'invalid 2d array.'
    end

    @errors.empty?
  end

  private

  def validate_2d_array_and_max_seats
    unless @seat_array.all? { |e| e.class == Array }
      @errors[:argument1] = 'invalid 2d array.'
    end

    max_seats = @seat_array.inject(0) { |sum, x| sum + x[0] * x[1] }
    return unless max_seats < @total_passengers

    @errors[:argument2] = 'exceed the number of seats.'
  end

  def build_seats
    @built_seats = []
    @seat_array.each do |arr|
      @built_seats <<  (1..arr[0]).map { |_| Array.new(arr[1]) { 'X' } }
    end

    max_columns = @seat_array.map(&:last).max
    @sorted_seats = []
    (1..max_columns).each_with_index do |_, index|
      @sorted_seats << @built_seats.map { |col| col[index] }
    end
  end

  def set_aisle_seats
    @sorted_seats.each_with_index do |row, row_index|
      row.each_with_index do |group, group_index|
        next if group.nil? || !remaining_seats?

        if [row.first, row.last].include?(group)
          window_aisle_groups(row, row_index, group, group_index)
        else
          middle_aisle_group(row_index, group, group_index)
        end
      end
    end
  end

  def window_aisle_groups(*args)
    index = args[2] == args[0].first ? -1 : 0
    allocate_seat(args[1], args[3], index)
  end

  def middle_aisle_group(row_index, group, group_index)
    allocate_seat(row_index, group_index, 0)
    return if group.count <= 1 && !remaining_seats?

    allocate_seat(row_index, group_index, group.count - 1)
  end

  def set_window_seats
    @sorted_seats.each_with_index do |row, row_index|
      row.each_with_index do |group, group_index|
        next if group.nil? || !remaining_seats?

        if group == row.first
          allocate_seat(row_index, group_index, 0)
        elsif group == row.last
          allocate_seat(row_index, group_index, -1)
        end
      end
    end
  end

  def set_center_seats
    @sorted_seats.each_with_index do |row, row_index|
      row.each_with_index do |group, group_index|
        next if group.nil? || (group.count < 3 && !remaining_seats?)

        group.each_with_index do |_, index|
          if ![0, group.size - 1].include?(index) && remaining_seats?
            allocate_seat(row_index, group_index, index)
          end
        end
      end
    end
  end

  def allocate_seat(row_index, group_index, column_index)
    @assigned_passenger += 1
    @sorted_seats[row_index][group_index][column_index] = @assigned_passenger
  end

  def remaining_seats?
    @assigned_passenger < @total_passengers
  end
end
