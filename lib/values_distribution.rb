class ValuesDistribution
  def initialize(values)
    @values, @occurence_spread = values, Hash.new(0)

    @values.each do |item|
      item = 'Unknown' if item.nil?

      @occurence_spread[item] += 1
    end
  end

  def most_occured
    return nil unless most_occured_value = @occurence_spread.max_by { |key, value| value }

    most_occured_value[0]
  end

  alias_method :favorite, :most_occured

  def count
    @values.size
  end 

  def occured(language)
    @occurence_spread[language]
  end

  def percentage_spread
    result = Hash.new(0)

    @occurence_spread.each do |language, count|
      result[language] = to_percents(count)
    end

    result
  end

private

  def to_percents(items_count)
    (items_count / count.to_f) * 100
  end
end