//: Playground - noun: a place where people can play

import UIKit

//1、显示当前准确的中文时间，包括北京、东京、纽约、伦敦，格式为（2016年9月28日星期三 上午10:25）
func getTime(date:Date,zone:Int=0)->String{
    let dformatter=DateFormatter()
    dformatter.dateFormat = "yyyy年MM月dd日EEEE aa KK:mm"
    dformatter.locale = Locale.current // 设置当前位置
    if zone >= 0{//当传入的为正数时，在东半区
        dformatter.timeZone = TimeZone(abbreviation: "UTC+\(zone):00")
    }else {//当传入的为负数时，在西半区
        dformatter.timeZone = TimeZone(abbreviation: "UTC\(zone):00")
    }
    let dateString = dformatter.string(from:now) //将传入的日期格式转化为字符串
    return dateString
}

let now = Date() //获取当前时间日期

let beijing = getTime(date: now,zone:+8)//获取当前北京的时间
print("北京：\(beijing)")//输出

let tokyo = getTime(date: now,zone:9)//获取当前东京的时间
print("东京：\(tokyo)")
let newYork = getTime(date: now, zone: -4)  //获取当前纽约的时间
print("纽约: \(newYork)")

let london = getTime(date: now, zone: 1)  ////获取当前伦敦的时间
print("伦敦: \(london)")


//2、处理字符串
//新建字符串
let str="Swift is a powerful and intuitive programming language for iOS, OS X, tvOS, and watchOS."
//返回子串
let index1 = str.index(str.startIndex,offsetBy:5)
let index2 = str.index(str.startIndex, offsetBy: 20)
let subStr = str[index1..<index2]
print("从第6个字符到第20个字符的子串为：")
print(subStr)
//删除其中所有的OS字符
let subStr2 = str.replacingOccurrences(of: "OS", with: "")
print("删除OS后")
print(subStr2)

//3、将1、2题的时间和字符串存入一个字典中，并存入沙盒中的Document某文件中
let dictionary = ["date":["beijing":beijing,"tokyo":tokyo,"newYork":newYork,"london":london],"string":subStr2] as AnyObject //将字典转换为任意类型，方便后面写入文件
let defaultWork = FileManager.default //获取默认工作路径
//获取工作路径下的Document文件夹
if var path = defaultWork.urls(for: .documentDirectory, in: .userDomainMask).first?.path{
    path.append("/test.txt")//在文件夹路径下增加一个test.txt
    print(dictionary.write(toFile:path,atomically:true)) //新建上面指定的文件，并将数据写入（输出：true）
}

//4、从网上下载一张照片并保存到本地沙盒的Document的某文件中
let image = URL(string: "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1192412758,1563948098&fm=27&gp=0.jpg")!// 通过指定的URL获取图片转换为二进制数据
let imageData = try? Data(contentsOf: image)//转换为二进制数据
if var url = defaultWork.urls(for: .documentDirectory, in: .userDomainMask).first{
    url.appendPathComponent("image.jpg")
    try imageData?.write(to: url)
}

//5、从网上查找访问一个JSon接口文件，并采用JSONSerialization和字典对其进行简单解析；
let url = URL(string: "http://www.weather.com.cn/weather/101270101.shtml")! //api的路径
let data = try Data(contentsOf: url)  //将json转换为二进制数据
let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)  //序列化json

//解析json数据
if let dictionary = json as? [String:Any] {
    if let weather = dictionary["weatherinfo"] as? [String:Any] {
        let temp1 = weather["temp1"]
        let temp2 = weather["temp2"]
        print("temp1:\(temp1),temp2:\(temp2)")
    }
}
