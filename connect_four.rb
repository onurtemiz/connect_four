# frozen_string_literal: true

class String
  def red
    "\e[31m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end
  end

class Board
  attr_accessor :rows, :cols, :board
  def initialize(rows = 6, cols = 7)
    @rows = rows
    @cols = cols
    @board = Array.new(@rows) { Array.new(@cols) }
    @rows.times do |row|
      @cols.times do |col|
        @board[row][col] = { status: 'empty' }
      end
    end
  end

  def get_cell_str(row_index, col_index)
    case @board[row_index][col_index][:status]
    when 'empty'
      @cols - 1 != col_index ? '┃-' : '┃-┃'
    when 'blue'
      @cols - 1 != col_index ? "┃#{'B'.blue}" : "┃#{'B'.blue}┃"
    when 'red'
      @cols - 1 != col_index ? "┃#{'R'.red}" : "┃#{'R'.red}┃"
    end
  end

  def get_cel_lines
    cell_lines = []
    @board.each_with_index do |row, row_index|
      cell_line = ''
      row.each_with_index do |_col, col_index|
        cell_line += get_cell_str(row_index, col_index)
      end
      cell_lines.push(cell_line)
    end
    cell_lines
  end

  def change_color(player_color)
    last_empty = find_last_empty
    last_empty[:status] = player_color
  end

  def find_last_empty
    picked_col = ask_col
    last_empty = nil
    @rows.times do |row|
      last_empty = @board[row][picked_col] if @board[row][picked_col][:status] == 'empty'
    end
    last_empty
  end

  def col_empty?(col)
    col_empty = false
    @board.each_with_index do |_row, row_index|
      col_empty = true if @board[row_index][col][:status] == 'empty'
    end
    col_empty
  end

  def ask_col
    answer = 0
    until answer < cols + 1 && answer > 0 && col_empty?(answer - 1)
      puts "1- #{@cols} arası bir sayı girin."
      answer = gets.chomp.to_i
    end
    answer - 1
  end

  def show
    board = []
    first_line = '┏' + '━' * (@cols * 2 - 1) + '┓'
    board.push(first_line)

    cell_lines = get_cel_lines
    cell_lines.each do |line|
      board.push(line)
    end

    last_line = '┗' + '━' * (@cols * 2 - 1) + '┛'
    board.push(last_line)
    board.join("\n")
  end
end

class Player
  attr_reader :color
  def initialize(color)
    @color = color
    @score = 0
  end
end

class Game
  attr_reader :player1, :player2
  def initialize(row = 6, col = 7)
    player_colors = create_player_colors
    @player1 = Player.new(player_colors[0])
    @player2 = Player.new(player_colors[1])
    @board = Board.new(row, col)
  end

  def ver_win?(color)
    @board.rows.times do |row|
      (@board.cols - 3).times do |col|
        quad_colors = []
        4.times do |num|
          quad_colors.push(@board.board[row][col + num][:status])
        end
        return true if quad_colors.all? { |x| x == color }
      end
    end
    false
  end

  def hor_win?(color)
    (@board.rows - 3).times do |row|
      @board.cols.times do |col|
        quad_colors = []
        4.times do |num|
          quad_colors.push(@board.board[row + num][col][:status])
        end
        return true if quad_colors.all? { |x| x == color }
      end
    end
    false
  end

  def diag_win?(color)
    (@board.rows - 3).times do |row|
      (@board.cols - 3).times do |col|
        quad_colors = []
        4.times do |num|
          quad_colors.push(@board.board[row + num][col + num][:status])
        end
        return true if quad_colors.all? { |x| x == color }
      end
    end
    false
  end

  def game_over?(color)
    return true if ver_win?(color) || hor_win?(color) || diag_win?(color)

    false
  end

  def player_won(player)
    puts @board.show
    case player
    when 'player1'
      puts "Player 1 -#{@player1.color.upcase}- Won!"
    when 'player2'
      puts "Player 2 -#{@player2.color.upcase}- Won!"
    end
    new_game
  end

  def new_game
    if play_again?
      game = Game.new
      game.play_game
    end
  end
  
  def play_again?
    yes_no = ''
    until yes_no == 'y' || yes_no == 'n'
      puts 'Play Again? Y/N'
      yes_no = gets.chomp.downcase
    end
    yes_no
  end
  

  def play_game
    loop do
      puts @board.show
      puts "Turn: #{@player1.color.upcase}"
      @board.change_color(@player1.color)
      if game_over?(@player1.color)
        return player_won('player1')
      else
        puts @board.show
        puts "Turn: #{@player2.color.upcase}"
        @board.change_color(@player2.color)
        return player_won('player2') if game_over?(@player2.color)
      end
    end
  end

  def create_player_colors
    player1_color = ask_color
    player2_color = player1_color == 'blue' ? 'red' : 'blue'
    [player1_color, player2_color]
  end

  def ask_color
    color = nil
    until color == 'red' || color == 'blue'
      puts 'First Player: Blue or Red?'
      color = gets.chomp.downcase
    end
    color
  end
end

game = Game.new
game.play_game