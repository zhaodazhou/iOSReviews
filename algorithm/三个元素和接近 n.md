# 三个元素和为 n

Given an integer array nums of length n and an integer target, find three integers in nums such that the sum is closest to target.

     Return the sum of the three integers.

     You may assume that each input would have exactly one solution.

      

     Example 1:

     Input: nums = [-1,2,1,-4], target = 1
     Output: 2
     Explanation: The sum that is closest to the target is 2. (-1 + 2 + 1 = 2).

## 实现方式

```Swift

var threeSumClosest_nums:[Int] = [1,1,1,0]
    var threeSumClosest_target:Int = 100
    func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
        let sNums = nums.sorted()
        
        /**
            解决方案之一，遍历了2遍
         var sub = Int.max
         var sum = 0
         for i in 0..<sNums.count {
             var lo = i + 1
             var hi = sNums.count - 1
             while lo < hi {
                 if abs(sNums[lo] + sNums[hi] + sNums[i] - target) < sub {
                     sum = sNums[lo] + sNums[hi] + sNums[i]
                     sub = abs(sNums[lo] + sNums[hi] + sNums[i] - target)
                 }
                 if sNums[lo] + sNums[hi] + sNums[i] > target {
                     hi -= 1
                 } else {
                     lo += 1
                 }
             }
         }
         return sum
         */
        
        /* 方案二，借鉴了threeSum的算法，找到第一个离target最近的值，算法性能还可以；
         而且性能比上面的还好一些，应该是和数据有关
         */
        var result:[[Int]] = []
        for index in 0..<10000 {
            result = matchTarget(sNums, target: target + index)
            if result.count > 0 {
                break
            }
            result = matchTarget(sNums, target: target - index)
            if result.count > 0 {
                break
            }
        }

        if result.isEmpty {
            return sNums[0] + sNums[1] + sNums[2]
        }
        let first = result[0]
        return first[0] + first[1] + first[2]
    }
    
    func matchTarget(_ sNums: [Int], target:Int) -> [[Int]] {
        let count = sNums.count
        var result:[[Int]] = []
        
        if count < 3 {
            return result
        }
        
        for i in 0..<count-2 {
            if i == 0 || (i > 0 && sNums[i] != sNums[i - 1]) {
                var lo = i + 1
                var hi = count - 1
                let sum = target - sNums[i]
                
                while lo < hi {
                    if sNums[lo] + sNums[hi] == sum {
                        result.append([sNums[i], sNums[lo], sNums[hi]])
                        while lo < hi && sNums[lo] == sNums[lo + 1] {
                            lo += 1
                        }
                        while lo < hi && sNums[hi] == sNums[hi - 1] {
                            hi -= 1
                        }
                        lo += 1
                        hi -= 1
                    } else if sNums[lo] + sNums[hi] < sum {
                        lo += 1
                    } else {
                        hi -= 1
                    }
                }
            }
        }
        
        return result
    }

```
