class Array


  def mean
    sum.to_f / size
  end

  #http://en.wikipedia.org/wiki/Mean#Weighted_arithmetic_mean
  def weighted_mean(weights_array)
    raise "Each element of the array must have an accompanying weight.  Array length = #{self.size} versus Weights length = #{weights_array.size}" if weights_array.size != self.size
    w_sum = weights_array.sum
    w_prod = 0
    self.each_index {|i| w_prod += self[i] * weights_array[i].to_f}
    w_prod.to_f / w_sum.to_f
  end

  def average
    begin
      (sum / size)
    rescue
      0
    end
  end

  def every(n)
      select {|x| index(x) % n == 0}
  end
end
