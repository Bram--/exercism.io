require 'exercism/curriculum/clojure'
require 'exercism/curriculum/elixir'
require 'exercism/curriculum/go'
require 'exercism/curriculum/haskell'
require 'exercism/curriculum/javascript'
require 'exercism/curriculum/objective-c'
require 'exercism/curriculum/ocaml'
require 'exercism/curriculum/perl5'
require 'exercism/curriculum/python'
require 'exercism/curriculum/ruby'
require 'exercism/curriculum/scala'

class Exercism
  def self.curricula
    [
      :clojure,
      :elixir,
      :go,
      :haskell,
      :javascript,
      :objectivec,
      :ocaml,
      :perl5,
      :python,
      :ruby,
      :scala,
    ]
  end

  def self.current_curriculum
    @curriculum ||= begin
      Curriculum.new('./assignments').tap do |curriculum|
        curricula.each do |type|
          curriculum.add "exercism/#{type}_curriculum".classify.constantize.new
        end
      end
    end
  end

  def self.trails
    @trails ||= current_curriculum.trails.values
  end

  def self.languages
    @languages ||= current_curriculum.trails.keys.sort
  end
end

class Curriculum
  attr_reader :path, :trails
  def initialize(path)
    @path = path
    @trails = {}
  end

  def add(curriculum)
    @trails[curriculum.language.downcase.to_sym] = Trail.new(curriculum.language, curriculum.slugs, path)
  end

  def in(language)
    trails[language.to_sym]
  end

  def assign(exercise)
    self.in(exercise.language).assign(exercise.slug)
  end

  def available?(language)
    languages.include?(language.to_sym)
  end

  def languages
    trails.keys
  end

end
