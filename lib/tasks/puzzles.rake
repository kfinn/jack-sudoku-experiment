namespace :puzzles do
  task :solve, [:puzzle_path] => :environment do |t, args|
    puzzle = nil
    File.open(args[:puzzle_path], 'r') do |file|
      puzzle = Puzzle.from_file(file)
      puts puzzle
      puts
      puzzle.solve!
      puts puzzle
    end
  end
end
