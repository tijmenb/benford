class Benford

  def load!(nums)
    @numbers = []
    nums.each do |num|
      num.gsub!(".", "")
      num.gsub!(",", "")
      @numbers << num.to_s if num.is_numeric?
    end
  end
  
  # P(d) = log10(1 + 1/d)
  def law
    return @benford unless @benford.nil?
    benford = {}
    (1..9).each { |d| benford[d.to_s] = Math.log10( 1 + 1 / d.to_f) }
    @benford = benford
  end
  
  def counts
    return @digit_counts unless @digit_counts.nil?
    digit_counts = Hash.new(0)
    numbers.each do |v|
      digit_counts[v.first] += 1
    end
    @digit_counts = digit_counts
  end
  
  def distribution
    return @dist unless @dist.nil?
    dist = Hash.new(0.0)
    counts.each do |k, v|
      dist[k] = v.to_f / numbers.count
    end
    @dist = dist
  end
  
  def numbers 
    @numbers
  end
  
  def deviation
    return @variants unless @variants.nil?
    variants = Hash.new(0.0)
    law.each do |digit, occurence|
      variants[digit] = distribution[digit] - occurence
    end
    @variants = variants
  end
  
end


class String
  
  def first
    self.to_i.to_s[0,1]
  end
  
  def is_numeric?
    self.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
end
