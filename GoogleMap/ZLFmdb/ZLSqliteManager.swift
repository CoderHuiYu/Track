//
//  ZLSqliteManager.swift
//  GoogleMap
//
//  Created by 余辉 on 2018/11/28.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit

class ZLSqliteManager: NSObject {
    static let sharInstance = ZLSqliteManager()
    var datebase : FMDatabase?
    func sqlPath(_ fileName:String) {
        //获取沙盒路径
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        path = path + "/" + fileName + ".sqlite"
        //传入路径，初始化数据库，若该路径没有对应的文件，则会创建此文件
        print("数据库user.sqlite 的路径===" + path)
        self.datebase = FMDatabase.init(path:path)
        self.datebase?.open()
    }
    
    //MARK: - 创建表格
    
    /// 创建表格
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - arFields: 表字段
    ///   - arFieldsType: 表属性
    func sqlCreateTable(tableName:String , arFields:Array<Any>, arFieldsType:Array<Any>){
        let db = self.datebase!
        if db.open() {
            var  sql = "create table if not exists " + tableName + "(id integer primary key autoincrement,"
            let arFieldsKey:[String] = arFields as! [String]
            let arFieldsType:[String] = arFieldsType as! [String]
            for i in 0..<arFieldsType.count {
                if i != arFieldsType.count - 1 {
                    sql = sql + arFieldsKey[i] + " " + arFieldsType[i] + ", "
                }else{
                    sql = sql + arFieldsKey[i] + " " + arFieldsType[i] + ")"
                }
            }
            do{
                try db.executeUpdate(sql, values: nil)
                print("数据库操作====" + tableName + "表创建成功！")
            }catch{
                print(db.lastErrorMessage())
            }
            
        }
        db.close()
        
    }
    
    //MARK: - 添加数据
    /// 插入数据
    ///
    /// - Parameters:
    ///   - tableName: 表名字
    ///   - dicFields: key为表字段，value为对应的字段值
    func sqlInsertDataToTable(tableName:String,dicFields:[String:Any]){
        let db = self.datebase!
        if db.open() {
            var keys = Array<String>()
            var values = Array<Any>()
            
            for key in dicFields.keys{
                keys.append(key)
            }
            for value in dicFields.values{
                values.append(value)
            }
            
            var sqlUpdatefirst = "INSERT INTO '" + tableName + "' ("
            var sqlUpdateLast = " VALUES("
            for i in 0..<keys.count {
                if i != keys.count-1 {
                    sqlUpdatefirst = sqlUpdatefirst + keys[i] + ","
                    sqlUpdateLast = sqlUpdateLast + "?,"
                }else{
                    sqlUpdatefirst = sqlUpdatefirst + keys[i] + ")"
                    sqlUpdateLast = sqlUpdateLast + "?)"
                }
            }
            do{
                try db.executeUpdate(sqlUpdatefirst + sqlUpdateLast, values: values)
                print("数据库操作==== 添加数据成功！")
            }catch{
                print(db.lastErrorMessage())
            }
            
        }
    }
    
    //MARK: - 修改数据
    /// 修改数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - dicFields: key为表字段，value为要修改的值
    ///   - ConditionsKey: 过滤筛选的字段
    ///   - ConditionsValue: 过滤筛选字段对应的值
    /// - Returns: 操作结果 true为成功，false为失败
    func sqlUpdateToData(tableName:String , dicFields:NSDictionary ,ConditionsKey:String ,ConditionsValue :Int)->(Bool){
        var result:Bool = false
        let arFieldsKey : [String] = dicFields.allKeys as! [String]
        var arFieldsValues:[Any] = dicFields.allValues
        arFieldsValues.append(ConditionsValue)
        var sqlUpdate  = "UPDATE " + tableName +  " SET "
        for i in 0..<dicFields.count {
            if i != arFieldsKey.count - 1 {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?,"
            }else {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?"
            }
            
        }
        sqlUpdate = sqlUpdate + " WHERE " + ConditionsKey + " = ?"
        let db = self.datebase!
        if db.open() {
            do{
                try db.executeUpdate(sqlUpdate, values: arFieldsValues)
                print("数据库操作==== 修改数据成功！")
                result = true
            }catch{
                print(db.lastErrorMessage())
            }
        }
        return result
    }
    
    //MARK: - 查询数据
    /// 查询数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - arFieldsKey: 要查询获取的表字段
    /// - Returns: 返回相应数据
    func sqlSelectFromTable(tableName:String,arFieldsKey:NSArray)->([NSMutableDictionary]){
        let db = self.datebase!
        let dicFieldsValue :NSMutableDictionary = [:]
        var arFieldsValue = [NSMutableDictionary]()
        let sql = "SELECT * FROM " + tableName
        if db.open() {
            do{
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    for i in 0..<arFieldsKey.count {
                        dicFieldsValue.setObject(rs.string(forColumn: arFieldsKey[i] as! String), forKey: arFieldsKey[i] as! NSCopying)
                    }
                    arFieldsValue.append(dicFieldsValue)
                }
            }catch{
                print(db.lastErrorMessage())
            }
            
        }
        return arFieldsValue
    }
    
    //MARK: - 删除数据
    /// 删除数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - FieldKey: 过滤的表字段
    ///   - FieldValue: 过滤表字段对应的值
    func sqlDeleteFromTable(tableName:String,FieldKey:String,FieldValue:Any) {
        let db = self.datebase!
        
        if db.open() {
            let  sql = "DELETE FROM '" + tableName + "' WHERE " + FieldKey + " = ?"
            do{
                try db.executeUpdate(sql, values: [FieldValue])
                print("删除成功")
            }catch{
                print(db.lastErrorMessage())
            }
        }
        
    }
}
