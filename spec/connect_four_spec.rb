# frozen_string_literal: true

require './connect_four'

describe Board do
  let(:board) { Board.new(3, 5) }

  describe 'special row col' do
    it { expect(board.rows).to eql 3 }
    it { expect(board.cols).to eql 5 }
    it { expect(board.board.length).to eql 3 }
    it { expect(board.board[0].length).to eql 5 }
    it { expect(board.board[0][0][:status]).to eql 'empty' }
    empty_board = "┏━━━━━━━━━┓\n┃-┃-┃-┃-┃-┃\n┃-┃-┃-┃-┃-┃\n┃-┃-┃-┃-┃-┃\n┗━━━━━━━━━┛"
    it { expect(board.show).to eql empty_board }
    it { expect(board.get_cell_str(0, 0)).to eql '┃-' }
    it { expect(board.get_cell_str(0, board.cols - 1)).to eql '┃-┃' }
    # it {expect(board.ask_col).to be_between(0,board.cols-1).inclusive}
    it { expect(board.col_empty?(0)).to eql true }
  end

  describe 'when default row col' do
    let(:default_board) { Board.new }
    it { expect(default_board.rows).to eql 6 }
    it { expect(default_board.cols).to eql 7 }
    it { expect(default_board.board.length).to eql 6 }
    it { expect(default_board.board[0].length).to eql 7 }
    it { expect(default_board.board[0][0][:status]).to eql 'empty' }
    empty_default_board = "┏━━━━━━━━━━━━━┓\n┃-┃-┃-┃-┃-┃-┃-┃\n┃-┃-┃-┃-┃-┃-┃-┃\n┃-┃-┃-┃-┃-┃-┃-\
┃\n┃-┃-┃-┃-┃-┃-┃-┃\n┃-┃-┃-┃-┃-┃-┃-┃\n┃-┃-┃-┃-┃-┃-┃-┃\n┗━━━━━━━━━━━━━┛"
    it { expect(default_board.show).to eql empty_default_board }
  end
end

describe Game do
  before { @game = Game.new }
  describe 'choose player colors' do
    # it {expect(@game.create_player_colors).to eql ['red','blue']}
    # it {expect(@game.player1.color).to eql 'red'}
    # it {expect(@game.player2.color).to eql 'blue'}
  end
end
