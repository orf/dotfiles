function percent -d "Calculate percentages"
  set value_1 = "$argv[1]"
  set value_2 = "$argv[2]"
  set total = (awk -v t1="$value_1" -v t2="$value_2" 'BEGIN{print 100 * (t1/t2)}')
  echo "$total"%
end
