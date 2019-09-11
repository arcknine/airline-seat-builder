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
          let(:arg2) { 6 }
          let(:aisle_seats) { [['X','X',1], [2,'X','X',3],[4,5],[6,'X','X']] }

          it "should set the correct aisle seats to the queued passangers" do
            seater = SeatBuilder.new(arg1, arg2)
            seater.build
            expect(seater.allocated_seats.first).to eq(aisle_seats)
          end
        end

        describe 'method#set_window_seats' do
          let(:arg1) { [[2,3], [3,4], [3,2], [4,3]] }
          let(:arg2) { 20 }
          let(:window_seats) { [[19,'X',1],[2,'X','X',3],[4,5],[6,'X',20]] }

          it "should set the correct window seats to the queued passangers" do
            seater = SeatBuilder.new(arg1, arg2)
            seater.build
            expect(seater.allocated_seats.first).to eq(window_seats)
          end
        end

        describe 'method#set_center_seats' do
          let(:arg1) { [[2,3], [3,4], [3,2], [4,3]] }
          let(:arg2) { 30 }
          let(:center_seats) { [[19,25,1],[2,26,27,3],[4,5],[6,28,20]] }

          it "should set the correct center seats to the queued passangers" do
            seater = SeatBuilder.new(arg1, arg2)
            seater.build
            expect(seater.allocated_seats.first).to eq(center_seats)
          end
        end
      end
    end
  end
end