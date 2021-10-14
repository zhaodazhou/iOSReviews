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
        if count < 4 {
            return result
        }
        
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
    
    /**
     Given the head of a linked list, remove the nth node from the end of the list and return its head.
     */
    var removeNthFromEnd_data = [1,2]
    var removeNthFromEnd_n = 2
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        var list:[Int] = []
        var tHead = head
        while tHead != nil {
            list.append(tHead!.val)
            tHead = tHead?.next
        }
        
        let index = list.count - n
        list.remove(at: index)
        
        /**
         这种方式有点尴尬，不如直接遍历出列表的长度后计算出位置，然后再遍历到该位置，这样就不用创建新的列表了。
         但从提交的结果来看，这种方式执行速度会快一点。
         如：removeNthFromEnd_1
         */
        
        return createNthHead(data: list)
    }
    
    func removeNthFromEnd_1(_ head: ListNode?, _ n: Int) -> ListNode? {
        let dummy = ListNode()
        dummy.next = head
        
        var count = 0
        var first = head
        while first != nil {
            count += 1
            first = first?.next
        }
        /**
         如果长度等于 1 和删除头结点的时候需要单独判断，其实我们只需要在 head 前边加一个空节点，就可以避免单独判断。
         */
        
        var length = count - n
        first = dummy
        while length > 0 {
            length -= 1
            first = first?.next
        }
        
        first?.next = first?.next?.next
        
        return dummy.next
    }
    
    func removeNthFromEnd_2(_ head: ListNode?, _ n: Int) -> ListNode? {
        /**
         只遍历一次的方式，定义2个指针，间隔n个距离，然后走下去。
         这种算法，速度更快
         */
        let dummy = ListNode()
        dummy.next = head
        var first:ListNode? = dummy
        var second:ListNode? = dummy
        
        for _ in 0...n {
            first = first?.next
        }
        while first != nil {
            first = first?.next
            second = second?.next
        }
        
        second?.next = second?.next?.next

        
        return dummy.next
    }
    
    func removeNthFromEnd_3(_ head: ListNode?, _ n: Int) -> ListNode? {
        /**
         这种算法不如removeNthFromEnd_2快，但思想比较有意思
         */
        var list:[ListNode] = []
        var h = head
        var len = 0
        while h != nil {
            list.append(h!)
            h = h?.next
            len += 1
        }
        if len == 1 {
            return nil
        }
        
        let remove = len - n
        if remove == 0 {
            return head?.next
        }
        
        let r = list[remove - 1]
        r.next = r.next?.next
        
        
        return head
    }
    
    func createNthHead(data:[Int]) -> ListNode? {
        var head:ListNode? = nil
        var tail:ListNode? = nil

        for item in data {
            let t = ListNode(item)
            if head == nil {
                head = t
            }
            
            if let tTail = tail {
                tTail.next = t
            }
            tail = t
        }
        return head
    }
    
    /**
     Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

     An input string is valid if:

     Open brackets must be closed by the same type of brackets.
     Open brackets must be closed in the correct order.
     */
    var isValid_s = "([{}]"
    func isValid(_ s: String) -> Bool {
        var list:[Character] = []
        
        for item in s {
            switch item {
            case "(", "[", "{":
                list.append(item)
            case ")", "]", "}":
                let t = list.popLast()
//                list.removeLast() 与 popLast 的区别，前者如果是操作empty数组，那会crash；后者不会
                if t == nil {
                    return false
                }
                
                
                if (t == "(" && item == ")") ||
                    (t == "[" && item == "]") ||
                    (t == "{" && item == "}")
                {
                    continue
                } else {
                    return false
                }
            default:
                continue
            }
        }
        
        if list.isEmpty {
            return true
        }
        
        return false
    }
    
    /**
     Merge two sorted linked lists and return it as a sorted list. The list should be made by splicing together the nodes of the first two lists.
     */
    var mergeTwoLists_l1 = [-9, 3]
    var mergeTwoLists_l2 = [5, 7]
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        /**
         Input: l1 = [1,2,4], l2 = [1,3,4]
         Output: [1,1,2,3,4,4]
         */
        
        if l1 == nil {
            return l2
        }
        if l2 == nil {
            return l1
        }
        
        let head:ListNode = ListNode()
        var tail:ListNode?
        var first = l1
        var second = l2
        while first != nil && second != nil {
            if tail == nil {
                tail = head
            }
            if first!.val <= second!.val {
                tail?.next = ListNode(first!.val)
                first = first?.next
            } else  {
                tail?.next = ListNode(second!.val)
                second = second?.next
            }
            tail = tail?.next
        }
        
        while first != nil {
            tail?.next = ListNode(first!.val)
            first = first?.next
            tail = tail?.next
        }
        
        while second != nil {
            tail?.next = ListNode(second!.val)
            second = second?.next
            tail = tail?.next
        }
        
        return head.next
    }
    
    func mergeTwoLists_2(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        /**
         与mergeTwoLists相比，主要优化在空间优化、与最后一步的判断方式
         */
        if l1 == nil {
            return l2
        }
        if l2 == nil {
            return l1
        }
        
        var head:ListNode = ListNode(0)
        let ans = head
        var first = l1
        var second = l2
        while first != nil && second != nil {
            if first!.val <= second!.val {
                head.next = first
                head = head.next!
                first = first!.next
            } else  {
                head.next = second
                head = head.next!
                second = second!.next
            }
        }
        
        if first == nil {
            head.next = second
        }
        if second == nil {
            head.next = first
        }
        
        return ans.next
    }
    
    func mergeTwoLists_1(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        /**
        递归解法
         */
        
        if l1 == nil {
            return l2
        }
        if l2 == nil {
            return l1
        }
        
        if l1!.val < l2!.val {
            l1?.next = mergeTwoLists_1(l1!.next, l2)
            return l1
        } else {
            l2?.next = mergeTwoLists_1(l1, l2!.next)
            return l2
        }
    }
    
    /**
     Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses.
     Input: n = 3
     Output: ["((()))","(()())","(())()","()(())","()()()"]
     */
    var generateParenthesis_n = 3
    func generateParenthesis(_ n: Int) -> [String] {
        return []
    }
}



public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 }
 
