//
//  Solution.swift
//  leetcode
//
//  Created by dazhou on 2021/9/25.
//

import Foundation


class Solution {
    /**
     Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.

     Notice that the solution set must not contain duplicate triplets.

      

     Example 1:

     Input: nums = [-1,0,1,2,-1,-4]
     Output: [[-1,-1,2],[-1,0,1]]
     */
    var threeSumData:[Int] = [3,0,-2,-1,1,2]
    func threeSum(_ nums: [Int]) -> [[Int]] {
        let sNums = nums.sorted()
        let count = sNums.count
        var result:[[Int]] = []
        
        if count < 3 {
            return result
        }
        
        for i in 0..<count-2 {
            //为了保证不加入重复的 list,因为是有序的，所以如果和前一个元素相同，只需要继续后移就可以
            if i == 0 || (i > 0 && sNums[i] != sNums[i - 1]) {
                //两个指针,并且头指针从i + 1开始，防止加入重复的元素
                var lo = i + 1
                var hi = count - 1
                let sum = 0 - sNums[i]
                
                while lo < hi {
                    if sNums[lo] + sNums[hi] == sum {
                        result.append([sNums[i], sNums[lo], sNums[hi]])
                        //元素相同要后移，防止加入重复的 list
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
    
    
    /**
     Given an integer array nums of length n and an integer target, find three integers in nums such that the sum is closest to target.

     Return the sum of the three integers.

     You may assume that each input would have exactly one solution.

      

     Example 1:

     Input: nums = [-1,2,1,-4], target = 1
     Output: 2
     Explanation: The sum that is closest to the target is 2. (-1 + 2 + 1 = 2).
     */
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
    
    
    var letterCombinations_data = "234"
    func letterCombinations(_ digits: String) -> [String] {
        let nums = ["2", "3", "4", "5", "6", "7", "8", "9"]
        let alphabet = [["abc"], ["def"], ["ghi"], ["jkl"], ["mno"], ["pqrs"], ["tuv"], ["wxyz"]]
        
        var tmp:[[String]] = []
        var totalCount = 1
        for digit in digits {
            let index = nums.firstIndex(of: String(digit))!
            let chars = alphabet[index]
            tmp.append(chars)
            totalCount = totalCount * chars.first!.count
        }
        
        if totalCount == 1 {
            return []
        }
        
        var resultList:[String] = []
        let str = tmp.first!.first!

        for char in str {
            resultList.append(String(char))
        }

        for i in 1..<tmp.count {
            let str = tmp[i].first!
    
            var resultList1:[String] = []
            for re in resultList {
                for char in str {
                    let t = re + String(char) 
                    resultList1.append(t)
                }
            }
            resultList = resultList1
        }
        
        return resultList
    }
    
    
    /**
     Given an array nums of n integers, return an array of all the unique quadruplets [nums[a], nums[b], nums[c], nums[d]] such that:

     0 <= a, b, c, d < n
     a, b, c, and d are distinct.
     nums[a] + nums[b] + nums[c] + nums[d] == target
     You may return the answer in any order.
     */
    var fourSum_data = [1,0,-1,0,-2,2]
    var fourSum_target = 0
    func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
        let sNums = nums.sorted()
        let count = sNums.count

        
        var result:[[Int]] = []
        for j in 0..<count - 3 {
            if j == 0 || (j > 0 && sNums[j] != sNums[j - 1]) {
                for i in j+1..<count-2 {
                    //防止重复的，不再是 i == 0 ，因为 i 从 j + 1 开始
                    if (i == j + 1 || sNums[i] != sNums[i - 1]) {
                        var lo = i + 1
                        var hi = count - 1
                        let sum = target - sNums[j] - sNums[i]
                        while lo < hi {
                            if sNums[lo] + sNums[hi] == sum {
                                result.append([sNums[j], sNums[i], sNums[lo], sNums[hi]])
                                while lo < hi && sNums[lo] == sNums[hi] {
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
            }
        }
        
        return result
    }
}
