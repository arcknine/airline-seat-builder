require 'rails_helper'

describe SeatBuilder do
  describe "initialize and build SeatBuilder" do

    context 'when input are is blank' do
      let(:arg1) { [] }
      let(:arg2) { nil }

      it "should build but return false and show error" do
        seater = SeatBuilder.new(arg1, arg2)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
      end
    end

    context 'when 2d array input is blank' do
      let(:arg1) { [] }
      let(:arg1_nil) { nil }
      let(:arg2) { 30 }

      it "should build but return false and error message exceed number of seats" do
        seater = SeatBuilder.new(arg1, arg2)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
        expect(seater.errors[:argument2]).to eq('exceed the number of seats.')
      end

      it "should build but return false and error message exceed number of seats" do
        seater = SeatBuilder.new(arg1_nil, arg2)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
        expect(seater.errors[:argument1]).to eq('invalid 2d array.')
      end
    end

    context 'when argument 2 is nil, empty, not a positive integer, 0, more than the seat number' do
      let(:arg1) { [[2,3], [3,4], [3,2], [4,3]] }
      let(:arg2_nil) { nil }
      let(:arg2_blank) { '' }
      let(:arg2_zero) { 0 }
      let(:arg2_negative) { -1 }
      let(:arg2_exceed) { 999999 }

      it "should build with nil argument2 but return false" do
        seater = SeatBuilder.new(arg1, arg2_nil)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
        expect(seater.errors[:argument2]).to eq('is invalid.')
      end

      it "should build with blank argument2 value but return false" do
        seater = SeatBuilder.new(arg1, arg2_blank)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
        expect(seater.errors[:argument2]).to eq('is invalid.')
      end

      it "should build with 0 argument2 value but return false" do
        seater = SeatBuilder.new(arg1, arg2_zero)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
        expect(seater.errors[:argument2]).to eq('is invalid.')
      end

      it "should build with 0 argument2 value but return false" do
        seater = SeatBuilder.new(arg1, arg2_negative)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
        expect(seater.errors[:argument2]).to eq('is invalid.')
      end

      it "should build with 0 argument2 value but return false" do
        seater = SeatBuilder.new(arg1, arg2_exceed)
        expect(seater.build).to eq(false)
        expect(seater.errors.count).not_to eq(0)
        expect(seater.errors[:argument2]).to eq('exceed the number of seats.')
      end
    end

    context 'when both arguments are valid' do
      let(:arg1) { [[2,3], [3,4], [3,2], [4,3]] }
      let(:arg2) { 30 }

      it "should build with no errors" do
        seater = SeatBuilder.new(arg1, arg2)
        expect(seater.build).to eq(true)
        expect(seater.allocated_seats).not_to be_nil
      end
    end

    describe 'method#build ' do
      context 'create seat and allocate passengers in queue' do
        describe 'method#set_aisle_seats' do
          let(:arg1) { [[2,3], [3,4], [3,2], [4,3]] }
          let(:arg2) { 30 }
          let(:aisle_seats) { (1..18).to_a }

          it "should set the correct aisle seats to the queued passangers" do
            seater = SeatBuilder.new(arg1, arg2)
            seater.build

            aisle_seat_array = []
            seater.allocated_seats.each do |row|
              row.each do |group|
                next if group.nil?

                if [row.first, row.last].include?(group)
                  index = group == row.first ? -1 : 0
                  aisle_seat_array << group.values_at(index)
                else
                  aisle_seat_array << group.values_at(0, -1)
                end
              end
            end

            expect(aisle_seat_array.flatten!).to eq(aisle_seats)
          end
        end

        describe 'method#set_window_seats' do
          let(:arg1) { [[2,3], [3,4], [3,2], [4,3]] }
          let(:arg2) { 30 }
          let(:window_seats) { (19..24).to_a }

          it "should set the correct window seats to the queued passangers" do
            seater = SeatBuilder.new(arg1, arg2)
            seater.build
            window_seats_array = []
            seater.allocated_seats.each do |row|
              row.each do |group|
                next if group.nil?

                if [row.first, row.last].include?(group)
                  index = group == row.first ? 0 : -1
                  window_seats_array << group[index]
                end
              end
            end

            expect(window_seats_array).to eq(window_seats)
          end
        end

        describe 'method#set_center_seats' do
          let(:arg1) { [[2,3], [3,4], [3,2], [4,3]] }
          let(:arg2) { 30 }
          let(:center_seats) { (25..30).to_a }

          it "should set the correct center seats to the queued passangers" do
            seater = SeatBuilder.new(arg1, arg2)
            seater.build
            center_seats_array = []
            seater.allocated_seats.each do |row|
              row.each do |group|
                next if group.nil? || group.count < 3

                group.each_with_index do |column, index|
                  next if column ==  'X'
                  center_seats_array << column unless [0, group.size - 1].include?(index)
                end
              end
            end

            expect(center_seats_array).to eq(center_seats)
          end
        end
      end
    end
  end
end