// Port of https://rosettacode.org/wiki/Chinese_remainder_theorem#C

func mul_inv(_ A: Int, _ B: Int) -> Int
{
    var a = A
    var b = B

    let b0 = b

    var t = b
    var q = b
    var x0 = 0
    var x1 = 1
    if b == 1 {
        return 1
    }
    while (a > 1) {
        q = a / b
        t = b
        b = a % b
        a = t
        t = x0
        x0 = x1 - q * x0
        x1 = t
    }
    if x1 < 0 {
        x1 += b0
    }
    return x1
}
 
func chinese_remainder(n : [Int], a: [Int]) -> Int
{
    var p = 0
    var prod = 1
    var sum = 0
 
    for i in 0..<n.count {
        prod *= n[i]
    }
 
    for i in 0..<n.count {
        p = prod / n[i]
        sum += a[i] * mul_inv(p, n[i]) * p
    }
 
    return sum % prod
}
